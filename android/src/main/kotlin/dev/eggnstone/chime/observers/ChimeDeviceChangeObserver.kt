package dev.eggnstone.chime.observers

import com.amazonaws.services.chime.sdk.meetings.device.DeviceChangeObserver
import com.amazonaws.services.chime.sdk.meetings.device.MediaDevice
import io.flutter.plugin.common.EventChannel.EventSink
import org.json.JSONObject

class ChimeDeviceChangeObserver(private val _eventSink: EventSink) : DeviceChangeObserver
{
    override fun onAudioDeviceChanged(freshAudioDeviceList: List<MediaDevice>)
    {
        // TODO: params
        val jsonObject = JSONObject()
        jsonObject.put("EventName", "onAudioDeviceChanged")
        _eventSink.success(jsonObject.toString())
    }
}
