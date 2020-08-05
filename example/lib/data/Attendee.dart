import 'package:flutter/material.dart';

class Attendee
{
    final int tileId;
    final bool isLocalTile;

    int _viewId;
    Widget _videoView;

    int height;
    int width;

    get viewId
    => _viewId;

    get videoView
    => _videoView;

    get aspectRatio
    => height == null || height == 0 || width == null || width == 0 ? 1.0 : width / height;

    Attendee(this.tileId, this.isLocalTile);

    void setViewId(int viewId)
    {
        if (_viewId != null)
            throw Exception('ViewId already set!');

        _viewId = viewId;
    }

    void setVideoView(Widget videoView)
    {
        if (_videoView != null)
            throw Exception('VideoView already set!');

        _videoView = videoView;
    }
}
