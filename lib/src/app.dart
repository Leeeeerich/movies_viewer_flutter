import 'package:flutter/material.dart';
import 'package:movies_viewer_flutter/src/ui/home/home.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Movies Viewer'),
    );
  }
}
