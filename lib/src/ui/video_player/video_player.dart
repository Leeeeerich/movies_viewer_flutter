import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;

  VideoPlayerScreen(this.url, {Key key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  int step;
  var lastPosition = 0.0;
  var isContinuePlaying = false;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.url);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(children: <Widget>[
                VideoPlayer(_controller),
                GestureDetector(
                  onTap: () {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                  },
                  onHorizontalDragStart: (start) {
                    step = _controller.value.duration.inMilliseconds ~/ 100;
                    if (_controller.value.isPlaying) {
                      isContinuePlaying = true;
                      _controller.pause();
                    }
                    lastPosition = start.globalPosition.dx;
                  },
                  onHorizontalDragUpdate: (scrollPosition) {
                    var position = _controller.value.position.inMilliseconds;
                    var newPosition = position +
                        (step *
                            ((lastPosition -
                                    scrollPosition.globalPosition.dx) ~/
                                100));
                    _controller.seekTo(Duration(milliseconds: newPosition));
                    print(position);
                  },
                  onHorizontalDragEnd: (end) {
                    if (isContinuePlaying) {
                      _controller.play();
                      isContinuePlaying = false;
                    }
                    lastPosition = 0;
                  },
                ),
                Container(
                    alignment: Alignment.bottomCenter,
                    child: VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                    )),
              ]),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
