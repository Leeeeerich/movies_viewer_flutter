import 'package:flutter/material.dart';
import 'package:movies_viewer_flutter/src/models/season_dto.dart';
import 'package:movies_viewer_flutter/src/resources/repository.dart';

class SeasonsModel extends ChangeNotifier {
  Repository _repository;
  List<SeasonDto> _seasonList = List<SeasonDto>();

  SeasonsModel(Repository repository) {
    _repository = repository;
//    loadSeasons(
//        "https://kinogo.by/13106-food-wars-shokugeki-no-soma_1-4-sezon.html");
  }

  List<SeasonDto> get seasonLists => _seasonList;

  loadSeasons(String url) {
    _repository.getSeasons(url, (result, status) {
      _seasonList.clear();
      _seasonList.addAll(result.getAttachments());
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _repository = null;
    super.dispose();
  }
}
