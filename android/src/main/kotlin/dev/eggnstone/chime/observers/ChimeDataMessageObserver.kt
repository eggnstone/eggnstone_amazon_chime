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
        eventArguments.put("timestampMs", dataMessage.timestampMs)
        eventArguments.put("topic", dataMessage.topic)
        eventArguments.put("senderAttendeeId", dataMessage.senderAttendeeId)
        eventArguments.put("senderExternalUserId", dataMessage.senderExternalUserId)
        eventArguments.put("throttled", dataMessage.throttled)
        eventArguments.put("data", dataMessage.data)
        eventArguments.put("text", dataMessage.text())
        jsonObject.put("Name", "onDataMessageReceived")
        jsonObject.put("Arguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }
}
