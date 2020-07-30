import 'dart:io';

import 'package:flutter/material.dart';

class ChimeDefaultVideoRenderView extends StatefulWidget {
  final ValueChanged<int> onPlatformViewCreated;

  ChimeDefaultVideoRenderView({this.onPlatformViewCreated});

  @override
  _ChimeDefaultVideoRenderViewState createState() =>
      _ChimeDefaultVideoRenderViewState();
}

class _ChimeDefaultVideoRenderViewState
    extends State<ChimeDefaultVideoRenderView> {
  @override
  Widget build(BuildContext context) {
    print('building ChimeDefaultVideoRenderView for iOS: ${Platform.isIOS}');

    if (Platform.isAndroid) {
      return AndroidView(
        viewType: 'ChimeDefaultVideoRenderView',
        onPlatformViewCreated: (int viewId) =>
            widget.onPlatformViewCreated?.call(viewId),
      );
    } else {
      return UiKitView(
        viewType: 'ChimeDefaultVideoRenderView',
        onPlatformViewCreated: (int viewId) =>
            widget.onPlatformViewCreated?.call(viewId),
      );
    }
  }
}
