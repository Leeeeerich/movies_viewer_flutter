import 'package:flutter/material.dart';
import 'package:movies_viewer_flutter/src/models/season_dto.dart';
import 'package:movies_viewer_flutter/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class SeasonsModel extends ChangeNotifier {
  Repository _repository;
  final _seasonFetcher = PublishSubject<SeasonsDto>();
  List<SeasonDto> _seasonList = List<SeasonDto>();

  SeasonsModel(Repository repository) {
    _repository = repository;
    loadSeasons(
        "https://kinogo.by/13106-food-wars-shokugeki-no-soma_1-4-sezon.html");

    _seasonFetcher.listen((onData) {
      _seasonList = onData.getAttachments();
      notifyListeners();
    });
  }

//  Stream get seasonList => _seasonFetcher.stream;

  List<SeasonDto> get seasonLists => _seasonList;

  loadSeasons(String url) {
    _seasonFetcher.addStream(_repository.getSeasons(url));
  }

  @override
  void dispose() {
    _seasonFetcher.close();
    super.dispose();
  }
}
