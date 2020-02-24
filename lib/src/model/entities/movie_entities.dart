class MoviePageEntity {
  final String url;
  final String title;
  final String urlCover;

  MoviePageEntity(this.url, this.title, this.urlCover);

  factory MoviePageEntity.fromJson(Map<String, dynamic> json) =>
      MoviePageEntity(json['url'], json['title'], json['urlCover']);

  Map<String, dynamic> toJson() =>
      {"url": url, "title": title, "urlCover": urlCover};
}
