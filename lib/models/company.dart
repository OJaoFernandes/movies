class Company {
  int? appId;
  int? id;
  String? logoPath;
  String? name;
  String? originCountry;

  Company({this.appId, this.id, this.logoPath, this.name, this.originCountry});

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    appId: json['appId'],
    id: json['id'],
    logoPath: json['logo_path'],
    name: json['name'],
    originCountry: json['origin_country'],
  );

  Map<String, dynamic> toJson() => {
    'appId': appId,
    'id': id,
    'logo_path': logoPath,
    'name': name,
    'origin_country': originCountry,
  };
}
