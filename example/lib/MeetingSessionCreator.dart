import 'package:eggnstone_amazon_chime/eggnstone_amazon_chime.dart';

class MeetingSessionCreator
{
    /// Adjust this function to supply your proper authenticated meeting data.
    /// This requires you to have an AWS account and Chime being set up there.
    /// This file is to be ignored by git so that your private changes never get committed.
    Future<String> create()
    {
        return Chime.createMeetingSession(
            meetingId: 'Test-MeetingId',
            externalMeetingId: 'Test-ExternalMeetingId',
            mediaRegion: 'eu-central-1',
            mediaPlacementAudioHostUrl: 'SomeGuid.k.m1.ec1.app.chime.aws:3478',
            mediaPlacementAudioFallbackUrl: 'wss://haxrp.m1.ec1.app.chime.aws:443/calls/Test-MeetingId',
            mediaPlacementSignalingUrl: 'wss://signal.m1.ec1.app.chime.aws/control/Test-MeetingId',
            mediaPlacementTurnControlUrl: 'https://ccp.cp.ue1.app.chime.aws/v2/turn_sessions',
            attendeeId: 'Test-AttendeeId',
            externalUserId: 'Test-ExternalUserId-1',
            joinToken: 'Test-JoinToken'
        );
    }
}
