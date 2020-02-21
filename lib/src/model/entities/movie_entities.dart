class MovePageEntity {
  final String url;
  final String title;
  final String urlCover;

  MovePageEntity(this.url, this.title, this.urlCover);

  factory MovePageEntity.fromJson(Map<String, dynamic> json) =>
      MovePageEntity(json['url'], json['title'], json['urlCover']);

  Map<String, dynamic> toJson() =>
      {"url": url, "title": title, "urlCover": urlCover};
}
