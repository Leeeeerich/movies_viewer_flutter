import 'package:movies_viewer_flutter/src/model/entities/movie_entities.dart';
import 'package:movies_viewer_flutter/src/model/season_dto.dart';
import 'package:movies_viewer_flutter/src/resources/status.dart';

abstract class Repository {
  getSeasons(String url, Function(Attachments, Status) callback);

  getMoviePageList(Function(List<MoviePageEntity>) callback);

  getMoviePage(String url);
}
