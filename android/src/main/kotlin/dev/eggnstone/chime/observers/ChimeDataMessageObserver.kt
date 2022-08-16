package dev.eggnstone.chime.observers

import com.amazonaws.services.chime.sdk.meetings.realtime.datamessage.DataMessage
import com.amazonaws.services.chime.sdk.meetings.realtime.datamessage.DataMessageObserver
import io.flutter.plugin.common.EventChannel.EventSink
import org.json.JSONObject

class ChimeDataMessageObserver(private val _eventSink: EventSink) : DataMessageObserver
{
    override fun onDataMessageReceived(dataMessage: DataMessage)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("Data", dataMessage.data)
        eventArguments.put("SenderAttendeeId", dataMessage.senderAttendeeId)
        eventArguments.put("SenderExternalUserId", dataMessage.senderExternalUserId)
        eventArguments.put("Text", dataMessage.text())
        eventArguments.put("Throttled", dataMessage.throttled)
        eventArguments.put("TimestampMs", dataMessage.timestampMs)
        eventArguments.put("Topic", dataMessage.topic)
        jsonObject.put("Name", "onDataMessageReceived")
        jsonObject.put("Arguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }
}
