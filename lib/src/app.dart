import 'package:flutter/material.dart';
import 'package:movies_viewer_flutter/src/ui/home/home.dart';
import 'package:movies_viewer_flutter/src/ui/video_player/video_player.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VideoPlayerScreen(),//MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}