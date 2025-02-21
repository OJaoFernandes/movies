class Collection {
  int? appId;
  int? id;
  String? name;
  String? posterPath;
  String? backdropPath;

  Collection({
    this.appId,
    this.id,
    this.name,
    this.posterPath,
    this.backdropPath,
  });

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
    appId: json['appId'],
    id: json['id'],
    name: json['name'],
    posterPath: json['poster_path'],
    backdropPath: json['backdrop_path'],
  );

  Map<String, dynamic> toJson() => {
    'appId': appId,
    'id': id,
    'name': name,
    'poster_path': posterPath,
    'backdrop_path': backdropPath,
  };
}
