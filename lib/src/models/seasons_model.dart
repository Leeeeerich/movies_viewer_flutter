import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:movies_viewer_flutter/src/blocs/bloc_base.dart';
import 'package:movies_viewer_flutter/src/models/season_dto.dart';
import 'package:movies_viewer_flutter/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class SeasonsModel extends ChangeNotifier with BlocBase {
  Repository _repository;
  final _seasonFetcher = PublishSubject<SeasonsDto>();
  SeasonsDto _seasonsDto;

  SeasonsModel(Repository repository) {
    _repository = repository;
    loadSeasons(
        "https://kinogo.by/13106-food-wars-shokugeki-no-soma_1-4-sezon.html");

    _seasonFetcher.listen((onData) {
      _seasonsDto = onData;
    });
  }

  Stream get seasonList => _seasonFetcher.stream;

  UnmodifiableListView<SeasonDto> get seasonsDto => _seasonsDto.list;

//  setSeasonsDto(SeasonsDto seasonsDto) {
////    _seasonsDto = seasonsDto;
//    notifyListeners();
//  }

  loadSeasons(String url) {
    _seasonFetcher.addStream(_repository.getSeasons(url));
    notifyListeners();
  }

  @override
  void dispose() {
    _seasonFetcher.close();
    super.dispose();
  }
}
