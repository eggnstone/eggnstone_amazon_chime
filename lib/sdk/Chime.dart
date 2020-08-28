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

    /// Create a meeting session
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

    /// Start audio and video (get ready to receive and send audio and video)
    static Future<String> audioVideoStart()
    async
    {
        return _methodChannel.invokeMethod('AudioVideoStart');
    }

    /// Stop audio and video
    static Future<String> audioVideoStop()
    async
    {
        return _methodChannel.invokeMethod('AudioVideoStop');
    }

    /// Start local video
    static Future<String> audioVideoStartLocalVideo()
    async
    {
        return _methodChannel.invokeMethod('AudioVideoStartLocalVideo');
    }

    /// Stop local video
    static Future<String> audioVideoStopLocalVideo()
    async
    {
        return _methodChannel.invokeMethod('AudioVideoStopLocalVideo');
    }

    /// Start all remote videos
    static Future<String> audioVideoStartRemoteVideo()
    async
    {
        return _methodChannel.invokeMethod('AudioVideoStartRemoteVideo');
    }

    /// Stop all remote videos
    static Future<String> audioVideoStopRemoteVideo()
    async
    {
        return _methodChannel.invokeMethod('AudioVideoStopRemoteVideo');
    }

    /// Bind a view to a video tile
    static Future<String> bindVideoView(int viewId, int tileId)
    async
    {
        var params =
        {
            "ViewId": viewId,
            "TileId": tileId
        };

        return _methodChannel.invokeMethod('BindVideoView', params);
    }

    /// Unbind a video tile
    static Future<String> unbindVideoView(int tileId)
    async
    {
        var params =
        {
            "TileId": tileId
        };

        return _methodChannel.invokeMethod('UnbindVideoView', params);
    }

    /// Mute local audio
    static Future<String> mute()
    async
    {
        return _methodChannel.invokeMethod('Mute');
    }

    /// Unmute local audio
    static Future<String> unmute()
    async
    {
        return _methodChannel.invokeMethod('Unmute');
    }
}
