import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies_viewer_flutter/src/ui/ui_utils.dart';
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
  var isContinuePlaying = false;
  GlobalKey _globalKey = GlobalKey();
  StreamController<LabelEvents> _progressLabelController =
      StreamController<LabelEvents>();
  bool _visibilityLabel = false;

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
    _progressLabelController.close();
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
            return Stack(
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(color: Colors.black),
                    alignment: Alignment.center,
                    child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller))),
                GestureDetector(
                  onTap: () {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                  },
                  onHorizontalDragStart: (start) {
                    RenderBox box =
                        _globalKey.currentContext.findRenderObject();
                    step = _controller.value.duration.inMilliseconds ~/
                        box.size.width;
                    if (_controller.value.isPlaying) {
                      isContinuePlaying = true;
                      _controller.pause();
                    }
                    _progressLabelController.add(LabelEvents.START_SCROLLING);
                  },
                  onHorizontalDragUpdate: (scrollPosition) {
                    var position = _controller.value.position.inMilliseconds;
                    var newPosition =
                        position + (step * scrollPosition.delta.dx);
                    _controller
                        .seekTo(Duration(milliseconds: newPosition.toInt()));
                    _progressLabelController.add(LabelEvents.UPDATE_POSITION);
                  },
                  onHorizontalDragEnd: (end) {
                    if (isContinuePlaying) {
                      _controller.play();
                      isContinuePlaying = false;
                    }
                    _progressLabelController.add(LabelEvents.END_SCROLLING);
                  },
                ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
//                      Expanded(
//                          flex: 0,
//                          child: Container(
//                              padding: EdgeInsets.all(4),
//                              decoration: BoxDecoration(
//                                shape: BoxShape.rectangle,
//                                color: getColorFromHex("#B34A4444"),
//                              ),
//                              child: _showPositionTime())),
                      Expanded(
                          child: Container(
                              key: _globalKey,
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    _showLabel(),
                                    VideoProgressIndicator(
                                      _controller,
                                      allowScrubbing: true,
                                      colors: VideoProgressColors(
                                          playedColor: Colors.green),
                                    )
                                  ]))),
//                      Expanded(
//                          flex: 0,
//                          child: Container(
//                            padding: EdgeInsets.all(4),
//                            decoration: BoxDecoration(
//                              shape: BoxShape.rectangle,
//                              color: getColorFromHex("#B34A4444"),
//                            ),
//                            child: Text(
//                              printDuration(_controller.value.duration),
//                              style: TextStyle(
//                                color: getColorFromHex("#E2E2E2"),
//                              ),
//                            ),
//                          )),
                    ]),
              ],
            );
          } else {
            return Center(
                child: SpinKitCubeGrid(size: 51.0, color: Colors.blue));
          }
        },
      ),
    );
  }

  Widget _showPositionTime() => StreamBuilder<Duration>(
        stream: Stream.fromFuture(_controller.position),
        builder: (context, snapshot) {
          print("SnapShot =  " + snapshot.data.toString());
          return Text(
            snapshot.hasData ? printDuration(snapshot.data) : "00:00",
            style: TextStyle(
              color: getColorFromHex("#E2E2E2"),
            ),
          );
        },
      );

  Widget _showLabel() {
    return StreamBuilder<LabelEvents>(
        stream: _progressLabelController.stream,
        builder: (context, event) {
          if (event.data == LabelEvents.UPDATE_POSITION) {
            _visibilityLabel = true;
          } else if (event.data == LabelEvents.END_SCROLLING) {
            _visibilityLabel = false;
          }
          return Visibility(
              visible: _visibilityLabel,
              child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Transform.translate(
                      offset: Offset(-30, 0.0),
                      child: Column(children: <Widget>[
                        LinearProgressIndicator(
                          value: _controller.value.position.inMilliseconds /
                              _controller.value.duration.inMilliseconds,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: getColorFromHex("#B34A4444"),
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Text(
                            _controller.value.position != null
                                ? printDuration(_controller.value.position)
                                : "00:00",
                            style: TextStyle(
                              color: getColorFromHex("#E2E2E2"),
                            ),
                          ),
                        ),
                        Container(
                          child: SvgPicture.asset(
                              "assets/images/top_triangle.svg"),
                        )
                      ]))));
        });
  }
}

enum LabelEvents { START_SCROLLING, UPDATE_POSITION, END_SCROLLING }
