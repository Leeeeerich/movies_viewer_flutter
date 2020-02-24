import 'dart:io';

import 'package:movies_viewer_flutter/src/model/entities/movie_entities.dart';
import 'package:movies_viewer_flutter/src/resources/database/app_database.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabaseImpl implements AppDatabase {
  AppDatabaseImpl._();

  static final AppDatabaseImpl db = AppDatabaseImpl._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDatabase();
    return _database;
  }

  static const MOVIE_PAGES = 'movie_pages';

  initDatabase() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String path = join(documentsDir.path, 'app.db');

    return await openDatabase(path, version: 1, onOpen: (db) async {},
        onCreate: (Database db, int version) async {
      await db.execute('''
                CREATE TABLE $MOVIE_PAGES(
                    url TEXT PRIMARY KEY,
                    title TEXT DEFAULT '',
                    urlCover TEXT DEFAULT ''
                )
            ''');
    });
  }

  @override
  Future<int> deleteMoviePage(MoviePageEntity moviePageEntity) async {
    final db = await database;
    var res = await db.delete(MOVIE_PAGES,
        where: 'url = ?', whereArgs: [moviePageEntity.url]);
    return res;
  }

  @override
  Future<MoviePageEntity> getMoviePage(String url) async {
    final db = await database;
    var res = await db.query(MOVIE_PAGES, where: 'url = ?', whereArgs: [url]);
    return res.isNotEmpty ? MoviePageEntity.fromJson(res.first) : null;
  }

  @override
  getMoviePageList(Function(List<MoviePageEntity>) callback) async {
    final db = await database;
    var res = await db.query(MOVIE_PAGES);
    callback(res.isNotEmpty
        ? res.map((data) => MoviePageEntity.fromJson(data)).toList()
        : []);
  }

  @override
  Future<int> insertMoviePage(MoviePageEntity moviePageEntity) async {
    final db = await database;
    var res = await db.insert(MOVIE_PAGES, moviePageEntity.toJson(),
        conflictAlgorithm: ConflictAlgorithm
            .replace); //TODO change conflict algorithm. It is on times developing
    return res;
  }

  @override
  Future<int> upgradeMoviePage(MoviePageEntity moviePageEntity) async {
    final db = await database;
    var res = await db.update(MOVIE_PAGES, moviePageEntity.toJson(),
        where: 'url = ?', whereArgs: [moviePageEntity.url]);
    return res;
  }

  @override
  closeDatabase() async {
    final db = await database;
    db.close();
  }
}
