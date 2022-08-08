import 'dart:convert';
import 'dart:io';

import 'package:chime_example/MeetingSessionCreator.dart';
import 'package:chime_example/data/Attendee.dart';
import 'package:chime_example/data/Attendees.dart';
import 'package:chime_example/data/attendee_info.dart';
import 'package:chime_example/data/attendee_infos.dart';
import 'package:chime_example/data/audio_device.dart';
import 'package:device_info/device_info.dart';
import 'package:eggnstone_amazon_chime/eggnstone_amazon_chime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  String _version = 'Unknown';
  String _createMeetingSessionResult = 'CreateMeetingSession: Unknown';
  String _audioVideoStartResult = 'AudioVideo: Unknown';
  String _audioVideoStartLocalVideoResult = 'AudioVideoLocalVideo: Unknown';
  String _audioVideoStartRemoteVideoResult = 'AudioVideoRemoteVideo: Unknown';
  String _audioVideoMuteResult = 'AudioVideoMute: Unknown';
  String _listAudioDevicesResult = 'ListAudioDevices: Unknown';
  String _sendDataMessageResult = 'SendDataMessage: Unknown';
  List<AudioDevice> _audioDeviceList = [];

  Attendees _attendees = Attendees();
  final AttendeeInfos _attendeeInfos = AttendeeInfos();
  final AttendeeInfos _attendeeInfosMute = AttendeeInfos();
  bool _isAndroidEmulator = false;
  bool _isIosSimulator = false;

  @override
  void initState() {
    super.initState();

    _getPermission();
    _startChime();
  }

  @override
  Widget build(BuildContext context) {
    var chimeViewChildren = List<Widget>.empty(growable: true);

    if (_attendees.length == 0)
      chimeViewChildren
          .add(Expanded(child: Center(child: Text('No attendees yet.'))));
    else
      for (int attendeeIndex = 0;
          attendeeIndex < _attendees.length;
          attendeeIndex++) {
        Attendee attendee = _attendees[attendeeIndex];
        if (attendee.videoView != null)
          chimeViewChildren.add(Expanded(
              child: Center(
                  child: AspectRatio(
                      aspectRatio: attendee.aspectRatio,
                      child: attendee.videoView))));
      }

    var chimeViewColumn = Column(children: chimeViewChildren);

    Widget content;

    if (_isAndroidEmulator || _isIosSimulator)
      content = Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
              child: Text(
                  'Chime does not support Android/iOS emulators/simulators.\n\nIf you see the SDK version above then the connection to the SDK works though.')));
    else
      content = Column(children: [
        Text(_createMeetingSessionResult),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Text('Audio/Video:'),
          ElevatedButton(
              child: Text('Start'), onPressed: () => _audioVideoStart()),
          ElevatedButton(
              child: Text('Stop'), onPressed: () => _audioVideoStop())
        ]),
        Text(_audioVideoStartResult),
        SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Text('Local Video:'),
          ElevatedButton(
              child: Text('Start'),
              onPressed: () => _audioVideoStartLocalVideo()),
          ElevatedButton(
              child: Text('Stop'), onPressed: () => _audioVideoStopLocalVideo())
        ]),
        Text(_audioVideoStartLocalVideoResult),
        SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Text('Remote Video:'),
          ElevatedButton(
              child: Text('Start'),
              onPressed: () => _audioVideoStartRemoteVideo()),
          ElevatedButton(
              child: Text('Stop'),
              onPressed: () => _audioVideoStopRemoteVideo())
        ]),
        Text(_audioVideoStartRemoteVideoResult),
        SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Text('Mute Microphone:'),
          ElevatedButton(
              child: Text('Start'), onPressed: () => _audioVideoMute()),
          ElevatedButton(
              child: Text('Stop'), onPressed: () => _audioVideoUnmute())
        ]),
        Text(_audioVideoMuteResult),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Send Message:'),
            ElevatedButton(
                child: const Text('Start'),
                onPressed: () => _sendDataMessage('message')),
          ],
        ),
        Text(_sendDataMessageResult),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Number Of Attendees:'),
            Text(_attendeeInfos.length.toString()),
          ],
        ),
        SizedBox(height: 8),
        ExpansionTile(
          trailing: TextButton(
            child: Text('Get List'),
            onPressed: () => _listAudioDevices(),
          ),
          title: Text('Audio Lists:'),
          children: [
            for (AudioDevice _audioDevice in _audioDeviceList)
              ListTile(
                title: Text(_audioDevice.label),
                onTap: () => _chooseAudioDevice(_audioDevice.label),
              ),
          ],
        ),
        Text(_listAudioDevicesResult),
        SizedBox(height: 8),
        Expanded(child: chimeViewColumn)
      ]);

    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: Text('ChimePlugin')),
            body:
                Column(children: [Text(_version), Expanded(child: content)])));
  }

  Future<void> _getPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();
  }

  void _startChime() async {
    await _getVersion();

    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.isPhysicalDevice) {
        _addListener();
        await _createMeetingSession();
      } else {
        setState(() {
          _isAndroidEmulator = true;
        });
      }
    } else if (Platform.isIOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      if (iosInfo.isPhysicalDevice) {
        _addListener();
        await _createMeetingSession();
      } else {
        setState(() {
          _isIosSimulator = true;
        });
      }
    } else {
      _addListener();
      await _createMeetingSession();
    }
  }

  Future<void> _getVersion() async {
    String version;

    try {
      version = await Chime.version ?? '?';
    } on PlatformException {
      version = 'Failed to get version.';
    }

    if (mounted)
      setState(() {
        _version = version;
      });
  }

  void _addListener() {
    Chime.eventChannel.receiveBroadcastStream().listen((data) async {
      dynamic event = JsonDecoder().convert(data);
      String eventName = event['Name'];
      dynamic eventArguments = event['Arguments'];
      switch (eventName) {
        case 'OnVideoTileAdded':
          _handleOnVideoTileAdded(eventArguments);
          break;
        case 'OnVideoTileRemoved':
          _handleOnVideoTileRemoved(eventArguments);
          break;
        case 'OnAttendeesJoined':
          _handleOnAttendeesJoined(eventArguments);
          break;
        case 'OnAttendeesLeft':
          _handleOnAttendeesLeft(eventArguments);
          break;
        case 'OnAttendeesMuted':
          _handleOnAttendeesMuted(eventArguments);
          break;
        case 'OnAttendeesUnmuted':
          _handleOnAttendeesUnmuted(eventArguments);
          break;
        default:
          debugPrint(
              'Chime.eventChannel.receiveBroadcastStream().listen()/onData()');
          debugPrint('Warning: Unhandled event: $eventName');
          debugPrint('Data: $data');
          break;
      }
    }, onDone: () {
      debugPrint(
          'Chime.eventChannel.receiveBroadcastStream().listen()/onDone()');
    }, onError: (e) {
      debugPrint(
          'Chime.eventChannel.receiveBroadcastStream().listen()/onError()');
    });
  }

  Future<void> _createMeetingSession() async {
    if (await Permission.microphone.request().isGranted == false) {
      _createMeetingSessionResult = 'Need microphone permission.';
      return;
    }

    if (await Permission.camera.request().isGranted == false) {
      _createMeetingSessionResult = 'Need camera permission.';
      return;
    }

    String meetingSessionState;

    try {
      // Copy the file MeetingSessionCreator.dart.template to MeetingSessionCreator.dart.
      // Adjust MeetingSessionCreator to supply your proper authenticated meeting data.
      // (You can leave the dummy values but you will not be able to join a real meeting.)
      // This requires you to have an AWS account and Chime being set up there.
      // MeetingSessionCreator.dart is to be ignored by git so that your private data never gets committed.

      // See ChimeServer.js on how to create authenticated meeting data using the AWS SDK.

      meetingSessionState = await MeetingSessionCreator().create() ?? 'OK';
    } on PlatformException catch (e) {
      meetingSessionState =
          'Failed to create MeetingSession. PlatformException: $e';
    } catch (e) {
      meetingSessionState = 'Failed to create MeetingSession. Error: $e';
    }

    if (mounted)
      setState(() {
        _createMeetingSessionResult = meetingSessionState;
      });
  }

  Future<void> _audioVideoStart() async {
    String result;

    try {
      result = await Chime.audioVideoStart() ?? 'OK';
    } on PlatformException catch (e) {
      result = 'AudioVideoStart failed: PlatformException: $e';
    } catch (e) {
      result = 'AudioVideoStart failed: Error: $e';
    }

    if (mounted)
      setState(() {
        _audioVideoStartResult = result;
      });
  }

  Future<void> _audioVideoStop() async {
    String result;

    try {
      result = await Chime.audioVideoStop() ?? 'OK';
    } on PlatformException catch (e) {
      result = 'AudioVideoStop failed: PlatformException: $e';
    } catch (e) {
      result = 'AudioVideoStop failed: Error: $e';
    }

    if (mounted)
      setState(() {
        _audioVideoStartResult = result;
      });
  }

  Future<void> _audioVideoStartLocalVideo() async {
    String result;

    try {
      result = await Chime.audioVideoStartLocalVideo() ?? 'OK';
    } on PlatformException catch (e) {
      result = 'AudioVideoStartLocalVideo failed: PlatformException: $e';
    } catch (e) {
      result = 'AudioVideoStartLocalVideo failed: Error: $e';
    }

    if (mounted)
      setState(() {
        _audioVideoStartLocalVideoResult = result;
      });
  }

  Future<void> _audioVideoStopLocalVideo() async {
    String result;

    try {
      result = await Chime.audioVideoStopLocalVideo() ?? 'OK';
    } on PlatformException catch (e) {
      result = 'AudioVideoStopLocalVideo failed: PlatformException: $e';
    } catch (e) {
      result = 'AudioVideoStopLocalVideo failed: Error: $e';
    }

    if (mounted)
      setState(() {
        _audioVideoStartLocalVideoResult = result;
      });
  }

  Future<void> _audioVideoStartRemoteVideo() async {
    String result;

    try {
      result = await Chime.audioVideoStartRemoteVideo() ?? 'OK';
    } on PlatformException catch (e) {
      result = 'AudioVideoStartRemoteVideo failed: PlatformException: $e';
    } catch (e) {
      result = 'AudioVideoStartRemoteVideo failed: Error: $e';
    }

    if (mounted)
      setState(() {
        _audioVideoStartRemoteVideoResult = result;
      });
  }

  Future<void> _audioVideoStopRemoteVideo() async {
    String result;

    try {
      result = await Chime.audioVideoStopRemoteVideo() ?? 'OK';
    } on PlatformException catch (e) {
      result = 'AudioVideoStopRemoteVideo failed: PlatformException: $e';
    } catch (e) {
      result = 'AudioVideoStopRemoteVideo failed: Error: $e';
    }

    if (mounted)
      setState(() {
        _audioVideoStartRemoteVideoResult = result;
      });
  }

  Future<void> _audioVideoMute() async {
    String result;
    try {
      result = await Chime.mute() ?? 'OK';
    } on PlatformException catch (e) {
      result = 'AudioVideoMute failed: PlatformException: $e';
    } catch (e) {
      result = 'AudioVideoMute failed: Error: $e';
    }

    if (mounted) {
      setState(() {
        _audioVideoMuteResult = result;
      });
    }
  }

  Future<void> _audioVideoUnmute() async {
    String result;
    try {
      result = await Chime.unmute() ?? 'OK';
    } on PlatformException catch (e) {
      result = 'AudioVideoUnmute failed: PlatformException: $e';
    } catch (e) {
      result = 'AudioVideoUnmute failed: Error: $e';
    }

    if (mounted) {
      setState(() {
        _audioVideoMuteResult = result;
      });
    }
  }

  Future<void> _sendDataMessage(String text) async {
    String result;
    try {
      result = await Chime.sendDataMessage({'data': text}) ?? 'OK';
    } on PlatformException catch (e) {
      result = 'SendDataMessage failed: PlatformException: $e';
    } catch (e) {
      result = 'SendDataMessage failed: Error: $e';
    }

    if (mounted) {
      setState(() {
        _sendDataMessageResult = result;
      });
    }
  }

  Future<void> _listAudioDevices() async {
    String result;
    List<AudioDevice> resultList = [];
    try {
      resultList = await _getListAudioDevices();
      result = 'OK';
    } on PlatformException catch (e) {
      result = 'ListAudioDevices failed: PlatformException: $e';
    } catch (e) {
      result = 'ListAudioDevices failed: Error: $e';
    }

    if (mounted) {
      setState(() {
        _audioDeviceList = resultList;
        _listAudioDevicesResult = result;
      });
    }
  }

  Future<List<AudioDevice>> _getListAudioDevices() async {
    final String? listAudioDevices = await Chime.listAudioDevices();
    if (listAudioDevices == null) {
      return [];
    }
    List<AudioDevice> list = [];
    final List<dynamic> data = jsonDecode(listAudioDevices);

    for (dynamic audioDevice in data) {
      list = [
        AudioDevice(
          audioDevice['Label'],
          audioDevice['Type'],
          audioDevice['Order'],
          audioDevice['Port'],
          audioDevice['Description'],
        ),
        ...list
      ];
    }
    return list;
  }

  Future<void> _chooseAudioDevice(String label) async {
    String result;
    try {
      result = await Chime.chooseAudioDevice(label) ?? 'OK';
    } on PlatformException catch (e) {
      result = 'ChooseAudioDevice failed: PlatformException: $e';
    } catch (e) {
      result = 'ChooseAudioDevice failed: Error: $e';
    }

    if (mounted) {
      setState(() {
        _listAudioDevicesResult = result;
      });
    }
  }

  void _handleOnVideoTileAdded(dynamic arguments) async {
    bool isLocalTile = arguments['IsLocalTile'];
    int tileId = arguments['TileId'];
    String attendeeId = arguments['AttendeeId'];
    int videoStreamContentHeight = arguments['VideoStreamContentHeight'];
    int videoStreamContentWidth = arguments['VideoStreamContentWidth'];

    Attendee? attendee = _attendees.getByTileId(tileId);
    if (attendee != null) {
      debugPrint(
          'HandleOnVideoTileAdded called but already mapped. TileId=${attendee.tileId}, ViewId=${attendee.viewId}, VideoView=${attendee.videoView}');
      return;
    }

    debugPrint(
        'HandleOnVideoTileAdded: New attendee: TileId=$tileId => creating ChimeDefaultVideoRenderView');
    attendee = Attendee(tileId, isLocalTile, attendeeId,
        videoStreamContentHeight, videoStreamContentWidth);
    _attendees.add(attendee);

    Attendee nonNullAttendee = attendee;
    setState(() {
      nonNullAttendee.setVideoView(ChimeDefaultVideoRenderView(
          onPlatformViewCreated: (int viewId) async {
        nonNullAttendee.setViewId(viewId);
        debugPrint(
            'ChimeDefaultVideoRenderView created. TileId=${nonNullAttendee.tileId}, ViewId=${nonNullAttendee.viewId}, VideoView=${nonNullAttendee.videoView} => binding');
        await Chime.bindVideoView(
            nonNullAttendee.viewId!, nonNullAttendee.tileId);
        debugPrint(
            'ChimeDefaultVideoRenderView created. TileId=${nonNullAttendee.tileId}, ViewId=${nonNullAttendee.viewId}, VideoView=${nonNullAttendee.videoView} => bound');
      }));
    });
  }

  void _handleOnVideoTileRemoved(dynamic arguments) async {
    int tileId = arguments['TileId'];

    Attendee? attendee = _attendees.getByTileId(tileId);
    if (attendee == null) {
      debugPrint(
          'Error: HandleOnVideoTileRemoved: Could not find attendee for TileId=$tileId');
      return;
    }

    debugPrint(
        'HandleOnVideoTileRemoved: Found attendee: TileId=${attendee.tileId}, ViewId=${attendee.viewId} => unbinding');
    _attendees.remove(attendee);
    await Chime.unbindVideoView(tileId);
    debugPrint(
        'HandleOnVideoTileRemoved: Found attendee: TileId=${attendee.tileId}, ViewId=${attendee.viewId} => unbound');

    setState(() {});
  }

  void _handleOnAttendeesJoined(dynamic arguments) async {
    for (final info in arguments['AttendeeInfos']) {
      AttendeeInfo? attendeeInfo =
          _attendeeInfos.getByAttendeeId(info['AttendeeId']);
      if (attendeeInfo != null) {
        debugPrint(
            'HandleOnAttendeesJoined called but already mapped. AttendeeId=${attendeeInfo.attendeeId}, ExternalUserId=${attendeeInfo.externalUserId}');
      } else {
        final AttendeeInfo newAttendeeInfo = AttendeeInfo(
          info['AttendeeId'],
          info['ExternalUserId'],
        );
        _attendeeInfos.add(newAttendeeInfo);
      }
    }

    setState(() {});
  }

  void _handleOnAttendeesLeft(dynamic arguments) async {
    for (final info in arguments['AttendeeInfos']) {
      AttendeeInfo? attendeeInfo =
          _attendeeInfos.getByAttendeeId(info['AttendeeId']);
      if (attendeeInfo == null) {
        debugPrint(
            'Error: HandleOnAttendeesLeft: Could not find attendee for AttendeeId=${info['AttendeeId']}, ExternalUserId=${info['ExternalUserId']}');
      } else {
        _attendeeInfos.remove(attendeeInfo);
      }
    }

    setState(() {});
  }

  void _handleOnAttendeesUnmuted(dynamic arguments) async {
    for (final info in arguments['AttendeeInfos']) {
      AttendeeInfo? attendeeInfo =
          _attendeeInfosMute.getByAttendeeId(info['AttendeeId']);
      if (attendeeInfo == null) {
        debugPrint(
            'Error: HandleOnAttendeesUnmuted: Could not find attendee for AttendeeId=${info['AttendeeId']}, ExternalUserId=${info['ExternalUserId']}');
        return;
      } else {
        _attendeeInfosMute.remove(attendeeInfo);
      }
    }

    setState(() {});
  }

  void _handleOnAttendeesMuted(dynamic arguments) async {
    for (final info in arguments['AttendeeInfos']) {
      AttendeeInfo? attendeeInfo =
          _attendeeInfosMute.getByAttendeeId(info['AttendeeId']);
      if (attendeeInfo != null) {
        debugPrint(
            'HandleOnAttendeesMuted called but already mapped. AttendeeId=${attendeeInfo.attendeeId}, ExternalUserId=${attendeeInfo.externalUserId}');
        return;
      } else {
        final AttendeeInfo newAttendeeInfo = AttendeeInfo(
          info['AttendeeId'],
          info['ExternalUserId'],
        );
        _attendeeInfosMute.add(newAttendeeInfo);
      }
    }

    setState(() {});
  }
}
