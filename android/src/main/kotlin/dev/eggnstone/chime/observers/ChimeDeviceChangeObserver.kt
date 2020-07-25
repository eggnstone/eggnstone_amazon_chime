package dev.eggnstone.chime.observers

import com.amazonaws.services.chime.sdk.meetings.device.DeviceChangeObserver
import com.amazonaws.services.chime.sdk.meetings.device.MediaDevice
import io.flutter.plugin.common.EventChannel.EventSink
import org.json.JSONArray
import org.json.JSONObject

class ChimeDeviceChangeObserver(private val _eventSink: EventSink) : DeviceChangeObserver
{
    override fun onAudioDeviceChanged(mediaDevices: List<MediaDevice>)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("mediaDevices", convertMediaDevicesToJson(mediaDevices))
        jsonObject.put("name", "onAudioDeviceChanged")
        jsonObject.put("arguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }

    private fun convertMediaDevicesToJson(mediaDevices: List<MediaDevice>): JSONArray
    {
        val list = JSONArray()

        for (mediaDevice in mediaDevices)
        {
            val item = JSONObject()
            item.put("label", mediaDevice.label)
            item.put("order", mediaDevice.order)
            item.put("type", mediaDevice.type)
            list.put(item)
        }

        return list
    }
}
