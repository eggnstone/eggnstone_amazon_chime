import 'package:chime_example/data/Mapping.dart';

class Mappings
{
    final List<Mapping> _mappings = List<Mapping>();

    get length
    => _mappings.length;

    void add(int viewIndex, int viewId)
    {
        _mappings.add(Mapping(viewIndex, viewId));
    }

    Mapping getByViewIndex(int viewIndex)
    {
        for (int i = 0; i < _mappings.length; i++)
            if (_mappings[i].viewIndex == viewIndex)
                return _mappings[i];

        return null;
    }

    Mapping getByTileId(int tileId)
    {
        for (int i = 0; i < _mappings.length; i++)
            if (_mappings[i].tileId == tileId)
                return _mappings[i];

        return null;
    }
}
