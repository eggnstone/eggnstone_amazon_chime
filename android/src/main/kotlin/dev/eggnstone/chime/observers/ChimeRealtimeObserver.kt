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
        eventArguments.put("AttendeeInfos", convertAttendeeInfosToJson(attendeeInfos))
        jsonObject.put("Name", "OnAttendeesDropped")
        jsonObject.put("Arguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }

    override fun onAttendeesJoined(attendeeInfos: Array<AttendeeInfo>)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("AttendeeInfos", convertAttendeeInfosToJson(attendeeInfos))
        jsonObject.put("Name", "OnAttendeesJoined")
        jsonObject.put("Arguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }

    override fun onAttendeesLeft(attendeeInfos: Array<AttendeeInfo>)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("AttendeeInfos", convertAttendeeInfosToJson(attendeeInfos))
        jsonObject.put("Name", "OnAttendeesLeft")
        jsonObject.put("Arguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }

    override fun onAttendeesMuted(attendeeInfos: Array<AttendeeInfo>)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("AttendeeInfos", convertAttendeeInfosToJson(attendeeInfos))
        jsonObject.put("Name", "OnAttendeesMuted")
        jsonObject.put("Arguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }

    override fun onAttendeesUnmuted(attendeeInfos: Array<AttendeeInfo>)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("AttendeeInfos", convertAttendeeInfosToJson(attendeeInfos))
        jsonObject.put("Name", "OnAttendeesUnmuted")
        jsonObject.put("Arguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }

    override fun onSignalStrengthChanged(signalUpdates: Array<SignalUpdate>)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("SignalUpdates", convertSignalUpdatesToJson(signalUpdates))
        jsonObject.put("Name", "OnSignalStrengthChanged")
        jsonObject.put("Arguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }

    override fun onVolumeChanged(volumeUpdates: Array<VolumeUpdate>)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("VolumeUpdates", convertVolumeUpdatesToJson(volumeUpdates))
        jsonObject.put("Name", "OnVolumeChanged")
        jsonObject.put("Arguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }

    private fun convertAttendeeInfosToJson(attendeeInfos: Array<AttendeeInfo>): JSONArray
    {
        val list = JSONArray()

        for (attendeeInfo in attendeeInfos)
        {
            val item = JSONObject()
            item.put("AttendeeId", attendeeInfo.attendeeId)
            item.put("ExternalUserId", attendeeInfo.externalUserId)
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
            item.put("AttendeeId", signalUpdate.attendeeInfo.attendeeId)
            item.put("ExternalUserId", signalUpdate.attendeeInfo.externalUserId)
            item.put("SignalStrength", signalUpdate.signalStrength)
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
            item.put("AttendeeId", volumeUpdate.attendeeInfo.attendeeId)
            item.put("ExternalUserId", volumeUpdate.attendeeInfo.externalUserId)
            item.put("VolumeLevel", volumeUpdate.volumeLevel)
            list.put(item)
        }

        return list
    }
}
