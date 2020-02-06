import 'package:movies_viewer_flutter/src/models/season_dto.dart';
import 'package:movies_viewer_flutter/src/resources/web_servicess.dart';

class Repository {
  static final Repository _repository = Repository._internal();

  factory Repository() => _repository;

  Repository._internal();

  SeasonsDto getSeasons(String url) {
    getPage(url).asStream();
  }
}
