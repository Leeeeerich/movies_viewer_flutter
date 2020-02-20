import 'package:floor/floor.dart';

@entity
class MovieItem {
  @primaryKey
  final String url;
  final String name;
  final String urlCover;

  MovieItem(this.url, this.name, this.urlCover);
}
