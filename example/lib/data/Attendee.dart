import 'package:eggnstone_amazon_chime/eggnstone_amazon_chime.dart';

class Attendee {
  final int tileId;
  final bool isLocalTile;
  final String attendeeId;
  final int height;
  final int width;

  int? _viewId;
  ChimeDefaultVideoRenderView? _videoView;

  int? get viewId => _viewId;

  ChimeDefaultVideoRenderView? get videoView => _videoView;

  get aspectRatio => width / height;

  Attendee(
      this.tileId, this.isLocalTile, this.attendeeId, this.height, this.width);

  void setViewId(int viewId) {
    if (_viewId != null) throw Exception('ViewId already set!');

    _viewId = viewId;
  }

  void setVideoView(ChimeDefaultVideoRenderView videoView) {
    if (_videoView != null) throw Exception('VideoView already set!');

    _videoView = videoView;
  }
}
