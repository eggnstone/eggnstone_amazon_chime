package dev.eggnstone.chime.views

import android.content.Context
import android.util.Log
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.util.*

class ChimeDefaultVideoRenderViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE)
{
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView
    {
        Log.d(TAG, "ChimeDefaultVideoRenderViewFactory.create: viewId=$viewId")
        val view = ChimeDefaultVideoRenderView(context)
        mViewIdToViewMap[viewId] = view
        return view
    }

    companion object
    {
        private const val TAG = "ChimeDvrvFactory"
        private val mViewIdToViewMap: MutableMap<Int, ChimeDefaultVideoRenderView> = HashMap()

        fun getViewById(id: Int): ChimeDefaultVideoRenderView? = mViewIdToViewMap[id]
    }
}
