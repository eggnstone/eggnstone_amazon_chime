package dev.eggnstone.chime.observers

import com.amazonaws.services.chime.sdk.meetings.audiovideo.video.VideoTileObserver
import com.amazonaws.services.chime.sdk.meetings.audiovideo.video.VideoTileState
import io.flutter.plugin.common.EventChannel.EventSink
import org.json.JSONObject

class ChimeVideoTileObserver(private val _eventSink: EventSink) : VideoTileObserver
{
    override fun onVideoTileAdded(tileState: VideoTileState)
    {
        val jsonObject = JSONObject()
        jsonObject.put("name", "onVideoTileAdded")
        jsonObject.put("arguments", convertVideoTileStateToJson(tileState))
        _eventSink.success(jsonObject.toString())
    }

    override fun onVideoTilePaused(tileState: VideoTileState)
    {
        val jsonObject = JSONObject()
        jsonObject.put("name", "onVideoTilePaused")
        jsonObject.put("arguments", convertVideoTileStateToJson(tileState))
        _eventSink.success(jsonObject.toString())
    }

    override fun onVideoTileRemoved(tileState: VideoTileState)
    {
        val jsonObject = JSONObject()
        jsonObject.put("name", "onVideoTileRemoved")
        jsonObject.put("arguments", convertVideoTileStateToJson(tileState))
        _eventSink.success(jsonObject.toString())
    }

    override fun onVideoTileResumed(tileState: VideoTileState)
    {
        val jsonObject = JSONObject()
        jsonObject.put("name", "onVideoTileResumed")
        jsonObject.put("arguments", convertVideoTileStateToJson(tileState))
        _eventSink.success(jsonObject.toString())
    }

    private fun convertVideoTileStateToJson(tileState: VideoTileState): JSONObject
    {
        val jsonObject = JSONObject()

        jsonObject.put("attendeeId", tileState.attendeeId)
        jsonObject.put("isContent", tileState.isContent)
        jsonObject.put("isLocalTile", tileState.isLocalTile)
        jsonObject.put("pauseState", tileState.pauseState)
        jsonObject.put("tileId", tileState.tileId)

        // https://aws.github.io/amazon-chime-sdk-android/amazon-chime-sdk/com.amazonaws.services.chime.sdk.meetings.audiovideo.video/-video-tile-state/video-stream-content-height.html
        // Documented but does not compile. New in 0.6.0?
        //jsonObject.put("videoStreamContentHeight", tileState.videoStreamContentHeight)
        //jsonObject.put("videoStreamContentWidth", tileState.videoStreamContentWidth)

        return jsonObject
    }
}
