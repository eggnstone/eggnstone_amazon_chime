package dev.eggnstone.chime.observers

import com.amazonaws.services.chime.sdk.meetings.audiovideo.metric.MetricsObserver
import com.amazonaws.services.chime.sdk.meetings.audiovideo.metric.ObservableMetric
import io.flutter.plugin.common.EventChannel.EventSink
import org.json.JSONObject

class ChimeMetricsObserver(private val _eventSink: EventSink) : MetricsObserver
{
    override fun onMetricsReceived(metrics: Map<ObservableMetric, Any>)
    {
        val jsonObject = JSONObject()
        val eventArguments = JSONObject()
        eventArguments.put("metrics", convertMetricsToJson(metrics))
        jsonObject.put("name", "onMetricsReceived")
        jsonObject.put("arguments", eventArguments)
        _eventSink.success(jsonObject.toString())
    }

    private fun convertMetricsToJson(metrics: Map<ObservableMetric, Any>): JSONObject
    {
        val jsonObject = JSONObject()

        for (metric in metrics)
            jsonObject.put(metric.key.toString(), metric.value.toString())

        return jsonObject
    }
}
