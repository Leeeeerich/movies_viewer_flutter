import 'package:floor/floor.dart';
import 'package:movies_viewer_flutter/src/model/entities/entities.dart';

@dao
abstract class MoviePagesDao {
  @Query('SELECT * FROM MoviePages')
  Future<List<MovieItem>> getAllMoviePages();

  @insert
  Future<void> insertMoviePage(MovieItem movieItem);

  @update
  Future<void> updateMoviePage(MovieItem movieItem);

  @delete
  Future<void> deleteMoviePage(MovieItem movieItem);
}
