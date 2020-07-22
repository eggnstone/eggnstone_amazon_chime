package dev.eggnstone.chime.observers

import com.amazonaws.services.chime.sdk.meetings.audiovideo.metric.MetricsObserver
import com.amazonaws.services.chime.sdk.meetings.audiovideo.metric.ObservableMetric

class ChimeMetricsObserver : MetricsObserver
{
    override fun onMetricsReceived(metrics: Map<ObservableMetric, Any>)
    {
        //Log.d(TAG, "onMetricsReceived: map=" + map);
    }

    companion object
    {
        //private const val TAG = "ChimeMetricsObserver"
    }
}
