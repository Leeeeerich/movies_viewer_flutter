import 'dart:convert';

import 'package:movies_viewer_flutter/src/model/season_dto.dart';
import 'package:movies_viewer_flutter/src/resources/repository/repository.dart';
import 'package:movies_viewer_flutter/src/resources/status.dart';
import 'package:movies_viewer_flutter/src/resources/web_services/web_services.dart';
import 'package:movies_viewer_flutter/src/resources/web_services/web_services_impl.dart';
import 'package:movies_viewer_flutter/src/utils/decoders.dart';

class RepositoryImpl implements Repository {
  RepositoryImpl._internal();

  static final RepositoryImpl _repository = RepositoryImpl._internal();

  factory RepositoryImpl() => _repository;

  final WebServices _webServices =
      WebServicesImpl(); //TODO need injection from outside

  @override
  getSeasons(String url, Function(Attachments, Status) callback) {
    print("Pre getPage");
    _webServices.getPage(url).then((res) {
      print("Pageresponce ${res.statusCode}");
      SeasonsDto seasonsDto;
      String message;
      if (res.statusCode == 200) {
        var utf = decodeCp1251(res.body);
        var startMovies = utf.indexOf("[{\"comment\":\"1 сезон\",\"folder\":");

        if (startMovies == -1) {
          message = 'Bad link';
        } else {
          var pre = utf.substring(startMovies);
          var preData = pre.substring(0, pre.lastIndexOf("}]}]")) + "}]}]";
          var data = JsonDecoder().convert(preData);
          seasonsDto = SeasonsDto.fromJson(data);
        }
      }
      callback(seasonsDto,
          Status(res.statusCode == 200, res.statusCode, message: message));
    });
  }
}
