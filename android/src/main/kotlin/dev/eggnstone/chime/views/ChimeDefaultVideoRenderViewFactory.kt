package dev.eggnstone.chime.views

import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.util.*

class ChimeDefaultVideoRenderViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE)
{
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView
    {
        val view = ChimeDefaultVideoRenderView(context)
        _viewIdToViewMap[viewId] = view
        return view
    }

    companion object
    {
        private val _viewIdToViewMap: MutableMap<Int, ChimeDefaultVideoRenderView> = HashMap()

        fun getViewById(id: Int): ChimeDefaultVideoRenderView? = _viewIdToViewMap[id]

        fun clearViewIds()
        {
            _viewIdToViewMap.clear()
        }
    }
}
