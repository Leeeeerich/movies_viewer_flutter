import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies_viewer_flutter/src/ui/ui_utils.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  /// Map (Name of video, url on video)
  final Map<String, String> urls;

  /// Key of video selected
  final String keyOfVideoSelected;

  VideoPlayerScreen(this.urls, this.keyOfVideoSelected, {Key key})
      : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  static const double ICONS_MANAGEMENT_TOOLS_SIZE = 150.0;
  static const int DURATION_SHOWING_MANAGEMENT_TOOLS = 5;
  static const Color BUTTON_COLOR = Color.fromARGB(123, 255, 255, 255);

  VideoPlayerController _controller;
  String _titleVideoName = "";
  Future<void> _initializeVideoPlayerFuture;
  int step;
  var isContinuePlaying = false;
  GlobalKey _globalKey = GlobalKey();

  Timer _showingManagementToolsTimer;

  bool _visibilityLabel = false;
  bool _isVisibleTools = false;

  @override
  void initState() {
    print("Init state");
    _playVideoFromNetwork(
        widget.keyOfVideoSelected, widget.urls[widget.keyOfVideoSelected]);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);

    SystemChrome.setEnabledSystemUIOverlays([]);
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
    _showingManagementToolsTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _getManagementTools(_isVisibleTools, _getPlayerFrame());
          } else {
            return Center(
                child: SpinKitCubeGrid(size: 51.0, color: Colors.blue));
          }
        },
      ),
    );
  }

  _playVideoFromNetwork(String videoName, String url) {
    if (_controller != null) {
      _controller.dispose();
    }
    _titleVideoName = videoName;
    _controller = VideoPlayerController.network(url);
  }

  _setOrUpdateShowingManageToolsTimer() {
    _showingManagementToolsTimer = _getResetTimer();
  }

  Timer _getResetTimer() {
    if (_showingManagementToolsTimer != null) {
      _showingManagementToolsTimer.cancel();
    }
    return Timer(Duration(seconds: DURATION_SHOWING_MANAGEMENT_TOOLS), () {
      _hideManagementTools();
    });
  }

  _showManagementTools() {
    print("Show management tools");
    setState(() {
      _visibilityLabel = true;
      _isVisibleTools = true;
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    });
    _setOrUpdateShowingManageToolsTimer();
  }

  _hideManagementTools() {
    print("Hide management tools");
    setState(() {
      SystemChrome.setEnabledSystemUIOverlays([]);
      _visibilityLabel = false;
      _isVisibleTools = false;
    });
    _showingManagementToolsTimer = null;
  }

  Widget _getPlayerFrame() => Container(
      key: _globalKey,
      decoration: BoxDecoration(color: Colors.black),
      alignment: Alignment.center,
      child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller)));

  Widget _getManagementTools(bool isVisibleTools, Widget child) {
    return Stack(children: <Widget>[
      child,
      _getGestureDetector(
        Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(isVisibleTools ? 123 : 0, 0, 0, 0)),
            alignment: Alignment.center,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Visibility(
                      visible: isVisibleTools, child: _getTitleOfVideo()),
                  Visibility(
                      visible: isVisibleTools,
                      child: _getButtonsOfManagements()),
                  Visibility(
                      visible: _visibilityLabel || _isVisibleTools,
                      child: _getVideoProgress())
                ])),
      ),
    ]);
  }

  Widget _getTitleOfVideo() => Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        padding: EdgeInsets.fromLTRB(6, 2, 2, 2),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: getColorFromHex("#B34A4444"),
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        child: Text(
          _titleVideoName,
          style: TextStyle(
            fontSize: 18,
            color: getColorFromHex("#E2E2E2"),
          ),
        ),
      );

  Widget _getButtonsOfManagements() => Expanded(
          child: Row(
              key: UniqueKey(),
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            IconButton(
                iconSize: ICONS_MANAGEMENT_TOOLS_SIZE,
                onPressed: () {
                  _setOrUpdateShowingManageToolsTimer();
                },
                icon: Container(
                    height: ICONS_MANAGEMENT_TOOLS_SIZE,
                    width: ICONS_MANAGEMENT_TOOLS_SIZE,
                    child: SvgPicture.asset("assets/icons/ic_prev.svg",
                        color: BUTTON_COLOR))),
            IconButton(
                iconSize: ICONS_MANAGEMENT_TOOLS_SIZE,
                onPressed: () {
                  print("Play/stop clicked");
                  _setOrUpdateShowingManageToolsTimer();
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                  setState(() {});
                },
                icon: Container(
                    height: ICONS_MANAGEMENT_TOOLS_SIZE,
                    width: ICONS_MANAGEMENT_TOOLS_SIZE,
                    child: SvgPicture.asset(
                        _controller.value.isPlaying
                            ? "assets/icons/ic_pause.svg"
                            : "assets/icons/ic_play.svg",
                        color: BUTTON_COLOR))),
            IconButton(
                iconSize: ICONS_MANAGEMENT_TOOLS_SIZE,
                onPressed: () {
                  _setOrUpdateShowingManageToolsTimer();
                },
                icon: Container(
                    height: ICONS_MANAGEMENT_TOOLS_SIZE,
                    width: ICONS_MANAGEMENT_TOOLS_SIZE,
                    child: SvgPicture.asset("assets/icons/ic_next.svg",
                        color: BUTTON_COLOR)))
          ]));

  GestureDetector _getGestureDetector(Widget child) {
    return GestureDetector(
      child: child,
      onTap: () {
        _showManagementTools();
      },
      onHorizontalDragStart: (start) {
        RenderBox box = _globalKey.currentContext.findRenderObject();
        step = _controller.value.duration.inMilliseconds ~/ box.size.width;

        if (_controller.value.isPlaying) {
          isContinuePlaying = true;
          _controller.pause();
        }
        setState(() {
          _visibilityLabel = true;
        });
      },
      onHorizontalDragUpdate: (scrollPosition) {
        setState(() {
          _visibilityLabel = true;
        });
        var position = _controller.value.position.inMilliseconds;
        var newPosition = position + (step * scrollPosition.delta.dx);
        _controller.seekTo(Duration(milliseconds: newPosition.toInt()));
      },
      onHorizontalDragEnd: (end) {
        if (isContinuePlaying) {
          _controller.play();
          isContinuePlaying = false;
        }
        setState(() {
          _visibilityLabel = _isVisibleTools;
        });
      },
    );
  }

  Widget _getVideoProgress() {
    return Container(
        alignment: Alignment.bottomCenter,
        child: VideoProgressLabelIndicator(_controller));
  }
}

class VideoProgressLabelIndicator extends StatefulWidget {
  final VideoPlayerController controller;

  VideoProgressLabelIndicator(this.controller, {Key key});

  @override
  _VideoProgressLabelIndicator createState() => _VideoProgressLabelIndicator();
}

class _VideoProgressLabelIndicator extends State<VideoProgressLabelIndicator> {
  @override
  Widget build(BuildContext context) {
    Widget progressIndicator;

    progressIndicator = Stack(
      children: <Widget>[
        SizedBox(
            height: 45,
            child: VideoProgressIndicator(
              widget.controller,
              allowScrubbing: true,
              colors: VideoProgressColors(playedColor: Colors.green),
            )),
        _label()
      ],
    );

    return progressIndicator;
  }

  Widget _label() {
    return IgnorePointer(
        child: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(4),
      child: Text(
        widget.controller.value.position != null
            ? printDuration(widget.controller.value.position) +
                '/' +
                printDuration(widget.controller.value.duration)
            : "00:00/00:00",
        style: TextStyle(
          fontSize: 36,
          color: getColorFromHex("#E2E2E2"),
        ),
      ),
    ));
  }
}

enum LabelEvents { START_SCROLLING, UPDATE_POSITION, END_SCROLLING }
