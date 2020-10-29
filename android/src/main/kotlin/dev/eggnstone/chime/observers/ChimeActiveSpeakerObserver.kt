package dev.eggnstone.chime.observers

import android.os.Handler
import android.os.Looper.getMainLooper
import com.amazonaws.services.chime.sdk.meetings.audiovideo.AttendeeInfo
import com.amazonaws.services.chime.sdk.meetings.audiovideo.audio.activespeakerdetector.ActiveSpeakerObserver
import io.flutter.plugin.common.EventChannel
import org.json.JSONArray
import org.json.JSONObject

class ChimeActiveSpeakerDetectedObserver(private val _eventSink: EventChannel.EventSink) : ActiveSpeakerObserver
{
    override val scoreCallbackIntervalMs: Int?
        get() = null

    override fun onActiveSpeakerDetected(attendeeInfos: Array<AttendeeInfo>)
    {
        val jsonObject = JSONObject()
        jsonObject.put("Name", "OnActiveSpeakerDetected")
        jsonObject.put("Arguments", convertAttendeeInfosToJson(attendeeInfos))

        Handler(getMainLooper()).post {
            _eventSink.success(jsonObject.toString())
        }
    }

    override fun onActiveSpeakerScoreChanged(scores: Map<AttendeeInfo, Double>)
    {
        val jsonObject = JSONObject()
        jsonObject.put("Name", "OnActiveSpeakerScoreChanged")
        _eventSink.success(jsonObject.toString())
    }

    private fun convertAttendeeInfosToJson(attendeeInfos: Array<AttendeeInfo>): JSONArray
    {
        val list = JSONArray()

        for (info in attendeeInfos)
        {
            val item = JSONObject()
            item.put("AttendeeId", info.attendeeId)
            item.put("ExternalUserId", info.externalUserId)
            list.put(item)
        }

        return list
    }
}
