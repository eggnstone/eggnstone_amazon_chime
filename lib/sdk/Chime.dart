import 'dart:async';

import 'package:flutter/services.dart';

class Chime
{
    static const MethodChannel _methodChannel = const MethodChannel('ChimePlugin');
    static const EventChannel _eventChannel = EventChannel('ChimePluginEvents');

    static Future<String> get version
    async
    {
        return _methodChannel.invokeMethod('getVersion');
    }

    static EventChannel get eventChannel
    => _eventChannel;

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

        return _methodChannel.invokeMethod('createMeetingSession', params);
    }

    static Future<String> audioVideoStart()
    async
    {
        return _methodChannel.invokeMethod('audioVideoStart');
    }

    static Future<String> audioVideoStop()
    async
    {
        return _methodChannel.invokeMethod('audioVideoStop');
    }

    static Future<String> audioVideoStartLocalVideo()
    async
    {
        return _methodChannel.invokeMethod('audioVideoStartLocalVideo');
    }

    static Future<String> audioVideoStopLocalVideo()
    async
    {
        return _methodChannel.invokeMethod('audioVideoStopLocalVideo');
    }

    static Future<String> audioVideoStartRemoteVideo()
    async
    {
        return _methodChannel.invokeMethod('audioVideoStartRemoteVideo');
    }

    static Future<String> audioVideoStopRemoteVideo()
    async
    {
        return _methodChannel.invokeMethod('audioVideoStopRemoteVideo');
    }

    static Future<String> bindVideoView(int viewId, int tileId)
    async
    {
        var params =
        {
            "ViewId": viewId,
            "TileId": tileId
        };

        return _methodChannel.invokeMethod('bindVideoView', params);
    }

    static Future<String> unbindVideoView(int tileId)
    async
    {
        var params =
        {
            "TileId": tileId
        };

        return _methodChannel.invokeMethod('unbindVideoView', params);
    }
}
