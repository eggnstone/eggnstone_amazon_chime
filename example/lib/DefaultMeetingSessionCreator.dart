import 'package:eggnstone_amazon_chime/eggnstone_amazon_chime.dart';

class MeetingSessionCreator
{
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
