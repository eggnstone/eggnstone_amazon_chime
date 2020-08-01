import 'dart:convert';
import 'dart:io';

import 'package:chime_example/MeetingSessionCreator.dart';
import 'package:chime_example/data/Mapping.dart';
import 'package:chime_example/data/Mappings.dart';
import 'package:device_info/device_info.dart';
import 'package:eggnstone_amazon_chime/eggnstone_amazon_chime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

const MAX_VIEW_COUNT = 2;

void main()
{
    runApp(App());
}

class App extends StatefulWidget
{
    @override
    _AppState createState()
    => _AppState();
}

class _AppState extends State<App>
{
    String _version = 'Unknown';
    String _createMeetingSessionResult = 'CreateMeetingSession: Unknown';
    String _audioVideoStartResult = 'AudioVideo: Unknown';
    String _audioVideoStartLocalVideoResult = 'AudioVideoLocalVideo: Unknown';
    String _audioVideoStartRemoteVideoResult = 'AudioVideoRemoteVideo: Unknown';

    List<ChimeDefaultVideoRenderView> _chimeViews;
    Mappings _mappings = Mappings();
    bool _isAndroidEmulator = false;

    @override
    void initState()
    {
        super.initState();

        _chimeViews = List<ChimeDefaultVideoRenderView>();
        for (int viewIndex = 0; viewIndex < MAX_VIEW_COUNT; viewIndex++)
            _chimeViews.add(ChimeDefaultVideoRenderView(
                onPlatformViewCreated: (int viewId)
                => _mappings.add(viewIndex, viewId))
            );

        _startChime();
    }

