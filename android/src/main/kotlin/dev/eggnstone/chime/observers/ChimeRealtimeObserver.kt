package dev.eggnstone.chime.observers

import com.amazonaws.services.chime.sdk.meetings.audiovideo.AttendeeInfo
import com.amazonaws.services.chime.sdk.meetings.audiovideo.SignalUpdate
import com.amazonaws.services.chime.sdk.meetings.audiovideo.VolumeUpdate
import com.amazonaws.services.chime.sdk.meetings.realtime.RealtimeObserver
import io.flutter.plugin.common.EventChannel.EventSink
import org.json.JSONObject

class ChimeRealtimeObserver(private val _eventSink: EventSink) : RealtimeObserver
{
    override fun onAttendeesDropped(attendeeInfos: Array<AttendeeInfo>)
    {
        // TODO: params
        val jsonObject = JSONObject()
        jsonObject.put("EventName", "onAttendeesDropped")
        _eventSink.success(jsonObject.toString())
    }

    override fun onAttendeesJoined(attendeeInfos: Array<AttendeeInfo>)
    {
        // TODO: params
        val jsonObject = JSONObject()
        jsonObject.put("EventName", "onAttendeesJoined")
        _eventSink.success(jsonObject.toString())
    }

    override fun onAttendeesLeft(attendeeInfos: Array<AttendeeInfo>)
    {
        // TODO: params
        val jsonObject = JSONObject()
        jsonObject.put("EventName", "onAttendeesLeft")
        _eventSink.success(jsonObject.toString())
    }

    override fun onAttendeesMuted(attendeeInfos: Array<AttendeeInfo>)
    {
        // TODO: params
        val jsonObject = JSONObject()
        jsonObject.put("EventName", "onAttendeesMuted")
        _eventSink.success(jsonObject.toString())
    }

    override fun onAttendeesUnmuted(attendeeInfos: Array<AttendeeInfo>)
    {
        // TODO: params
        val jsonObject = JSONObject()
        jsonObject.put("EventName", "onAttendeesUnmuted")
        _eventSink.success(jsonObject.toString())
    }

    override fun onSignalStrengthChanged(signalUpdates: Array<SignalUpdate>)
    {
        // TODO: params
        val jsonObject = JSONObject()
        jsonObject.put("EventName", "onSignalStrengthChanged")
        _eventSink.success(jsonObject.toString())
    }

    override fun onVolumeChanged(volumeUpdates: Array<VolumeUpdate>)
    {
        // TODO: params
        val jsonObject = JSONObject()
        jsonObject.put("EventName", "onVolumeChanged")
        _eventSink.success(jsonObject.toString())
    }
}
