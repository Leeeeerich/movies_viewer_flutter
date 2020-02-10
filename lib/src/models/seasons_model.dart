import 'package:flutter/material.dart';
import 'package:movies_viewer_flutter/src/models/season_dto.dart';
import 'package:movies_viewer_flutter/src/resources/repository/repository_impl.dart';

class SeasonsModel extends ChangeNotifier {
  RepositoryImpl _repository;
  List<SeasonDto> _seasonList = List<SeasonDto>();

  SeasonsModel(RepositoryImpl repository) {
    _repository = repository;
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
