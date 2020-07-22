package dev.eggnstone.chime.observers

import android.util.Log
import com.amazonaws.services.chime.sdk.meetings.audiovideo.AudioVideoObserver
import com.amazonaws.services.chime.sdk.meetings.session.MeetingSessionStatus

class ChimeAudioVideoObserver : AudioVideoObserver
{
    override fun onAudioSessionCancelledReconnect()
    {
        Log.d(TAG, "onAudioSessionCancelledReconnect")
    }

    override fun onAudioSessionDropped()
    {
        Log.d(TAG, "onAudioSessionDropped")
    }

    override fun onAudioSessionStarted(reconnecting: Boolean)
    {
        Log.d(TAG, "onAudioSessionStarted: reconnecting=$reconnecting")
    }

    override fun onAudioSessionStartedConnecting(reconnecting: Boolean)
    {
        Log.d(TAG, "onAudioSessionStartedConnecting: reconnecting=$reconnecting")
    }

    override fun onAudioSessionStopped(sessionStatus: MeetingSessionStatus)
    {
        Log.d(TAG, "onAudioSessionStopped: sessionStatus=$sessionStatus")
    }

    override fun onConnectionBecamePoor()
    {
        Log.d(TAG, "onConnectionBecamePoor")
    }

    override fun onConnectionRecovered()
    {
        Log.d(TAG, "onConnectionRecovered")
    }

    override fun onVideoSessionStarted(sessionStatus: MeetingSessionStatus)
    {
        Log.d(TAG, "onVideoSessionStarted: meetingSessionStatus=$sessionStatus")
    }

    override fun onVideoSessionStartedConnecting()
    {
        Log.d(TAG, "onVideoSessionStartedConnecting")
    }

    override fun onVideoSessionStopped(sessionStatus: MeetingSessionStatus)
    {
        Log.d(TAG, "onVideoSessionStopped: sessionStatus=$sessionStatus")
    }

    companion object
    {
        private const val TAG = "ChimeAudioVideoObserver"
    }
}