    @override
    Widget build(BuildContext context)
    {
        var children = List<Widget>();
        for (int i = 0; i < MAX_VIEW_COUNT; i++)
            children.add(Expanded(child: _chimeViews[i]));

        var chimeViewColumn = Column(children: children);

        Widget content = _isAndroidEmulator
            ? Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
                child: Text('Chime does not support Android emulators (x86 devices).\n\nIf you see the SDK version above then the connection to the SDK works though.')
            )
        )
            : Column(
            children: [
                Text(_createMeetingSessionResult),
                SizedBox(height: 8),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                        Text('Audio/Video:'),
                        RaisedButton(
                            child: Text('Start'),
                            onPressed: ()
                            => _audioVideoStart()
                        ),
                        RaisedButton(
                            child: Text('Stop'),
                            onPressed: ()
                            => _audioVideoStop()
                        )
                    ]
                ),
                Text(_audioVideoStartResult),
                SizedBox(height: 8),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                        Text('Local Video:'),
                        RaisedButton(
                            child: Text('Start'),
                            onPressed: ()
                            => _audioVideoStartLocalVideo()
                        ),
                        RaisedButton(
                            child: Text('Stop'),
                            onPressed: ()
                            => _audioVideoStopLocalVideo()
                        )
                    ]
                ),
                Text(_audioVideoStartLocalVideoResult),
                SizedBox(height: 8),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                        Text('Remote Video:'),
                        RaisedButton(
                            child: Text('Start'),
                            onPressed: ()
                            => _audioVideoStartRemoteVideo()
                        ),
                        RaisedButton(
                            child: Text('Stop'),
                            onPressed: ()
                            => _audioVideoStopRemoteVideo()
                        )
                    ]
                ),
                Text(_audioVideoStartRemoteVideoResult),
                SizedBox(height: 8),
                Expanded(child: chimeViewColumn)
            ]
        );

        return MaterialApp(
            home: Scaffold(
                appBar: AppBar(title: Text('ChimePlugin')),
                body: Column(
                    children: [
                        SizedBox(height: 8),
                        Text(_version),
                        SizedBox(height: 8),
                        Expanded(child: content)
                    ]
                )
            )
        );
    }

    void _startChime()
    async
    {
        await _getVersion();

        if (Platform.isAndroid)
        {
            DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
            AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
            if (androidInfo.isPhysicalDevice)
            {
                _addListener();
                await _createMeetingSession();
            }
            else
            {
                setState(()
                {
                    _isAndroidEmulator = true;
                });
            }
        }
        else
        {
            _addListener();
            await _createMeetingSession();
        }
    }

    Future<void> _getVersion()
    async
    {
        String version;

        try
        {
            version = await Chime.version;
        }
        on PlatformException
        {
            version = 'Failed to get version.';
        }

        if (mounted)
            setState(()
            {
                _version = version;
            });
    }

    void _addListener()
    {
        Chime.eventChannel.receiveBroadcastStream().listen(
                (data)
            async
            {
                dynamic event = JsonDecoder().convert(data);
                String eventName = event['Name'];
                dynamic eventArguments = event['Arguments'];
                switch (eventName)
                {
                    case 'OnVideoTileAdded':
                        _handleOnVideoTileAdded(eventArguments);
                        break;
                    case 'OnVideoTileRemoved':
                        _handleOnVideoTileRemoved(eventArguments);
                        break;
                    default:
                        print('Chime.eventChannel.receiveBroadcastStream().listen()/onData()');
                        print('Warning: Unhandled event: $eventName');
                        print('Data: $data');
                        break;
                }
            },
            onDone: ()
            {
                print('Chime.eventChannel.receiveBroadcastStream().listen()/onDone()');
            },
            onError: (e)
            {
                print('Chime.eventChannel.receiveBroadcastStream().listen()/onError()');
            }
        );
    }

    Future<void> _createMeetingSession()
    async
    {
        if (await Permission.microphone
            .request()
            .isGranted == false)
        {
            _createMeetingSessionResult = 'Need microphone permission.';
            return;
        }

        if (await Permission.camera
            .request()
            .isGranted == false)
        {
            _createMeetingSessionResult = 'Need camera permission.';
            return;
        }

        String meetingSessionState;

        try
        {
            // Copy the file DefaultMeetingSessionCreator.dart to MeetingSessionCreator.dart.
            // Adjust MeetingSessionCreator to supply your proper authenticated meeting data.
            // (You can leave the dummy values but you will not be able to join a real meeting.)
            // This requires you to have an AWS account and Chime being set up there.
            // MeetingSessionCreator.dart is to be ignored by git so that your private data never gets committed.
            meetingSessionState = await MeetingSessionCreator().create();
        }
        on PlatformException catch (e)
        {
            meetingSessionState = 'Failed to create MeetingSession. PlatformException: $e';
        }
        catch (e)
        {
            meetingSessionState = 'Failed to create MeetingSession. Error: $e';
        }

        if (mounted)
            setState(()
            {
                _createMeetingSessionResult = meetingSessionState;
            });
    }

    Future<void> _audioVideoStart()
    async
    {
        String result;

        try
        {
            result = await Chime.audioVideoStart();
        }
        on PlatformException catch (e)
        {
            result = 'AudioVideoStart failed: PlatformException: $e';
        }
        catch (e)
        {
            result = 'AudioVideoStart failed: Error: $e';
        }

        if (mounted)
            setState(()
            {
                _audioVideoStartResult = result;
            });
    }

    Future<void> _audioVideoStop()
    async
    {
        String result;

        try
        {
            result = await Chime.audioVideoStop();
        }
        on PlatformException catch (e)
        {
            result = 'AudioVideoStop failed: PlatformException: $e';
        }
        catch (e)
        {
            result = 'AudioVideoStop failed: Error: $e';
        }

        if (mounted)
            setState(()
            {
                _audioVideoStartResult = result;
            });
    }

    Future<void> _audioVideoStartLocalVideo()
    async
    {
        String result;

        try
        {
            result = await Chime.audioVideoStartLocalVideo();
        }
        on PlatformException catch (e)
        {
            result = 'AudioVideoStartLocalVideo failed: PlatformException: $e';
        }
        catch (e)
        {
            result = 'AudioVideoStartLocalVideo failed: Error: $e';
        }

        if (mounted)
            setState(()
            {
                _audioVideoStartLocalVideoResult = result;
            });
    }

    Future<void> _audioVideoStopLocalVideo()
    async
    {
        String result;

        try
        {
            result = await Chime.audioVideoStopLocalVideo();
        }
        on PlatformException catch (e)
        {
            result = 'AudioVideoStopLocalVideo failed: PlatformException: $e';
        }
        catch (e)
        {
            result = 'AudioVideoStopLocalVideo failed: Error: $e';
        }

        if (mounted)
            setState(()
            {
                _audioVideoStartLocalVideoResult = result;
            });
    }

    Future<void> _audioVideoStartRemoteVideo()
    async
    {
        String result;

        try
        {
            result = await Chime.audioVideoStartRemoteVideo();
        }
        on PlatformException catch (e)
        {
            result = 'AudioVideoStartRemoteVideo failed: PlatformException: $e';
        }
        catch (e)
        {
            result = 'AudioVideoStartRemoteVideo failed: Error: $e';
        }

        if (mounted)
            setState(()
            {
                _audioVideoStartRemoteVideoResult = result;
            });
    }

    Future<void> _audioVideoStopRemoteVideo()
    async
    {
        String result;

        try
        {
            result = await Chime.audioVideoStopRemoteVideo();
        }
        on PlatformException catch (e)
        {
            result = 'AudioVideoStopRemoteVideo failed: PlatformException: $e';
        }
        catch (e)
        {
            result = 'AudioVideoStopRemoteVideo failed: Error: $e';
        }

        if (mounted)
            setState(()
            {
                _audioVideoStartRemoteVideoResult = result;
            });
    }

    void _handleOnVideoTileAdded(dynamic arguments)
    async
    {
        int tileId = arguments['TileId'];

        Mapping mapping = _mappings.getByTileId(tileId);
        if (mapping != null)
        {
            print('_handleOnVideoTileAdded: Already mapped. TileId=${mapping.tileId}] => ViewId=${mapping.viewId} => binding again');
            await Chime.bindVideoView(mapping.viewId, mapping.tileId);
            return;
        }

        for (int viewIndex = 0; viewIndex < MAX_VIEW_COUNT; viewIndex++)
        {
            mapping = _mappings.getByViewIndex(viewIndex);
            if (mapping.tileId == null)
            {
                mapping.tileId = tileId;
                print('_handleOnVideoTileAdded: New mapping: TileId=${mapping.tileId} => ViewId=${mapping.viewId} => binding');
                await Chime.bindVideoView(mapping.viewId, mapping.tileId);
                return;
            }
        }

        print('Error: _handleOnVideoTileAdded: Could not find free view. Ignoring new video tile.');
    }

    void _handleOnVideoTileRemoved(dynamic arguments)
    async
    {
        int tileId = arguments['TileId'];

        Mapping mapping = _mappings.getByTileId(tileId);
        if (mapping == null)
        {
            print('Error: _handleOnVideoTileRemoved: Could not find mapping for TileId=$tileId');
            return;
        }

        print('_handleOnVideoTileRemoved: Found mapping: TileId=${mapping.tileId} => ViewId=${mapping.viewId} => unbinding');
        mapping.tileId = null;
        await Chime.unbindVideoView(tileId);
    }
}
