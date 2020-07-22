package dev.eggnstone.chime.observers

import android.util.Log
import com.amazonaws.services.chime.sdk.meetings.device.DeviceChangeObserver
import com.amazonaws.services.chime.sdk.meetings.device.MediaDevice

class ChimeDeviceChangeObserver : DeviceChangeObserver
{
    override fun onAudioDeviceChanged(freshAudioDeviceList: List<MediaDevice>)
    {
        Log.d(TAG, "onAudioDeviceChanged: list=$freshAudioDeviceList")
    }

    companion object
    {
        private const val TAG = "ChimeDeviceChangeOb"
    }
}
