import 'dart:io';

import 'package:flutter/material.dart';

/// A view where local or remote video gets rendered
class ChimeDefaultVideoRenderView extends StatefulWidget
{
    /// Event to be called when the view gets created
    final ValueChanged<int>? onPlatformViewCreated;

    /// Creates a [ChimeDefaultVideoRenderView].
    /// Optional: [onPlatformViewCreated] event to be called when the view gets created.
    ChimeDefaultVideoRenderView({this.onPlatformViewCreated});

    @override
    _ChimeDefaultVideoRenderViewState createState()
    => _ChimeDefaultVideoRenderViewState();
}

class _ChimeDefaultVideoRenderViewState extends State<ChimeDefaultVideoRenderView>
{
    @override
    Widget build(BuildContext context)
    {
        if (Platform.isAndroid)
        {
            return AndroidView(
                viewType: 'ChimeDefaultVideoRenderView',
                onPlatformViewCreated: (int viewId)
                => widget.onPlatformViewCreated?.call(viewId),
            );
        }
        else if (Platform.isIOS)
        {
            return UiKitView(
                viewType: 'ChimeDefaultVideoRenderView',
                onPlatformViewCreated: (int viewId)
                => widget.onPlatformViewCreated?.call(viewId),
            );
        }
        else
            throw Exception('Not implemented');
    }
}
