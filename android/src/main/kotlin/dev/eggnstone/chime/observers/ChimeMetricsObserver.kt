package dev.eggnstone.chime.observers

import com.amazonaws.services.chime.sdk.meetings.audiovideo.metric.MetricsObserver
import com.amazonaws.services.chime.sdk.meetings.audiovideo.metric.ObservableMetric
import io.flutter.plugin.common.EventChannel.EventSink
import org.json.JSONObject

class ChimeMetricsObserver(private val _eventSink: EventSink) : MetricsObserver
{
    override fun onMetricsReceived(metrics: Map<ObservableMetric, Any>)
    {
        // TODO: params
        val jsonObject = JSONObject()
        jsonObject.put("EventName", "onMetricsReceived")
        _eventSink.success(jsonObject.toString())
    }
}
