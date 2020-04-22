import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies_viewer_flutter/src/model/entities/movie_entities.dart';
import 'package:movies_viewer_flutter/src/resources/repository/repository.dart';

class HomeModel extends ChangeNotifier {
  final Repository _repository;

  //Event Channel creation
  static const stream = const EventChannel('https.kinogo.by/events');

  //Method channel creation
  static const platform = const MethodChannel('https.kinogo.by/channel');

  List<MoviePageEntity> _moviePageList = List<MoviePageEntity>();

  List<MoviePageEntity> get moviePageList => _moviePageList;

  String _uri = "";

  String get uri => _uri;

  HomeModel(this._repository) {
    //Checking application start by deep link
    startUri().then(_onRedirected);
    //Checking broadcast stream, if deep link was clicked in opened appication
    stream.receiveBroadcastStream().listen((d) => _onRedirected(d));
  }

  loadMoviePageList() {
    _repository.getMoviePageList((res) {
      _moviePageList.clear();
      _moviePageList.addAll(res);
      notifyListeners();
    });
  }

  Future<String> startUri() async {
    try {
      return platform.invokeMethod('initialLink');
    } on PlatformException catch (e) {
      return "Failed to Invoke: '${e.message}'.";
    }
  }

  _onRedirected(String uri) {
    // Here can be any uri analysis, checking tokens etc, if it’s necessary
    // Throw deep link URI into the BloC's stream
    _uri = uri;
    print("onRedirect, URI = $_uri");
  }
}
