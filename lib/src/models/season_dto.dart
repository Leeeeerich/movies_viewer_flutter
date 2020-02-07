class SeasonsDto {
  final List<SeasonDto> list;

  SeasonsDto({this.list});

  factory SeasonsDto.fromJson(List<dynamic> parsedJson) {
    List<SeasonDto> list1 = new List<SeasonDto>();
    for (var i = parsedJson.length; i > 0; i--) {
      list1.add(parsedJson[i].cast<SeasonDto>());
    }

    return new SeasonsDto(
      list: list1,
    );
  }
}

class SeasonDto {
  final String seasonName;
  final List listSeries;

  SeasonDto(this.seasonName, this.listSeries);

  factory SeasonDto.fromJson(Map<String, dynamic> json) {
    return SeasonDto(json['comment'], json['folder']);

//    seasonName = json['comment']
//    ,
//    listSeries = json['folder'];
  }

  Map<String, dynamic> toJson() => {
        'comment': seasonName,
        'folder': listSeries,
      };
}

class SeriesDto {
  final String nameOfSeries;
  final String movies;

  SeriesDto(this.nameOfSeries, this.movies);

  SeriesDto.fromJson(Map<String, dynamic> json)
      : nameOfSeries = json['comment'],
        movies = json['file'];

  Map<String, dynamic> toJson() => {
        'comment': nameOfSeries,
        'file': movies,
      };
}

class Obj {
  final String comment;
  final String folder;

  Obj({this.comment, this.folder});

  factory Obj.fromJson(Map<String, dynamic> json) {
    return new Obj(
      comment: json['comment'].toString(),
      folder: json['folder'],
    );
  }
}

class ObjList {
  final List<Obj> objs;

  ObjList({
    this.objs,
  });

  factory ObjList.fromJson(List<dynamic> parsedJson) {
    List<Obj> obj = new List<Obj>();

    return new ObjList(
      objs: obj,
    );
  }
}
