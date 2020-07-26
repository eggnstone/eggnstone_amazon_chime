package dev.eggnstone.chime.observers

import com.amazonaws.services.chime.sdk.meetings.audiovideo.AudioVideoObserver
import com.amazonaws.services.chime.sdk.meetings.session.MeetingSessionStatus
import io.flutter.plugin.common.EventChannel.EventSink
import org.json.JSONObject

class ChimeAudioVideoObserver(private val _eventSink: EventSink) : AudioVideoObserver
{
    override fun onAudioSessionCancelledReconnect()
    {
        val jsonObject = JSONObject()
        jsonObject.put("Name", "OnAudioSessionCancelledReconnect")
        _eventSink.success(jsonObject.toString())
    }

    override fun onAudioSessionDropped()
    {
        val jsonObject = JSONObject()
        jsonObject.put("Name", "OnAudioSessionDropped")
        _eventSink.success(jsonObject.toString())
    }

    override fun onAudioSessionStarted(reconnecting: Boolean)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("Reconnecting", reconnecting)
        jsonObject.put("Name", "OnAudioSessionStarted")
        jsonObject.put("Arguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }

    override fun onAudioSessionStartedConnecting(reconnecting: Boolean)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("Reconnecting", reconnecting)
        jsonObject.put("Name", "OnAudioSessionStartedConnecting")
        jsonObject.put("Arguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }

    override fun onAudioSessionStopped(sessionStatus: MeetingSessionStatus)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("StatusCode", sessionStatus.statusCode)
        jsonObject.put("Name", "OnAudioSessionStopped")
        jsonObject.put("Arguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }

    override fun onConnectionBecamePoor()
    {
        val jsonObject = JSONObject()
        jsonObject.put("Name", "OnConnectionBecamePoor")
        _eventSink.success(jsonObject.toString())
    }

    override fun onConnectionRecovered()
    {
        val jsonObject = JSONObject()
        jsonObject.put("Name", "OnConnectionRecovered")
        _eventSink.success(jsonObject.toString())
    }

    override fun onVideoSessionStarted(sessionStatus: MeetingSessionStatus)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("StatusCode", sessionStatus.statusCode)
        jsonObject.put("Name", "OnVideoSessionStarted")
        jsonObject.put("Arguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }

    override fun onVideoSessionStartedConnecting()
    {
        val jsonObject = JSONObject()
        jsonObject.put("Name", "OnVideoSessionStartedConnecting")
        _eventSink.success(jsonObject.toString())
    }

    override fun onVideoSessionStopped(sessionStatus: MeetingSessionStatus)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("StatusCode", sessionStatus.statusCode)
        jsonObject.put("Name", "OnVideoSessionStopped")
        jsonObject.put("Arguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }
}
