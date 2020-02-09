class SeasonsDto implements Attachments<SeasonDto> {
  List<SeasonDto> _attachments;

  SeasonsDto(this._attachments);

  factory SeasonsDto.fromJson(List<dynamic> parsedJson) {
    List<SeasonDto> list1 = new List<SeasonDto>();
    for (var i = 0; i < parsedJson.length; i++) {
      list1.add(SeasonDto.fromJson(parsedJson[i]));
    }

    return SeasonsDto(list1);
  }

  @override
  List<SeasonDto> getAttachments() {
    return _attachments;
  }

  set list(List<SeasonDto> _list) {
    this._attachments = _list;
  }

  @override
  String get name => null;
}

class SeasonDto implements Attachments<SeriesDto> {
  final String seasonName;
  List<SeriesDto> _attachments;

  SeasonDto(this.seasonName, this._attachments);

  factory SeasonDto.fromJson(Map<String, dynamic> json) {
    var series = List<SeriesDto>();
    json['folder']
        .forEach((element) => series.add(SeriesDto.fromJson(element)));

    return SeasonDto(json['comment'], series);
  }

  @override
  List<SeriesDto> getAttachments() {
    return _attachments;
  }

  @override
  set list(List<SeriesDto> _list) {
    this._attachments = _list;
  }

  @override
  // TODO: implement name
  String get name => seasonName;
}

class SeriesDto implements Attachments<QualityDto> {
  final String nameOfSeries;
  List<QualityDto> _attachments;

  SeriesDto(this.nameOfSeries, this._attachments);

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

  @override
  List<QualityDto> getAttachments() {
    return _attachments;
  }

  @override
  set list(List<QualityDto> _list) {
    this._attachments = _list;
  }

  @override
  // TODO: implement name
  String get name => nameOfSeries;
}

class QualityDto implements Attachments<String> {
  final String qualityName;
  List<String> _attachments;

  QualityDto(this.qualityName, this._attachments);

  @override
  set list(List<String> _list) {
    this._attachments = _list;
  }

  @override
  List<String> getAttachments() {
    return _attachments;
  }

  @override
  // TODO: implement name
  String get name => qualityName;
}

abstract class Attachments<T> {
  List<T> _attachments;

  String get name;

  List<T> getAttachments();
}
