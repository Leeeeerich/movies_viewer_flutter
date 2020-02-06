class SeasonsDto {
  final List list;

  SeasonsDto(this.list);

  SeasonsDto.fromJson(dynamic json) : list = json;
}

class SeasonDto {
  final String seasonName;
  final List listSeries;

  SeasonDto(this.seasonName, this.listSeries);

  SeasonDto.fromJson(Map<String, dynamic> json)
      : seasonName = json['comment'],
        listSeries = json['folder'];

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
