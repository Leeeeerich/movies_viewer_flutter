import 'dart:convert';

import 'package:movies_viewer_flutter/src/model/season_dto.dart';
import 'package:movies_viewer_flutter/src/resources/repository/repository.dart';
import 'package:movies_viewer_flutter/src/resources/status.dart';
import 'package:movies_viewer_flutter/src/resources/web_services/web_services.dart';
import 'package:movies_viewer_flutter/src/utils/decoders.dart';
import 'package:sqflite/sqflite.dart';

class RepositoryImpl implements Repository {
  Database _database;
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

      if (movies != null) {}

      callback(movies,
          Status(res.statusCode == 200, res.statusCode, message: message));
    });
  }
}
