import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:movies_viewer_flutter/src/models/season_dto.dart';

class SeasonsModel extends ChangeNotifier {
  SeasonsDto _seasonsDto;

  UnmodifiableListView<SeasonDto> get getSeasonsDto => _seasonsDto.list;

  set setSeasonsDto(SeasonsDto seasonsDto) {
    _seasonsDto = seasonsDto;
    notifyListeners();
  }
}
