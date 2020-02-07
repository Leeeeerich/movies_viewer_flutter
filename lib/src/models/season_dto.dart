class SeasonsDto {
  final List<SeasonDto> list;

  SeasonsDto({this.list});

  factory SeasonsDto.fromJson(List<dynamic> parsedJson) {
    List<SeasonDto> list1 = new List<SeasonDto>();
    for (var i = 0; i < parsedJson.length; i++) {
      list1.add(SeasonDto.fromJson(parsedJson[i]));
    }

    return SeasonsDto(
      list: list1,
    );
  }
}

class SeasonDto {
  final String seasonName;
  final List<SeriesDto> listSeries;

  SeasonDto(this.seasonName, this.listSeries);

  factory SeasonDto.fromJson(Map<String, dynamic> json) {
    var series = List<SeriesDto>();
    json['folder']
        .forEach((element) => series.add(SeriesDto.fromJson(element)));

    return SeasonDto(json['comment'], series);
  }
}

class SeriesDto {
  final String nameOfSeries;
  final List<QualityDto> movies;

  SeriesDto(this.nameOfSeries, this.movies);

  factory SeriesDto.fromJson(Map<String, dynamic> json) {
    var qualities = List<QualityDto>();

    json['file'].split(",").forEach((element) {
      var movieUrls = List<String>();
      var endQuality = element.indexOf("]") + 1;
      var qualityName = element.substring(element.indexOf("["), endQuality);
      element
          .substring(endQuality)
          .split(" or ")
          .forEach((url) => movieUrls.add(url));
      qualities.add(QualityDto(qualityName, movieUrls));
    });
    return SeriesDto(json['comment'], qualities);
  }
}

class QualityDto {
  final String qualityName;
  final List<String> listMovie;

  QualityDto(this.qualityName, this.listMovie);
}
