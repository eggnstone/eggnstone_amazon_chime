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
    private var _meetingSession: MeetingSession? = null
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
        val safeMethodChannel: MethodChannel = _methodChannel
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
            "CreateMeetingSession" -> handleCreateMeetingSession(call, result)
            "GetVersion" -> result.success("Chime SDK " + sdkVersion())
            "ListAudioDevices" -> handleListAudioDevices(result)
            "Mute" -> handleMute(result)
            "UnbindVideoView" -> handleUnbindVideoView(call, result)
            "Unmute" -> handleUnmute(result)
            else -> result.notImplemented()
        }
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
        val externalMeetingId = call.argument<String>("ExternalMeetingId")
        val externalUserId = call.argument<String>("ExternalUserId")
        val joinToken = call.argument<String>("JoinToken")
        val mediaRegion = call.argument<String>("MediaRegion")
        val meetingId = call.argument<String>("MeetingId")
        val mediaPlacementAudioFallbackUrl = call.argument<String>("MediaPlacementAudioFallbackUrl")
        val mediaPlacementAudioHostUrl = call.argument<String>("MediaPlacementAudioHostUrl")
        val mediaPlacementSignalingUrl = call.argument<String>("MediaPlacementSignalingUrl")
        val mediaPlacementTurnControlUrl = call.argument<String>("MediaPlacementTurnControlUrl")

        if (attendeeId == null ||
                externalMeetingId == null ||
                externalUserId == null ||
                joinToken == null ||
                mediaRegion == null ||
                meetingId == null ||
                mediaPlacementAudioFallbackUrl == null ||
                mediaPlacementAudioHostUrl == null ||
                mediaPlacementSignalingUrl == null ||
                mediaPlacementTurnControlUrl == null)
        {
            result.error(UNEXPECTED_ERROR__ERROR_CODE, UNEXPECTED_ERROR__ERROR_MESSAGE, null)
            return
        }

        val mediaPlacement = MediaPlacement(mediaPlacementAudioFallbackUrl, mediaPlacementAudioHostUrl, mediaPlacementSignalingUrl, mediaPlacementTurnControlUrl)
        val meeting = Meeting(externalMeetingId, mediaPlacement, mediaRegion, meetingId)
        val mr = CreateMeetingResponse(meeting)
        val attendee = Attendee(attendeeId, externalUserId, joinToken)
        val ar = CreateAttendeeResponse(attendee)
        val configuration = MeetingSessionConfiguration(mr, ar) { s: String? -> s!! }

        val safeMeetingSession: MeetingSession = DefaultMeetingSession(configuration, ConsoleLogger(), safeApplicationContext)
        _meetingSession = safeMeetingSession;

        val safeAudioVideoFacade: AudioVideoFacade = safeMeetingSession.audioVideo
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
        // addRealtimeDataMessageObserver: onDataMessageReceived
        safeAudioVideoFacade.addRealtimeObserver(ChimeRealtimeObserver(safeEventSink))
        safeAudioVideoFacade.addVideoTileObserver(ChimeVideoTileObserver(safeEventSink))

        result.success(null)
    }

    private fun handleAudioVideoStart(result: MethodChannel.Result)
    {
        if (!checkAudioVideoFacade(result, "AudioVideoStart"))
            return

        val safeAudioVideoFacade: AudioVideoFacade? = _audioVideoFacade
        if (safeAudioVideoFacade == null)
        {
            result.error(UNEXPECTED_ERROR__ERROR_CODE, UNEXPECTED_ERROR__ERROR_MESSAGE, null)
            return
        }

        safeAudioVideoFacade.start()
        result.success(null)
    }

    private fun handleAudioVideoStop(result: MethodChannel.Result)
    {
        if (!checkAudioVideoFacade(result, "AudioVideoStop"))
            return

        val safeAudioVideoFacade: AudioVideoFacade? = _audioVideoFacade
        if (safeAudioVideoFacade == null)
        {
            result.error(UNEXPECTED_ERROR__ERROR_CODE, UNEXPECTED_ERROR__ERROR_MESSAGE, null)
            return
        }

        safeAudioVideoFacade.stop()
        ChimeDefaultVideoRenderViewFactory.clearViewIds()
        result.success(null)
    }

    private fun handleAudioVideoStartLocalVideo(result: MethodChannel.Result)
    {
        if (!checkAudioVideoFacade(result, "AudioVideoStartLocalVideo"))
            return

        val safeAudioVideoFacade: AudioVideoFacade? = _audioVideoFacade
        if (safeAudioVideoFacade == null)
        {
            result.error(UNEXPECTED_ERROR__ERROR_CODE, UNEXPECTED_ERROR__ERROR_MESSAGE, null)
            return
        }

        safeAudioVideoFacade.startLocalVideo()
        result.success(null)
    }

    private fun handleAudioVideoStopLocalVideo(result: MethodChannel.Result)
    {
        if (!checkAudioVideoFacade(result, "AudioVideoStopLocalVideo"))
            return

        val safeAudioVideoFacade: AudioVideoFacade? = _audioVideoFacade
        if (safeAudioVideoFacade == null)
        {
            result.error(UNEXPECTED_ERROR__ERROR_CODE, UNEXPECTED_ERROR__ERROR_MESSAGE, null)
            return
        }

        safeAudioVideoFacade.stopLocalVideo()
        result.success(null)
    }

    private fun handleAudioVideoStartRemoteVideo(result: MethodChannel.Result)
    {
        if (!checkAudioVideoFacade(result, "AudioVideoStartRemoteVideo"))
            return

        val safeAudioVideoFacade: AudioVideoFacade? = _audioVideoFacade
        if (safeAudioVideoFacade == null)
        {
            result.error(UNEXPECTED_ERROR__ERROR_CODE, UNEXPECTED_ERROR__ERROR_MESSAGE, null)
            return
        }

        safeAudioVideoFacade.startRemoteVideo()
        result.success(null)
    }

    private fun handleAudioVideoStopRemoteVideo(result: MethodChannel.Result)
    {
        if (!checkAudioVideoFacade(result, "AudioVideoStopRemoteVideo"))
            return

        val safeAudioVideoFacade: AudioVideoFacade? = _audioVideoFacade
        if (safeAudioVideoFacade == null)
        {
            result.error(UNEXPECTED_ERROR__ERROR_CODE, UNEXPECTED_ERROR__ERROR_MESSAGE, null)
            return
        }

        safeAudioVideoFacade.stopRemoteVideo()
        result.success(null)
    }

    private fun handleBindVideoView(call: MethodCall, result: MethodChannel.Result)
    {
        if (!checkAudioVideoFacade(result, "BindVideoView"))
            return

        Log.d(TAG, "handleBindVideoView ViewId:" + call.argument("ViewId"))
        Log.d(TAG, "handleBindVideoView TileId:" + call.argument("TileId"))

        val viewId = call.argument<Int>("ViewId")
        if (viewId == null)
        {
            result.error(UNEXPECTED_ERROR__ERROR_CODE, UNEXPECTED_ERROR__ERROR_MESSAGE, null)
            return
        }

        val tileId = call.argument<Int>("TileId")
        if (tileId == null)
        {
            result.error(UNEXPECTED_ERROR__ERROR_CODE, UNEXPECTED_ERROR__ERROR_MESSAGE, null)
            return
        }

        val view = ChimeDefaultVideoRenderViewFactory.getViewById(viewId)
        if (view == null)
        {
            result.error(VIEW_NOT_FOUND__ERROR_CODE, VIEW_NOT_FOUND__ERROR_MESSAGE + viewId, null)
            return
        }

        val videoRenderView: VideoRenderView = view.videoRenderView

        val safeAudioVideoFacade: AudioVideoFacade? = _audioVideoFacade
        if (safeAudioVideoFacade == null)
        {
            result.error(UNEXPECTED_ERROR__ERROR_CODE, UNEXPECTED_ERROR__ERROR_MESSAGE, null)
            return
        }

        safeAudioVideoFacade.bindVideoView(videoRenderView, tileId)
        result.success(null)
    }

    private fun handleUnbindVideoView(call: MethodCall, result: MethodChannel.Result)
    {
        if (!checkAudioVideoFacade(result, "UnbindVideoView"))
            return

        val tileId = call.argument<Int>("TileId")
        if (tileId == null)
        {
            result.error(UNEXPECTED_ERROR__ERROR_CODE, UNEXPECTED_ERROR__ERROR_MESSAGE, null)
            return
        }

        val safeAudioVideoFacade: AudioVideoFacade? = _audioVideoFacade
        if (safeAudioVideoFacade == null)
        {
            result.error(UNEXPECTED_ERROR__ERROR_CODE, UNEXPECTED_ERROR__ERROR_MESSAGE, null)
            return
        }

        safeAudioVideoFacade.unbindVideoView(tileId)
        result.success(null)
    }

    private fun handleMute(result: MethodChannel.Result)
    {
        if (!checkAudioVideoFacade(result, "Mute"))
            return

        val safeAudioVideoFacade: AudioVideoFacade? = _audioVideoFacade
        if (safeAudioVideoFacade == null)
        {
            result.error(UNEXPECTED_ERROR__ERROR_CODE, UNEXPECTED_ERROR__ERROR_MESSAGE, null)
            return
        }

        safeAudioVideoFacade.realtimeLocalMute()
        result.success(null)
    }

    private fun handleUnmute(result: MethodChannel.Result)
    {
        if (!checkAudioVideoFacade(result, "Unmute"))
            return

        val safeAudioVideoFacade: AudioVideoFacade? = _audioVideoFacade
        if (safeAudioVideoFacade == null)
        {
            result.error(UNEXPECTED_ERROR__ERROR_CODE, UNEXPECTED_ERROR__ERROR_MESSAGE, null)
            return
        }

        safeAudioVideoFacade.realtimeLocalUnmute()
        result.success(null)
    }

    private fun handleListAudioDevices(result: MethodChannel.Result)
    {
        if (!checkAudioVideoFacade(result, "ListAudioDevices"))
            return

        val safeAudioVideoFacade: AudioVideoFacade? = _audioVideoFacade
        if (safeAudioVideoFacade == null)
        {
            result.error(UNEXPECTED_ERROR__ERROR_CODE, UNEXPECTED_ERROR__ERROR_MESSAGE, null)
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
        if (!checkAudioVideoFacade(result, "ChooseAudioDevice"))
            return

        val safeAudioVideoFacade: AudioVideoFacade? = _audioVideoFacade
        if (safeAudioVideoFacade == null)
        {
            result.error(UNEXPECTED_ERROR__ERROR_CODE, UNEXPECTED_ERROR__ERROR_MESSAGE, null)
            return
        }

        // ​val deviceName = call.argument<String>("label")
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

    private fun checkAudioVideoFacade(result: MethodChannel.Result, source: String): Boolean
    {
        if (_meetingSession == null)
        {
            result.error(NO_MEETING_SESSION__ERROR_CODE, "$source: $NO_MEETING_SESSION__ERROR_MESSAGE", null)
            return false
        }

        if (_audioVideoFacade == null)
        {
            result.error(NO_AUDIO_VIDEO_FACADE__ERROR_CODE, "$source: $NO_AUDIO_VIDEO_FACADE__ERROR_MESSAGE", null)
            return false
        }

        return true
    }

    companion object
    {
        private const val TAG = "ChimePlugin"
        private const val NO_MEETING_SESSION__ERROR_CODE = "1"
        private const val NO_MEETING_SESSION__ERROR_MESSAGE = "No MeetingSession created."
        private const val NO_AUDIO_VIDEO_FACADE__ERROR_CODE = "2"
        private const val NO_AUDIO_VIDEO_FACADE__ERROR_MESSAGE = "No AudioVideoFacade created."
        private const val VIEW_NOT_FOUND__ERROR_CODE = "3"
        private const val VIEW_NOT_FOUND__ERROR_MESSAGE = "No View found with ViewId="
        private const val UNEXPECTED_ERROR__ERROR_CODE = "99"
        private const val UNEXPECTED_ERROR__ERROR_MESSAGE = "Unexpected error."
    }
}
