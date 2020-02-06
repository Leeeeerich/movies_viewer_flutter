import 'package:movies_viewer_flutter/src/blocs/bloc_base.dart';
import 'package:movies_viewer_flutter/src/models/season_dto.dart';
import 'package:movies_viewer_flutter/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class BlocSeasons extends BlocBase {
  final _repository = Repository();
  final _seasonFetcher = PublishSubject<SeasonsDto>();

  get resultOfAuth => _seasonFetcher
      .stream; //TODO no detected returning type: Observables<SeasonsDto>

  getSeasons(String url) async {
    SeasonsDto seasonsDto = await Future.value(_repository.getSeasons(url));
    _seasonFetcher.sink.add(seasonsDto);
  }

  @override
  void dispose() {
    _seasonFetcher.close();
  }
}
