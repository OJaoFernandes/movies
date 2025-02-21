class Genre {
  int? appId;
  int? id;
  String? name;

  Genre({this.appId, this.id, this.name});

  factory Genre.fromJson(Map<String, dynamic> json) =>
      Genre(appId: json['appId'], id: json['id'], name: json['name']);

  Map<String, dynamic> toJson() => {'appId': appId, 'id': id, 'name': name};
}
