import 'dart:convert';

import 'package:movies_viewer_flutter/src/models/season_dto.dart';
import 'package:movies_viewer_flutter/src/resources/web_servicess.dart';
import 'package:movies_viewer_flutter/src/utils/decoders.dart';

class Repository {
  static final Repository _repository = Repository._internal();

  factory Repository() => _repository;

  Repository._internal();

  Stream<SeasonsDto> getSeasons(String url) {
    return getPage(url).asStream().map((res) {
      if (res.statusCode == 200) {
        var utf = decodeCp1251(res.body);
        var pre =
            utf.substring(utf.indexOf("[{\"comment\":\"1 сезон\",\"folder\":"));

        var preData = pre.substring(0, pre.lastIndexOf("}]}]")) + "}]}]";
        var data = JsonDecoder().convert(preData);
        var seasons = SeasonsDto.fromJson(data);
        print(seasons.list[0].listSeries[0].movies[0].qualityName);
        return seasons;
      }
      return null;
    });
  }
}
