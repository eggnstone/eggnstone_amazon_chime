import 'dart:convert';

import 'package:chime_example/data/Mapping.dart';
import 'package:chime_example/data/Mappings.dart';
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
    String _createMeetingSessionResult = 'createMeetingSession: Unknown';
    String _audioVideoStartResult = 'audioVideoStart: Unknown';
    String _audioVideoStartLocalVideoResult = 'audioVideoStartLocalVideo: Unknown';
    String _audioVideoStartRemoteVideoResult = 'audioVideoStartRemoteVideo: Unknown';

    List<ChimeDefaultVideoRenderView> _chimeViews;
    Mappings _mappings = Mappings();

    @override
    void initState()
    {
        super.initState();

        _chimeViews = List<ChimeDefaultVideoRenderView>();
        for (int viewIndex = 0; viewIndex < MAX_VIEW_COUNT; viewIndex++)
            _chimeViews.add(ChimeDefaultVideoRenderView(
                onPlatformViewCreated: (int viewId)
                {
                    _mappings.add(viewIndex, viewId);
                    print('ChimeView #$viewIndex: ViewId: $viewId');
                })
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

        return MaterialApp(
            home: Scaffold(
                appBar: AppBar(title: Text('ChimePlugin')),
                body: Column(
                    children: [
                        SizedBox(height: 8),
                        Text(_version),
                        SizedBox(height: 8),
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
                        Expanded(child: chimeViewColumn),
                    ]
                )
            )
        );
    }

    void _startChime()
    async
    {
        await _getVersion();
        _addListener();
        await _createMeetingSession();
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
                String eventName = event['name'];
                dynamic eventArguments = event['arguments'];
                switch (eventName)
                {
                    case 'onVideoTileAdded':
                        _handleOnVideoTileAdded(eventArguments);
                        break;
                    case 'onVideoTileRemoved':
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
            meetingSessionState = await Chime.createMeetingSession(
                meetingId: "Test-MeetingId",
                externalMeetingId: "Test-ExternalMeetingId",
                mediaRegion: "eu-central-1",
                mediaPlacementAudioHostUrl: "SomeGuid.k.m1.ec1.app.chime.aws:3478",
                mediaPlacementAudioFallbackUrl: "wss://haxrp.m1.ec1.app.chime.aws:443/calls/Test-MeetingId",
                mediaPlacementSignalingUrl: "wss://signal.m1.ec1.app.chime.aws/control/Test-MeetingId",
                mediaPlacementTurnControlUrl: "https://ccp.cp.ue1.app.chime.aws/v2/turn_sessions",
                attendeeId: "Test-AttendeeId",
                externalUserId: "Test-ExternalUserId-1",
                joinToken: "Test-JoinToken"
            );
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
            result = 'audioVideoStart failed: PlatformException: $e';
        }
        catch (e)
        {
            result = 'audioVideoStart failed: Error: $e';
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
            result = 'audioVideoStop failed: PlatformException: $e';
        }
        catch (e)
        {
            result = 'audioVideoStop failed: Error: $e';
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
            result = 'audioVideoStartLocalVideo failed: PlatformException: $e';
        }
        catch (e)
        {
            result = 'audioVideoStartLocalVideo failed: Error: $e';
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
            result = 'audioVideoStopLocalVideo failed: PlatformException: $e';
        }
        catch (e)
        {
            result = 'audioVideoStopLocalVideo failed: Error: $e';
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
            result = 'audioVideoStartRemoteVideo failed: PlatformException: $e';
        }
        catch (e)
        {
            result = 'audioVideoStartRemoteVideo failed: Error: $e';
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
            result = 'audioVideoStopRemoteVideo failed: PlatformException: $e';
        }
        catch (e)
        {
            result = 'audioVideoStopRemoteVideo failed: Error: $e';
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
        int tileId = arguments['tileId'];

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
        int tileId = arguments['tileId'];

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
