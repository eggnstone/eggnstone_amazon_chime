package dev.eggnstone.chime.observers

import android.util.Log
import com.amazonaws.services.chime.sdk.meetings.audiovideo.video.VideoTileObserver
import com.amazonaws.services.chime.sdk.meetings.audiovideo.video.VideoTileState
import io.flutter.plugin.common.EventChannel.EventSink
import org.json.JSONObject

class ChimeVideoTileObserver(private val mEventSink: EventSink) : VideoTileObserver
{
    override fun onVideoTileAdded(tileState: VideoTileState)
    {
        Log.d(TAG, "onVideoTileAdded: tileState=$tileState")
        try
        {
            val jsonObject = JSONObject()
            val eventArguments = JSONObject()
            eventArguments.put("TileId", tileState.tileId)
            jsonObject.put("EventName", "onVideoTileAdded")
            jsonObject.put("EventArguments", eventArguments)
            mEventSink.success(jsonObject.toString())
        }
        catch (e: Exception)
        {
            e.printStackTrace()
        }
    }

    override fun onVideoTilePaused(tileState: VideoTileState)
    {
        Log.d(TAG, "onVideoTilePaused: tileState=$tileState")
    }

    override fun onVideoTileRemoved(tileState: VideoTileState)
    {
        Log.d(TAG, "onVideoTileRemoved: tileState=$tileState")
        try
        {
            val jsonObject = JSONObject()
            val eventArguments = JSONObject()
            eventArguments.put("TileId", tileState.tileId)
            jsonObject.put("EventName", "onVideoTileRemoved")
            jsonObject.put("EventArguments", eventArguments)
            mEventSink.success(jsonObject.toString())
        }
        catch (e: Exception)
        {
            e.printStackTrace()
        }
    }

    override fun onVideoTileResumed(tileState: VideoTileState)
    {
        Log.d(TAG, "onVideoTileResumed: tileState=$tileState")
    }

    companion object
    {
        private const val TAG = "ChimeVideoTileObserver"
    }
}
