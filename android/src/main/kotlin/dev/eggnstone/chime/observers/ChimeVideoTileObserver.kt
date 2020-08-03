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
        jsonObject.put("Name", "OnVideoTileAdded")
        jsonObject.put("Arguments", convertVideoTileStateToJson(tileState))
        _eventSink.success(jsonObject.toString())
    }

    override fun onVideoTilePaused(tileState: VideoTileState)
    {
        val jsonObject = JSONObject()
        jsonObject.put("Name", "OnVideoTilePaused")
        jsonObject.put("Arguments", convertVideoTileStateToJson(tileState))
        _eventSink.success(jsonObject.toString())
    }

    override fun onVideoTileRemoved(tileState: VideoTileState)
    {
        val jsonObject = JSONObject()
        jsonObject.put("Name", "OnVideoTileRemoved")
        jsonObject.put("Arguments", convertVideoTileStateToJson(tileState))
        _eventSink.success(jsonObject.toString())
    }

    override fun onVideoTileResumed(tileState: VideoTileState)
    {
        val jsonObject = JSONObject()
        jsonObject.put("Name", "OnVideoTileResumed")
        jsonObject.put("Arguments", convertVideoTileStateToJson(tileState))
        _eventSink.success(jsonObject.toString())
    }

    private fun convertVideoTileStateToJson(tileState: VideoTileState): JSONObject
    {
        val jsonObject = JSONObject()

        jsonObject.put("AttendeeId", tileState.attendeeId)
        jsonObject.put("IsContent", tileState.isContent)
        jsonObject.put("IsLocalTile", tileState.isLocalTile)
        jsonObject.put("PauseState", tileState.pauseState)
        jsonObject.put("TileId", tileState.tileId)

        // https://aws.github.io/amazon-chime-sdk-android/amazon-chime-sdk/com.amazonaws.services.chime.sdk.meetings.audiovideo.video/-video-tile-state/video-stream-content-height.html
        // Documented but does not compile. New in 0.6.0?
        //jsonObject.put("VideoStreamContentHeight", tileState.videoStreamContentHeight)
        //jsonObject.put("VideoStreamContentWidth", tileState.videoStreamContentWidth)

        return jsonObject
    }
}
