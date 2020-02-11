import 'package:flutter/material.dart';
import 'package:movies_viewer_flutter/src/model/season_dto.dart';
import 'package:movies_viewer_flutter/src/resources/repository/repository_impl.dart';

class SeasonsModel extends ChangeNotifier {
  RepositoryImpl _repository;
  List<SeasonDto> _seasonList = List<SeasonDto>();
  String _errorMessage = "";

  SeasonsModel(this._repository);

  List<SeasonDto> get seasonLists => _seasonList;

  String get errorMessage => _errorMessage;

  loadSeasons(String url) {
    _repository.getSeasons(url, (result, status) {
      _seasonList.clear();
      if (result != null && result.getAttachments().isNotEmpty) {
        print("pre add ${_seasonList.length}");
        print("pre add attachments ${result.getAttachments().length}");
        _seasonList.addAll(result.getAttachments());
      }
      _errorMessage = status.message ?? "";
      notifyListeners();
      print("Upper notify");
    });
  }

  @override
  void dispose() {
    _repository = null;
    super.dispose();
  }
}
