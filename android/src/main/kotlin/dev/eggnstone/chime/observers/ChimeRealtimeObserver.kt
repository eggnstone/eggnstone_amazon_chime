package dev.eggnstone.chime.observers

import com.amazonaws.services.chime.sdk.meetings.audiovideo.AttendeeInfo
import com.amazonaws.services.chime.sdk.meetings.audiovideo.SignalUpdate
import com.amazonaws.services.chime.sdk.meetings.audiovideo.VolumeUpdate
import com.amazonaws.services.chime.sdk.meetings.realtime.RealtimeObserver
import io.flutter.plugin.common.EventChannel.EventSink
import org.json.JSONArray
import org.json.JSONObject

class ChimeRealtimeObserver(private val _eventSink: EventSink) : RealtimeObserver
{
    override fun onAttendeesDropped(attendeeInfos: Array<AttendeeInfo>)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("attendeeInfos", convertAttendeeInfosToJson(attendeeInfos))
        jsonObject.put("name", "onAttendeesDropped")
        jsonObject.put("arguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }

    override fun onAttendeesJoined(attendeeInfos: Array<AttendeeInfo>)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("attendeeInfos", convertAttendeeInfosToJson(attendeeInfos))
        jsonObject.put("name", "onAttendeesJoined")
        jsonObject.put("arguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }

    override fun onAttendeesLeft(attendeeInfos: Array<AttendeeInfo>)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("attendeeInfos", convertAttendeeInfosToJson(attendeeInfos))
        jsonObject.put("name", "onAttendeesLeft")
        jsonObject.put("arguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }

    override fun onAttendeesMuted(attendeeInfos: Array<AttendeeInfo>)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("attendeeInfos", convertAttendeeInfosToJson(attendeeInfos))
        jsonObject.put("name", "onAttendeesMuted")
        jsonObject.put("arguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }

    override fun onAttendeesUnmuted(attendeeInfos: Array<AttendeeInfo>)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("attendeeInfos", convertAttendeeInfosToJson(attendeeInfos))
        jsonObject.put("name", "onAttendeesUnmuted")
        jsonObject.put("arguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }

    override fun onSignalStrengthChanged(signalUpdates: Array<SignalUpdate>)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("signalUpdates", convertSignalUpdatesToJson(signalUpdates))
        jsonObject.put("name", "onSignalStrengthChanged")
        jsonObject.put("arguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }

    override fun onVolumeChanged(volumeUpdates: Array<VolumeUpdate>)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("volumeUpdates", convertVolumeUpdatesToJson(volumeUpdates))
        jsonObject.put("name", "onVolumeChanged")
        jsonObject.put("arguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }

    private fun convertAttendeeInfosToJson(attendeeInfos: Array<AttendeeInfo>): JSONArray
    {
        val list = JSONArray()

        for (attendeeInfo in attendeeInfos)
        {
            val item = JSONObject()
            item.put("attendeeId", attendeeInfo.attendeeId)
            item.put("externalUserId", attendeeInfo.externalUserId)
            list.put(item)
        }

        return list
    }

    private fun convertSignalUpdatesToJson(signalUpdates: Array<SignalUpdate>): JSONArray
    {
        val list = JSONArray()

        for (signalUpdate in signalUpdates)
        {
            val item = JSONObject()
            item.put("attendeeId", signalUpdate.attendeeInfo.attendeeId)
            item.put("externalUserId", signalUpdate.attendeeInfo.externalUserId)
            item.put("signalStrength", signalUpdate.signalStrength)
            list.put(item)
        }

        return list
    }

    private fun convertVolumeUpdatesToJson(volumeUpdates: Array<VolumeUpdate>): JSONArray
    {
        val list = JSONArray()

        for (volumeUpdate in volumeUpdates)
        {
            val item = JSONObject()
            item.put("attendeeId", volumeUpdate.attendeeInfo.attendeeId)
            item.put("externalUserId", volumeUpdate.attendeeInfo.externalUserId)
            item.put("volumeLevel", volumeUpdate.volumeLevel)
            list.put(item)
        }

        return list
    }
}
