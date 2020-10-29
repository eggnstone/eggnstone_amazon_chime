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

        _methodChannel = MethodChannel(messenger, "ChimePlugin")
        _methodChannel!!.setMethodCallHandler(this)

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
        _methodChannel!!.setMethodCallHandler(null)
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
        val meetingId = call.argument<String>("MeetingId")
        val externalMeetingId = call.argument<String>("ExternalMeetingId")
        val mediaRegion = call.argument<String>("MediaRegion")
        val mediaPlacementAudioHostUrl = call.argument<String>("MediaPlacementAudioHostUrl")
        val mediaPlacementAudioFallbackUrl = call.argument<String>("MediaPlacementAudioFallbackUrl")
        val mediaPlacementSignalingUrl = call.argument<String>("MediaPlacementSignalingUrl")
        val mediaPlacementTurnControlUrl = call.argument<String>("MediaPlacementTurnControlUrl")
        val attendeeId = call.argument<String>("AttendeeId")
        val externalUserId = call.argument<String>("ExternalUserId")
        val joinToken = call.argument<String>("JoinToken")

        val mediaPlacement = MediaPlacement(mediaPlacementAudioFallbackUrl!!, mediaPlacementAudioHostUrl!!, mediaPlacementSignalingUrl!!, mediaPlacementTurnControlUrl!!)
        val meeting = Meeting(externalMeetingId!!, mediaPlacement, mediaRegion!!, meetingId!!)
        val mr = CreateMeetingResponse(meeting)
        val attendee = Attendee(attendeeId!!, externalUserId!!, joinToken!!)
        val ar = CreateAttendeeResponse(attendee)
        val configuration = MeetingSessionConfiguration(mr, ar) { s: String? -> s!! }

        _meetingSession = DefaultMeetingSession(configuration, ConsoleLogger(), _applicationContext!!)
        _audioVideoFacade = _meetingSession!!.audioVideo
        _audioVideoFacade!!.addAudioVideoObserver(ChimeAudioVideoObserver(_eventSink!!))
        _audioVideoFacade!!.addMetricsObserver(ChimeMetricsObserver(_eventSink!!))
        _audioVideoFacade!!.addRealtimeObserver(ChimeRealtimeObserver(_eventSink!!))
        _audioVideoFacade!!.addDeviceChangeObserver(ChimeDeviceChangeObserver(_eventSink!!))
        _audioVideoFacade!!.addVideoTileObserver(ChimeVideoTileObserver(_eventSink!!))
        _audioVideoFacade!!.addActiveSpeakerObserver(DefaultActiveSpeakerPolicy(), ChimeActiveSpeakerDetectedObserver(_eventSink!!))

        result.success("OK")
    }

    private fun handleAudioVideoStart(result: MethodChannel.Result)
    {
        if (!checkAudioVideoFacade(result, "AudioVideoStart"))
            return

        _audioVideoFacade!!.start()
        result.success("OK")
    }

    private fun handleAudioVideoStop(result: MethodChannel.Result)
    {
        if (!checkAudioVideoFacade(result, "AudioVideoStop"))
            return

        _audioVideoFacade!!.stop()
        ChimeDefaultVideoRenderViewFactory.clearViewIds()
        result.success("OK")
    }

    private fun handleAudioVideoStartLocalVideo(result: MethodChannel.Result)
    {
        if (!checkAudioVideoFacade(result, "AudioVideoStartLocalVideo"))
            return

        _audioVideoFacade!!.startLocalVideo()
        result.success("OK")
    }

    private fun handleAudioVideoStopLocalVideo(result: MethodChannel.Result)
    {
        if (!checkAudioVideoFacade(result, "AudioVideoStopLocalVideo"))
            return

        _audioVideoFacade!!.stopLocalVideo()
        result.success("OK")
    }

    private fun handleAudioVideoStartRemoteVideo(result: MethodChannel.Result)
    {
        if (!checkAudioVideoFacade(result, "AudioVideoStartRemoteVideo"))
            return

        _audioVideoFacade!!.startRemoteVideo()
        result.success("OK")
    }

    private fun handleAudioVideoStopRemoteVideo(result: MethodChannel.Result)
    {
        if (!checkAudioVideoFacade(result, "AudioVideoStopRemoteVideo"))
            return

        _audioVideoFacade!!.stopRemoteVideo()
        result.success("OK")
    }

    private fun handleBindVideoView(call: MethodCall, result: MethodChannel.Result)
    {
        if (!checkAudioVideoFacade(result, "BindVideoView"))
            return

        val viewId = call.argument<Int>("ViewId")!!
        val tileId = call.argument<Int>("TileId")!!

        val videoRenderView: VideoRenderView = ChimeDefaultVideoRenderViewFactory.getViewById(viewId)!!.videoRenderView
        _audioVideoFacade!!.bindVideoView(videoRenderView, tileId)
        result.success("OK")
    }

    private fun handleUnbindVideoView(call: MethodCall, result: MethodChannel.Result)
    {
        if (!checkAudioVideoFacade(result, "UnbindVideoView"))
            return

        val tileId = call.argument<Int>("TileId")!!

        _audioVideoFacade!!.unbindVideoView(tileId)
        result.success("OK")
    }

    private fun handleMute(result: MethodChannel.Result)
    {
        if (!checkAudioVideoFacade(result, "Mute"))
            return

        _audioVideoFacade!!.realtimeLocalMute()
        result.success("OK")
    }

    private fun handleUnmute(result: MethodChannel.Result)
    {
        if (!checkAudioVideoFacade(result, "Unmute"))
            return

        _audioVideoFacade!!.realtimeLocalUnmute()
        result.success("OK")
    }

    private fun handleListAudioDevices(result: MethodChannel.Result)
    {
        if (!checkAudioVideoFacade(result, "ListAudioDevices"))
            return

        var jsonString = ""
        for (device in _audioVideoFacade!!.listAudioDevices())
            jsonString += "{\"Label\": \"" + device.label + "\", \"Type\": \"" + device.type + "\", \"Port\": \"no-port\", \"Description\": \"no-description\"},"

        jsonString = jsonString.substring(0, jsonString.length - 1)
        jsonString = "[" + jsonString + "]"
        result.success(jsonString)
    }

    private fun handleChooseAudioDevice(call: MethodCall, result: MethodChannel.Result)
    {
        if (!checkAudioVideoFacade(result, "ChooseAudioDevice"))
            return

        // ​val deviceName = call.argument<String>("label")
        val deviceLabel = call.argument<String>("Label")

        for (device in _audioVideoFacade!!.listAudioDevices())
        {
            if (device.label == deviceLabel)
            {
                _audioVideoFacade!!.chooseAudioDevice(mediaDevice = device)
                result.success("OK")
                return
            }
        }

        // result.error(ERROR__NO_AUDIO_VIDEO_FACADE__ERROR_CODE, "exeption caught during choosing an audio device", null)
    }

    private fun checkAudioVideoFacade(result: MethodChannel.Result, source: String): Boolean
    {
        if (_meetingSession == null)
        {
            result.error(ERROR__NO_MEETING_SESSION__ERROR_CODE, "$source: $ERROR__NO_MEETING_SESSION__ERROR_MESSAGE", null)
            return false
        }

        if (_audioVideoFacade == null)
        {
            result.error(ERROR__NO_AUDIO_VIDEO_FACADE__ERROR_CODE, "$source: $ERROR__NO_AUDIO_VIDEO_FACADE__ERROR_MESSAGE", null)
            return false
        }

        return true
    }

    companion object
    {
        private const val TAG = "ChimePlugin"
        private const val ERROR__NO_MEETING_SESSION__ERROR_CODE = "1"
        private const val ERROR__NO_MEETING_SESSION__ERROR_MESSAGE = "No MeetingSession created."
        private const val ERROR__NO_AUDIO_VIDEO_FACADE__ERROR_CODE = "2"
        private const val ERROR__NO_AUDIO_VIDEO_FACADE__ERROR_MESSAGE = "No AudioVideoFacade created."
    }
}
