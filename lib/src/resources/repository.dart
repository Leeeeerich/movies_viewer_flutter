import 'dart:convert';

import 'package:movies_viewer_flutter/src/models/season_dto.dart';
import 'package:movies_viewer_flutter/src/resources/status.dart';
import 'package:movies_viewer_flutter/src/resources/web_servicess.dart';
import 'package:movies_viewer_flutter/src/utils/decoders.dart';

class Repository {
  static final Repository _repository = Repository._internal();

  factory Repository() => _repository;

  Repository._internal();

  getSeasons(String url, Function(SeasonsDto, Status) callback) {
    print("Pre getPage");
    getPage(url).asStream().map((res) {
      print("Pageresponce ${res.statusCode}");
      SeasonsDto seasonsDto;
      if (res.statusCode == 200) {
        var utf = decodeCp1251(res.body);
        var pre =
            utf.substring(utf.indexOf("[{\"comment\":\"1 сезон\",\"folder\":"));

        var preData = pre.substring(0, pre.lastIndexOf("}]}]")) + "}]}]";
        var data = JsonDecoder().convert(preData);
        seasonsDto = SeasonsDto.fromJson(data);
      }
      callback(seasonsDto, Status(true, res.statusCode));
    });
  }
}
