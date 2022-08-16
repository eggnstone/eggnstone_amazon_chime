package dev.eggnstone.chime

import android.content.Context
import android.util.Log
import com.amazonaws.services.chime.sdk.meetings.audiovideo.AudioVideoFacade
import com.amazonaws.services.chime.sdk.meetings.audiovideo.audio.activespeakerpolicy.DefaultActiveSpeakerPolicy
import com.amazonaws.services.chime.sdk.meetings.audiovideo.video.VideoRenderView
import com.amazonaws.services.chime.sdk.meetings.session.*
import com.amazonaws.services.chime.sdk.meetings.utils.Versioning.Companion.sdkVersion
import com.amazonaws.services.chime.sdk.meetings.utils.logger.ConsoleLogger
import dev.eggnstone.chime.observers.*
import dev.eggnstone.chime.views.ChimeDefaultVideoRenderViewFactory
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class ChimePlugin : FlutterPlugin, MethodCallHandler
{
    private var _applicationContext: Context? = null
    private var _methodChannel: MethodChannel? = null
    private var _audioVideoFacade: AudioVideoFacade? = null
    private var _eventSink: EventSink? = null

    override fun onAttachedToEngine(binding: FlutterPluginBinding)
    {
        val messenger = binding.binaryMessenger
        val registry = binding.platformViewRegistry

        _applicationContext = binding.applicationContext

        val safeMethodChannel: MethodChannel = MethodChannel(messenger, "ChimePlugin")
        _methodChannel = safeMethodChannel
        safeMethodChannel.setMethodCallHandler(this)

        val eventChannel = EventChannel(messenger, "ChimePluginEvents")
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler
        {
            override fun onListen(arguments: Any?, events: EventSink?)
            {
                _eventSink = events
            }

            override fun onCancel(arguments: Any?)
            {
                Log.d(TAG, "EventChannel.setStreamHandler()/onCancel()")
            }
        })

        registry.registerViewFactory("ChimeDefaultVideoRenderView", ChimeDefaultVideoRenderViewFactory())
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding)
    {
        val safeMethodChannel: MethodChannel? = _methodChannel
        if (safeMethodChannel != null)
            safeMethodChannel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result)
    {
        when (call.method)
        {
            "AudioVideoStart" -> handleAudioVideoStart(result)
            "AudioVideoStop" -> handleAudioVideoStop(result)
            "AudioVideoStartLocalVideo" -> handleAudioVideoStartLocalVideo(result)
            "AudioVideoStopLocalVideo" -> handleAudioVideoStopLocalVideo(result)
            "AudioVideoStartRemoteVideo" -> handleAudioVideoStartRemoteVideo(result)
            "AudioVideoStopRemoteVideo" -> handleAudioVideoStopRemoteVideo(result)
            "BindVideoView" -> handleBindVideoView(call, result)
            "ChooseAudioDevice" -> handleChooseAudioDevice(call, result)
            "ClearViewIds" -> handleClearViewIds(call, result)
            "CreateMeetingSession" -> handleCreateMeetingSession(call, result)
            "GetVersion" -> result.success("Chime SDK " + sdkVersion())
            "ListAudioDevices" -> handleListAudioDevices(result)
            "Mute" -> handleMute(result)
            "SendDataMessage" -> handleSendDataMessage(call, result)
            "UnbindVideoView" -> handleUnbindVideoView(call, result)
            "Unmute" -> handleUnmute(result)
            else -> result.notImplemented()
        }
    }

    private fun handleClearViewIds(call: MethodCall, result: MethodChannel.Result)
    {
        ChimeDefaultVideoRenderViewFactory.clearViewIds()
        result.success(null)
    }

    private fun handleCreateMeetingSession(call: MethodCall, result: MethodChannel.Result)
    {
        val safeApplicationContext: Context? = _applicationContext
        if (safeApplicationContext == null)
        {
            result.error(UNEXPECTED_ERROR__ERROR_CODE, UNEXPECTED_ERROR__ERROR_MESSAGE, null)
            return
        }

        val attendeeId = call.argument<String>("AttendeeId")
        if (attendeeId == null)
        {
            result.error(UNEXPECTED_NULL_PARAMETER__ERROR_CODE, UNEXPECTED_NULL_PARAMETER__ERROR_MESSAGE + "AttendeeId", null)
            return
        }

        val externalMeetingId = call.argument<String>("ExternalMeetingId")
        if (externalMeetingId == null)
        {
            result.error(UNEXPECTED_NULL_PARAMETER__ERROR_CODE, UNEXPECTED_NULL_PARAMETER__ERROR_MESSAGE + "ExternalMeetingId", null)
            return
        }

        val externalUserId = call.argument<String>("ExternalUserId")
        if (externalUserId == null)
        {
            result.error(UNEXPECTED_NULL_PARAMETER__ERROR_CODE, UNEXPECTED_NULL_PARAMETER__ERROR_MESSAGE + "ExternalUserId", null)
            return
        }

        val joinToken = call.argument<String>("JoinToken")
        if (joinToken == null)
        {
            result.error(UNEXPECTED_NULL_PARAMETER__ERROR_CODE, UNEXPECTED_NULL_PARAMETER__ERROR_MESSAGE + "JoinToken", null)
            return
        }

        val mediaRegion = call.argument<String>("MediaRegion")
        if (mediaRegion == null)
        {
            result.error(UNEXPECTED_NULL_PARAMETER__ERROR_CODE, UNEXPECTED_NULL_PARAMETER__ERROR_MESSAGE + "MediaRegion", null)
            return
        }

        val meetingId = call.argument<String>("MeetingId")
        if (meetingId == null)
        {
            result.error(UNEXPECTED_NULL_PARAMETER__ERROR_CODE, UNEXPECTED_NULL_PARAMETER__ERROR_MESSAGE + "MeetingId", null)
            return
        }

        val mediaPlacementAudioFallbackUrl = call.argument<String>("MediaPlacementAudioFallbackUrl")
        if (mediaPlacementAudioFallbackUrl == null)
        {
            result.error(UNEXPECTED_NULL_PARAMETER__ERROR_CODE, UNEXPECTED_NULL_PARAMETER__ERROR_MESSAGE + "MediaPlacementAudioFallbackUrl", null)
            return
        }

        val mediaPlacementAudioHostUrl = call.argument<String>("MediaPlacementAudioHostUrl")
        if (mediaPlacementAudioHostUrl == null)
        {
            result.error(UNEXPECTED_NULL_PARAMETER__ERROR_CODE, UNEXPECTED_NULL_PARAMETER__ERROR_MESSAGE + "MediaPlacementAudioHostUrl", null)
            return
        }

        val mediaPlacementSignalingUrl = call.argument<String>("MediaPlacementSignalingUrl")
        if (mediaPlacementSignalingUrl == null)
        {
            result.error(UNEXPECTED_NULL_PARAMETER__ERROR_CODE, UNEXPECTED_NULL_PARAMETER__ERROR_MESSAGE + "MediaPlacementSignalingUrl", null)
            return
        }

        val mediaPlacementTurnControlUrl = call.argument<String>("MediaPlacementTurnControlUrl")
        if (mediaPlacementTurnControlUrl == null)
        {
            result.error(UNEXPECTED_NULL_PARAMETER__ERROR_CODE, UNEXPECTED_NULL_PARAMETER__ERROR_MESSAGE + "MediaPlacementTurnControlUrl", null)
            return
        }

        val mediaPlacement = MediaPlacement(mediaPlacementAudioFallbackUrl, mediaPlacementAudioHostUrl, mediaPlacementSignalingUrl, mediaPlacementTurnControlUrl)
        val meeting = Meeting(externalMeetingId, mediaPlacement, mediaRegion, meetingId)
        val mr = CreateMeetingResponse(meeting)
        val attendee = Attendee(attendeeId, externalUserId, joinToken)
        val ar = CreateAttendeeResponse(attendee)
        val configuration = MeetingSessionConfiguration(mr, ar) { s: String? -> s!! }

        val meetingSession: MeetingSession = DefaultMeetingSession(configuration, ConsoleLogger(), safeApplicationContext)
        val safeAudioVideoFacade: AudioVideoFacade = meetingSession.audioVideo
        _audioVideoFacade = safeAudioVideoFacade

        val safeEventSink: EventSink? = _eventSink
        if (safeEventSink == null)
        {
            result.error(UNEXPECTED_ERROR__ERROR_CODE, UNEXPECTED_ERROR__ERROR_MESSAGE, null)
            return
        }

        safeAudioVideoFacade.addActiveSpeakerObserver(DefaultActiveSpeakerPolicy(), ChimeActiveSpeakerDetectedObserver(safeEventSink))
        safeAudioVideoFacade.addAudioVideoObserver(ChimeAudioVideoObserver(safeEventSink))
        // addContentShareObserver: onContentShareStarted, onContentShareStopped
        safeAudioVideoFacade.addDeviceChangeObserver(ChimeDeviceChangeObserver(safeEventSink))
        // addEventAnalyticsObserver: onEventReceived
        safeAudioVideoFacade.addMetricsObserver(ChimeMetricsObserver(safeEventSink))
        safeAudioVideoFacade.addRealtimeDataMessageObserver("CHAT", ChimeDataMessageObserver(safeEventSink))
        safeAudioVideoFacade.addRealtimeObserver(ChimeRealtimeObserver(safeEventSink))
        safeAudioVideoFacade.addVideoTileObserver(ChimeVideoTileObserver(safeEventSink))

        result.success(null)
    }

    private fun handleAudioVideoStart(result: MethodChannel.Result)
    {
        val safeAudioVideoFacade: AudioVideoFacade? = _audioVideoFacade
        if (safeAudioVideoFacade == null)
        {
            result.error(NO_AUDIO_VIDEO_FACADE__ERROR_CODE, NO_AUDIO_VIDEO_FACADE__ERROR_MESSAGE, null)
            return
        }

        safeAudioVideoFacade.start()
        result.success(null)
    }

    private fun handleAudioVideoStop(result: MethodChannel.Result)
    {
        val safeAudioVideoFacade: AudioVideoFacade? = _audioVideoFacade
        if (safeAudioVideoFacade == null)
        {
            result.error(NO_AUDIO_VIDEO_FACADE__ERROR_CODE, NO_AUDIO_VIDEO_FACADE__ERROR_MESSAGE, null)
            return
        }

        safeAudioVideoFacade.stop()
        result.success(null)
    }

    private fun handleAudioVideoStartLocalVideo(result: MethodChannel.Result)
    {
        val safeAudioVideoFacade: AudioVideoFacade? = _audioVideoFacade
        if (safeAudioVideoFacade == null)
        {
            result.error(NO_AUDIO_VIDEO_FACADE__ERROR_CODE, NO_AUDIO_VIDEO_FACADE__ERROR_MESSAGE, null)
            return
        }

        safeAudioVideoFacade.startLocalVideo()
        result.success(null)
    }

    private fun handleAudioVideoStopLocalVideo(result: MethodChannel.Result)
    {
        val safeAudioVideoFacade: AudioVideoFacade? = _audioVideoFacade
        if (safeAudioVideoFacade == null)
        {
            result.error(NO_AUDIO_VIDEO_FACADE__ERROR_CODE, NO_AUDIO_VIDEO_FACADE__ERROR_MESSAGE, null)
            return
        }

        safeAudioVideoFacade.stopLocalVideo()
        result.success(null)
    }

    private fun handleAudioVideoStartRemoteVideo(result: MethodChannel.Result)
    {
        val safeAudioVideoFacade: AudioVideoFacade? = _audioVideoFacade
        if (safeAudioVideoFacade == null)
        {
            result.error(NO_AUDIO_VIDEO_FACADE__ERROR_CODE, NO_AUDIO_VIDEO_FACADE__ERROR_MESSAGE, null)
            return
        }

        safeAudioVideoFacade.startRemoteVideo()
        result.success(null)
    }

    private fun handleAudioVideoStopRemoteVideo(result: MethodChannel.Result)
    {
        val safeAudioVideoFacade: AudioVideoFacade? = _audioVideoFacade
        if (safeAudioVideoFacade == null)
        {
            result.error(NO_AUDIO_VIDEO_FACADE__ERROR_CODE, NO_AUDIO_VIDEO_FACADE__ERROR_MESSAGE, null)
            return
        }

        safeAudioVideoFacade.stopRemoteVideo()
        result.success(null)
    }

    private fun handleBindVideoView(call: MethodCall, result: MethodChannel.Result)
    {
        val safeAudioVideoFacade: AudioVideoFacade? = _audioVideoFacade
        if (safeAudioVideoFacade == null)
        {
            result.error(NO_AUDIO_VIDEO_FACADE__ERROR_CODE, NO_AUDIO_VIDEO_FACADE__ERROR_MESSAGE, null)
            return
        }

        val viewId = call.argument<Int>("ViewId")
        if (viewId == null)
        {
            result.error(UNEXPECTED_NULL_PARAMETER__ERROR_CODE, UNEXPECTED_NULL_PARAMETER__ERROR_MESSAGE + "ViewId", null)
            return
        }

        val tileId = call.argument<Int>("TileId")
        if (tileId == null)
        {
            result.error(UNEXPECTED_NULL_PARAMETER__ERROR_CODE, UNEXPECTED_NULL_PARAMETER__ERROR_MESSAGE + "TileId", null)
            return
        }

        val view = ChimeDefaultVideoRenderViewFactory.getViewById(viewId)
        if (view == null)
        {
            result.error(VIEW_NOT_FOUND__ERROR_CODE, VIEW_NOT_FOUND__ERROR_MESSAGE + viewId, null)
            return
        }

        val videoRenderView: VideoRenderView = view.videoRenderView

        safeAudioVideoFacade.bindVideoView(videoRenderView, tileId)
        result.success(null)
    }

    private fun handleSendDataMessage(call: MethodCall, result: MethodChannel.Result)
    {
        val safeAudioVideoFacade: AudioVideoFacade? = _audioVideoFacade
        if (safeAudioVideoFacade == null)
        {
            result.error(NO_AUDIO_VIDEO_FACADE__ERROR_CODE, NO_AUDIO_VIDEO_FACADE__ERROR_MESSAGE, null)
            return
        }

        val data = call.argument<Map<String,Any>>("Data")
        if (data == null)
        {
            result.error(UNEXPECTED_NULL_PARAMETER__ERROR_CODE, UNEXPECTED_NULL_PARAMETER__ERROR_MESSAGE + "data", null)
            return
        }

        safeAudioVideoFacade.realtimeSendDataMessage("CHAT", data, 0)
        result.success(null)
    }

    private fun handleUnbindVideoView(call: MethodCall, result: MethodChannel.Result)
    {
        val safeAudioVideoFacade: AudioVideoFacade? = _audioVideoFacade
        if (safeAudioVideoFacade == null)
        {
            result.error(NO_AUDIO_VIDEO_FACADE__ERROR_CODE, NO_AUDIO_VIDEO_FACADE__ERROR_MESSAGE, null)
            return
        }

        val tileId = call.argument<Int>("TileId")
        if (tileId == null)
        {
            result.error(UNEXPECTED_NULL_PARAMETER__ERROR_CODE, UNEXPECTED_NULL_PARAMETER__ERROR_MESSAGE + "TileId", null)
            return
        }

        result.success(null)
    }

    private fun handleMute(result: MethodChannel.Result)
    {
        val safeAudioVideoFacade: AudioVideoFacade? = _audioVideoFacade
        if (safeAudioVideoFacade == null)
        {
            result.error(NO_AUDIO_VIDEO_FACADE__ERROR_CODE, NO_AUDIO_VIDEO_FACADE__ERROR_MESSAGE, null)
            return
        }

        safeAudioVideoFacade.realtimeLocalMute()
        result.success(null)
    }

    private fun handleUnmute(result: MethodChannel.Result)
    {
        val safeAudioVideoFacade: AudioVideoFacade? = _audioVideoFacade
        if (safeAudioVideoFacade == null)
        {
            result.error(NO_AUDIO_VIDEO_FACADE__ERROR_CODE, NO_AUDIO_VIDEO_FACADE__ERROR_MESSAGE, null)
            return
        }

        safeAudioVideoFacade.realtimeLocalUnmute()
        result.success(null)
    }

    private fun handleListAudioDevices(result: MethodChannel.Result)
    {
        val safeAudioVideoFacade: AudioVideoFacade? = _audioVideoFacade
        if (safeAudioVideoFacade == null)
        {
            result.error(NO_AUDIO_VIDEO_FACADE__ERROR_CODE, NO_AUDIO_VIDEO_FACADE__ERROR_MESSAGE, null)
            return
        }

        var jsonString = ""
        for (device in safeAudioVideoFacade.listAudioDevices())
            jsonString += "{\"Label\": \"" + device.label + "\", \"Type\": \"" + device.type + "\", \"Port\": \"no-port\", \"Description\": \"no-description\"},"

        jsonString = jsonString.substring(0, jsonString.length - 1)
        @Suppress("ConvertToStringTemplate")
        jsonString = "[" + jsonString + "]"
        result.success(jsonString)
    }

    private fun handleChooseAudioDevice(call: MethodCall, result: MethodChannel.Result)
    {
        val safeAudioVideoFacade: AudioVideoFacade? = _audioVideoFacade
        if (safeAudioVideoFacade == null)
        {
            result.error(NO_AUDIO_VIDEO_FACADE__ERROR_CODE, NO_AUDIO_VIDEO_FACADE__ERROR_MESSAGE, null)
            return
        }

        val deviceLabel = call.argument<String>("Label")

        for (device in safeAudioVideoFacade.listAudioDevices())
        {
            if (device.label == deviceLabel)
            {
                safeAudioVideoFacade.chooseAudioDevice(mediaDevice = device)
                result.success(null)
                return
            }
        }

        // result.error(ERROR__NO_AUDIO_VIDEO_FACADE__ERROR_CODE, "exception caught during choosing an audio device", null)
    }

    companion object
    {
        private const val TAG = "ChimePlugin"
        private const val NO_AUDIO_VIDEO_FACADE__ERROR_CODE = "2"
        private const val NO_AUDIO_VIDEO_FACADE__ERROR_MESSAGE = "No AudioVideoFacade created."
        private const val VIEW_NOT_FOUND__ERROR_CODE = "3"
        private const val VIEW_NOT_FOUND__ERROR_MESSAGE = "No View found with ViewId="
        private const val UNEXPECTED_NULL_PARAMETER__ERROR_CODE = "4"
        private const val UNEXPECTED_NULL_PARAMETER__ERROR_MESSAGE = "Unexpected null parameter: "
        private const val UNEXPECTED_ERROR__ERROR_CODE = "99"
        private const val UNEXPECTED_ERROR__ERROR_MESSAGE = "Unexpected error."
    }
}
