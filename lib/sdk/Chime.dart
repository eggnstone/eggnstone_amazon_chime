import 'dart:async';

import 'package:flutter/services.dart';

/// Main plugin class
class Chime
{
    static const MethodChannel _methodChannel = const MethodChannel('ChimePlugin');
    static const EventChannel _eventChannel = const EventChannel('ChimePluginEvents');

    /// The event channel you can subscribe to with
    /// Chime.eventChannel.receiveBroadcastStream().listen()
    static EventChannel get eventChannel
    => _eventChannel;

    /// The version of the used Amazon Chime SDK.
    static Future<String> get version
    async
    {
        return _methodChannel.invokeMethod('GetVersion') as String;
    }

    /// Creates a meeting session
    static Future<String> createMeetingSession({
        required String meetingId,
        required String externalMeetingId,
        required String mediaRegion,
        required String mediaPlacementAudioHostUrl,
        required String mediaPlacementAudioFallbackUrl,
        required String mediaPlacementSignalingUrl,
        required String mediaPlacementTurnControlUrl,
        required String attendeeId,
        required String externalUserId,
        required String joinToken
    })
    async
    {
        var params =
        {
            "MeetingId": meetingId,
            "ExternalMeetingId": externalMeetingId,
            "MediaRegion": mediaRegion,
            "MediaPlacementAudioHostUrl": mediaPlacementAudioHostUrl,
            "MediaPlacementAudioFallbackUrl": mediaPlacementAudioFallbackUrl,
            "MediaPlacementSignalingUrl": mediaPlacementSignalingUrl,
            "MediaPlacementTurnControlUrl": mediaPlacementTurnControlUrl,
            "AttendeeId": attendeeId,
            "ExternalUserId": externalUserId,
            "JoinToken": joinToken
        };

        return _methodChannel.invokeMethod('CreateMeetingSession', params) as String;
    }

    /// Starts audio and video (get ready to receive and send audio and video)
    static Future<String> audioVideoStart()
    async
    {
        return _methodChannel.invokeMethod('AudioVideoStart') as String;
    }

    /// Stops audio and video
    static Future<String> audioVideoStop()
    async
    {
        return _methodChannel.invokeMethod('AudioVideoStop') as String;
    }

    /// Starts local video
    static Future<String> audioVideoStartLocalVideo()
    async
    {
        return _methodChannel.invokeMethod('AudioVideoStartLocalVideo') as String;
    }

    /// Stops local video
    static Future<String> audioVideoStopLocalVideo()
    async
    {
        return _methodChannel.invokeMethod('AudioVideoStopLocalVideo') as String;
    }

    /// Starts all remote videos
    static Future<String> audioVideoStartRemoteVideo()
    async
    {
        return _methodChannel.invokeMethod('AudioVideoStartRemoteVideo') as String;
    }

    /// Stops all remote videos
    static Future<String> audioVideoStopRemoteVideo()
    async
    {
        return _methodChannel.invokeMethod('AudioVideoStopRemoteVideo') as String;
    }

    /// Binds a view to a video tile
    static Future<String> bindVideoView(int viewId, int tileId)
    async
    {
        var params = {"ViewId": viewId, "TileId": tileId};
        return _methodChannel.invokeMethod('BindVideoView', params) as String;
    }

    /// Unbinds a video tile
    static Future<String> unbindVideoView(int tileId)
    async
    {
        var params = {"TileId": tileId};
        return _methodChannel.invokeMethod('UnbindVideoView', params) as String;
    }

    /// Mutes local audio
    static Future<String> mute()
    async
    {
        return _methodChannel.invokeMethod('Mute') as String;
    }

    /// Unmutes local audio
    static Future<String> unmute()
    async
    {
        return _methodChannel.invokeMethod('Unmute') as String;
    }

    /// Lists all available audio devices
    static Future<String> listAudioDevices()
    async
    {
        return _methodChannel.invokeMethod('ListAudioDevices') as String;
    }

    /// Chooses a device by label
    static Future<String> chooseAudioDevice(String label)
    async
    {
        var params = {'Label': label};
        return _methodChannel.invokeMethod('ChooseAudioDevice', params) as String;
    }
}
