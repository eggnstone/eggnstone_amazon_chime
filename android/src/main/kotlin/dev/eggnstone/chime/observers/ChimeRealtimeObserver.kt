package dev.eggnstone.chime.observers

import android.util.Log
import com.amazonaws.services.chime.sdk.meetings.audiovideo.AttendeeInfo
import com.amazonaws.services.chime.sdk.meetings.audiovideo.SignalUpdate
import com.amazonaws.services.chime.sdk.meetings.audiovideo.VolumeUpdate
import com.amazonaws.services.chime.sdk.meetings.realtime.RealtimeObserver

class ChimeRealtimeObserver : RealtimeObserver
{
    override fun onAttendeesDropped(attendeeInfo: Array<AttendeeInfo>)
    {
        Log.d(TAG, "onAttendeesDropped: attendeeInfo=$attendeeInfo")
    }

    override fun onAttendeesJoined(attendeeInfo: Array<AttendeeInfo>)
    {
        Log.d(TAG, "onAttendeesJoined: attendeeInfo=$attendeeInfo")
    }

    override fun onAttendeesLeft(attendeeInfo: Array<AttendeeInfo>)
    {
        Log.d(TAG, "onAttendeesLeft: attendeeInfo=$attendeeInfo")
    }

    override fun onAttendeesMuted(attendeeInfo: Array<AttendeeInfo>)
    {
        Log.d(TAG, "onAttendeesMuted: attendeeInfo=$attendeeInfo")
    }

    override fun onAttendeesUnmuted(attendeeInfo: Array<AttendeeInfo>)
    {
        Log.d(TAG, "onAttendeesUnmuted: attendeeInfo=$attendeeInfo")
    }

    override fun onSignalStrengthChanged(signalUpdates: Array<SignalUpdate>)
    {
        Log.d(TAG, "onSignalStrengthChanged: signalUpdates=$signalUpdates")
    }

    override fun onVolumeChanged(volumeUpdates: Array<VolumeUpdate>)
    {
        //Log.d(TAG, "onVolumeChanged: volumeUpdates=" + volumeUpdates);
    }

    companion object
    {
        private const val TAG = "ChimeRealtimeObserver"
    }
}
