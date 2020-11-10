'use strict';

const {v4: uuidv4} = require('uuid');

const AWS = require('aws-sdk');

let chime;

function init()
{
    if (chime)
        return;

    AWS.config.loadFromPath('./secrets/aws.json');

    // You must currently use us-east-1 as the region (you can select a MediaRegion in the following step).
    chime = new AWS.Chime({region: 'us-east-1'});

    // https://github.com/aws/amazon-chime-sdk-js/issues/283
    // No DNS resolution to chime.<region>.amazonaws.com
    chime.endpoint = new AWS.Endpoint('https://service.chime.aws.amazon.com');
}

exports.listMeetings = async function listMeetings()
{
    init();

    const meetings = await chime.listMeetings().promise();

    return meetings.Meetings;
}

exports.listAttendees = async function listAttendees(meetingId)
{
    init();

    const attendees = await chime.listAttendees({MeetingId: meetingId}).promise();

    return attendees.Attendees;
}

exports.createMeeting = async function createMeeting(externalMeetingId)
{
    init();

    const clientRequestToken = uuidv4();
    // eu-central-1 = Frankfurt, Germany
    const mediaRegion = 'eu-central-1';
    const params =
        {
            ClientRequestToken: clientRequestToken,
            ExternalMeetingId: externalMeetingId,
            MediaRegion: mediaRegion
        };

    const meeting = await chime.createMeeting(params).promise();

    return meeting.Meeting;
}

exports.createAttendee = async function createAttendee(chimeMeetingId, externalUserId)
{
    init();

    const params =
        {
            ExternalUserId: externalUserId,
            MeetingId: chimeMeetingId
        };

    const attendee = await chime.createAttendee(params).promise();

    return attendee.Attendee;
}
