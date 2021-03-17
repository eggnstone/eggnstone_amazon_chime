import 'package:chime_example/data/Attendee.dart';

class Attendees
{
    final List<Attendee> _attendees = List<Attendee>.empty(growable: true);

    get length
    => _attendees.length;

    Attendee operator [](int index)
    => _attendees[index];

    void add(Attendee attendee)
    => _attendees.add(attendee);

    void remove(Attendee attendee)
    => _attendees.remove(attendee);

    Attendee? getByTileId(int tileId)
    {
        for (int i = 0; i < _attendees.length; i++)
            if (_attendees[i].tileId == tileId)
                return _attendees[i];

        return null;
    }
}
