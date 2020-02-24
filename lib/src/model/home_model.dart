import 'package:flutter/material.dart';
import 'package:movies_viewer_flutter/src/model/entities/movie_entities.dart';
import 'package:movies_viewer_flutter/src/resources/repository/repository.dart';

class HomeModel extends ChangeNotifier {
  final Repository _repository;
  List<MoviePageEntity> _moviePageList = List<MoviePageEntity>();

  HomeModel(this._repository);

  List<MoviePageEntity> get moviePageList => _moviePageList;

  loadMoviePageList() {
    _repository.getMoviePageList((res) {
      print("DB responce = ${res.toString()}");
      _moviePageList.addAll(res);
      notifyListeners();
    });
  }
}
