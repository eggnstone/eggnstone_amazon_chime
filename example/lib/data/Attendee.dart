import 'package:flutter/material.dart';

class Attendee
{
    final int tileId;

    Widget videoView;

    int _viewId;

    get viewId
    => _viewId;

    Attendee(this.tileId);

    void setViewId(int viewId)
    {
        if (_viewId != null)
            throw Exception('ViewId already set!');

        _viewId = viewId;
    }
}
