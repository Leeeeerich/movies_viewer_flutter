import 'dart:async';

import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../dao/dao.dart';
import '../entities/entities.dart';

part 'movie_database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [MovieItem])
abstract class AppDatabase extends FloorDatabase {
  MoviePagesDao get moviePagesDao;
}
