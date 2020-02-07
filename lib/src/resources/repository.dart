import 'dart:convert';

import 'package:movies_viewer_flutter/src/models/season_dto.dart';
import 'package:movies_viewer_flutter/src/resources/web_servicess.dart';
import 'package:movies_viewer_flutter/src/utils/decoders.dart';

class Repository {
  static final Repository _repository = Repository._internal();

  factory Repository() => _repository;

  Repository._internal();

  Stream<SeasonDto> getSeasons(String url) {
    return getPage(url).asStream().map((res) {
      if (res.statusCode == 200) {
        var utf = decodeCp1251(res.body);
        var pre =
            utf.substring(utf.indexOf("[{\"comment\":\"1 сезон\",\"folder\":"));

        var preData = pre.substring(0, pre.lastIndexOf("}]}]")) + "}]}]";
//        print(preData);

        var data1 = JsonEncoder().convert([
          {"comment": "vasya1", "folder": null},
          {"comment": "vasya2", "folder": null}
        ]);
        var data = JsonDecoder().convert(data1);
        print(data);
        var seasons = SeasonsDto.fromJson(data);
        print(seasons.list);
        return null;
      }
      return null;
    });
  }
}
