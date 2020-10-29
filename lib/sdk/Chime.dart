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
        return _methodChannel.invokeMethod('GetVersion');
    }

    /// Creates a meeting session
    static Future<String> createMeetingSession({
        String meetingId,
        String externalMeetingId,
        String mediaRegion,
        String mediaPlacementAudioHostUrl,
        String mediaPlacementAudioFallbackUrl,
        String mediaPlacementSignalingUrl,
        String mediaPlacementTurnControlUrl,
        String attendeeId,
        String externalUserId,
        String joinToken
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

        return _methodChannel.invokeMethod('CreateMeetingSession', params);
    }

    /// Starts audio and video (get ready to receive and send audio and video)
    static Future<String> audioVideoStart()
    async
    {
        return _methodChannel.invokeMethod('AudioVideoStart');
    }

    /// Stops audio and video
    static Future<String> audioVideoStop()
    async
    {
        return _methodChannel.invokeMethod('AudioVideoStop');
    }

    /// Starts local video
    static Future<String> audioVideoStartLocalVideo()
    async
    {
        return _methodChannel.invokeMethod('AudioVideoStartLocalVideo');
    }

    /// Stops local video
    static Future<String> audioVideoStopLocalVideo()
    async
    {
        return _methodChannel.invokeMethod('AudioVideoStopLocalVideo');
    }

    /// Starts all remote videos
    static Future<String> audioVideoStartRemoteVideo()
    async
    {
        return _methodChannel.invokeMethod('AudioVideoStartRemoteVideo');
    }

    /// Stops all remote videos
    static Future<String> audioVideoStopRemoteVideo()
    async
    {
        return _methodChannel.invokeMethod('AudioVideoStopRemoteVideo');
    }

    /// Binds a view to a video tile
    static Future<String> bindVideoView(int viewId, int tileId)
    async
    {
        var params = {"ViewId": viewId, "TileId": tileId};
        return _methodChannel.invokeMethod('BindVideoView', params);
    }

    /// Unbinds a video tile
    static Future<String> unbindVideoView(int tileId)
    async
    {
        var params = {"TileId": tileId};
        return _methodChannel.invokeMethod('UnbindVideoView', params);
    }

    /// Mutes local audio
    static Future<String> mute()
    async
    {
        return _methodChannel.invokeMethod('Mute');
    }

    /// Unmutes local audio
    static Future<String> unmute()
    async
    {
        return _methodChannel.invokeMethod('Unmute');
    }

    /// Lists all available audio devices
    static Future<String> listAudioDevices()
    async
    {
        return _methodChannel.invokeMethod('ListAudioDevices');
    }

    /// Chooses a device by label
    static Future<String> chooseAudioDevice(String label)
    async
    {
        var params = {'Label': label};
        return _methodChannel.invokeMethod('ChooseAudioDevice', params);
    }
}
