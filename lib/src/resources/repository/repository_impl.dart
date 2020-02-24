import 'dart:convert';

import 'package:movies_viewer_flutter/src/model/entities/movie_entities.dart';
import 'package:movies_viewer_flutter/src/model/season_dto.dart';
import 'package:movies_viewer_flutter/src/resources/database/app_database.dart';
import 'package:movies_viewer_flutter/src/resources/repository/repository.dart';
import 'package:movies_viewer_flutter/src/resources/status.dart';
import 'package:movies_viewer_flutter/src/resources/web_services/web_services.dart';
import 'package:movies_viewer_flutter/src/utils/decoders.dart';

class RepositoryImpl implements Repository {
  AppDatabase _database;
  WebServices _webServices;

  RepositoryImpl(this._database, this._webServices);

  @override
  getSeasons(String url, Function(Attachments, Status) callback) {
    print("Pre getPage");
    _webServices.getPage(url).then((res) {
      print("Pageresponce ${res.statusCode}");
      Attachments movies;
      String message;
      if (res.statusCode == 200) {
        var utf = decodeCp1251(res.body);
        var startMovies = utf.indexOf("[{\"comment\":\"1 сезон\",\"folder\":");

        if (startMovies == -1) {
          var startSeason = utf.indexOf("[{\"title\":");
          if (startSeason == -1) {
            var startQualities = utf.indexOf("\"[360p]https:");
            if (startQualities == -1) {
              message = 'Bad link';
            } else {
              var pre = utf.substring(startQualities);
              var preData = "[{\"title\":\"Movie\",\"file\":" +
                  pre.substring(0, pre.indexOf(";")) +
                  "}]";
              var data = JsonDecoder().convert(preData);
              movies = SeasonDto.fromListJson(data);
            }
          } else {
            var pre = utf.substring(startSeason);
            var preData = pre.substring(0, pre.lastIndexOf("}]")) + "}]";
            var data = JsonDecoder().convert(preData);
            movies = SeasonDto.fromListJson(data);
          }
        } else {
          var pre = utf.substring(startMovies);
          var preData = pre.substring(0, pre.lastIndexOf("}]}]")) + "}]}]";
          var data = JsonDecoder().convert(preData);
          movies = SeasonsDto.fromJson(data);
        }
      }

      if (movies != null) {
        _database.insertMoviePage(MoviePageEntity(url, "First cinema",
            "https://kinogo.by/uploads/cache/8/1/0/f/e/7/e/5/0/1568099570_98483352ce6c1ebdb3ad5b8982db06fc-200x300.jpg"));
      }

      callback(movies,
          Status(res.statusCode == 200, res.statusCode, message: message));
    });
  }

  @override
  getMoviePageList(Function(List<MoviePageEntity>) callback) async {
    _database.getMoviePageList((res) => callback(res));
  }

  @override
  getMoviePage(String url) async {
    var res = await _database.getMoviePage(url);
    return res;
  }
}
