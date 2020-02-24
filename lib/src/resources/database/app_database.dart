import 'package:movies_viewer_flutter/src/model/entities/movie_entities.dart';

abstract class AppDatabase {
  initDatabase();

  Future<int> insertMoviePage(MoviePageEntity moviePageEntity);

  Future<int> upgradeMoviePage(MoviePageEntity moviePageEntity);

  Future<int> deleteMoviePage(MoviePageEntity moviePageEntity);

  Future<MoviePageEntity> getMoviePage(String url);

  getMoviePageList(Function(List<MoviePageEntity>) callback);

  closeDatabase();
}
