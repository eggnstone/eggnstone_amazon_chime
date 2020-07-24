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
        jsonObject.put("EventName", "onAudioSessionCancelledReconnect")
        _eventSink.success(jsonObject.toString())
    }

    override fun onAudioSessionDropped()
    {
        val jsonObject = JSONObject()
        jsonObject.put("EventName", "onAudioSessionDropped")
        _eventSink.success(jsonObject.toString())
    }

    override fun onAudioSessionStarted(reconnecting: Boolean)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("Reconnecting", reconnecting)
        jsonObject.put("EventName", "onAudioSessionStarted")
        jsonObject.put("EventArguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }

    override fun onAudioSessionStartedConnecting(reconnecting: Boolean)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("Reconnecting", reconnecting)
        jsonObject.put("EventName", "onAudioSessionStartedConnecting")
        jsonObject.put("EventArguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }

    override fun onAudioSessionStopped(sessionStatus: MeetingSessionStatus)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("SessionStatusCode", sessionStatus.statusCode)
        jsonObject.put("EventName", "onAudioSessionStopped")
        jsonObject.put("EventArguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }

    override fun onConnectionBecamePoor()
    {
        val jsonObject = JSONObject()
        jsonObject.put("EventName", "onConnectionBecamePoor")
        _eventSink.success(jsonObject.toString())
    }

    override fun onConnectionRecovered()
    {
        val jsonObject = JSONObject()
        jsonObject.put("EventName", "onConnectionRecovered")
        _eventSink.success(jsonObject.toString())
    }

    override fun onVideoSessionStarted(sessionStatus: MeetingSessionStatus)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("SessionStatusCode", sessionStatus.statusCode)
        jsonObject.put("EventName", "onVideoSessionStarted")
        jsonObject.put("EventArguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }

    override fun onVideoSessionStartedConnecting()
    {
        val jsonObject = JSONObject()
        jsonObject.put("EventName", "onVideoSessionStartedConnecting")
        _eventSink.success(jsonObject.toString())
    }

    override fun onVideoSessionStopped(sessionStatus: MeetingSessionStatus)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("SessionStatusCode", sessionStatus.statusCode)
        jsonObject.put("EventName", "onVideoSessionStopped")
        jsonObject.put("EventArguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }
}
