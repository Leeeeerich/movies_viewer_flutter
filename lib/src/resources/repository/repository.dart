import 'package:movies_viewer_flutter/src/models/season_dto.dart';
import 'package:movies_viewer_flutter/src/resources/status.dart';

abstract class Repository {
  getSeasons(String url, Function(SeasonsDto, Status) callback);
}
