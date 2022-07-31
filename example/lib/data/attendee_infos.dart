import 'package:chime_example/data/attendee_info.dart';

class AttendeeInfos {
  final List<AttendeeInfo> _attendees =
      List<AttendeeInfo>.empty(growable: true);

  get length => _attendees.length;
  AttendeeInfo operator [](int index) => _attendees[index];

  void add(AttendeeInfo attendee) => _attendees.add(attendee);

  void remove(AttendeeInfo attendee) => _attendees.remove(attendee);

  AttendeeInfo? getByAttendeeId(String attendeeId) {
    for (int i = 0; i < _attendees.length; i++) {
      if (_attendees[i].attendeeId == attendeeId) return _attendees[i];
    }

    return null;
  }
}
