import 'collection.dart';
import 'company.dart';
import 'genre.dart';

class Movie {
  int? appId;
  int? id;
  bool? adult;
  Collection? collection;
  String? backdropPath;
  int? budget;
  List<Genre>? genres;
  String? homepage;
  String? imdbId;
  List<String>? originCountry;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  double? popularity;
  String? posterPath;
  List<Company>? productionCompanies;
  List<Map<String, dynamic>>? productionCountries;
  DateTime? releaseDate;
  int? revenue;
  int? runtime;
  List<Map<String, dynamic>>? spokenLanguages;
  String? status;
  String? tagline;
  String? title;
  bool? video;
  double? voteAverage;
  int? voteCount;
  bool? favorite = false;

  Movie({
    this.appId,
    this.id,
    this.adult,
    this.backdropPath,
    this.collection,
    this.budget,
    this.genres,
    this.homepage,
    this.imdbId,
    this.originCountry,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.productionCompanies,
    this.productionCountries,
    this.releaseDate,
    this.revenue,
    this.runtime,
    this.spokenLanguages,
    this.status,
    this.tagline,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
    this.favorite,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    appId: json['appId'] as int?,
    id: json['id'] as int?,
    adult: (json['adult'] as bool?) ?? false,
    backdropPath: json['backdrop_path'] as String?,
    collection:
        (json['belongs_to_collection'] != null)
            ? Collection.fromJson(json['belongs_to_collection'])
            : null,
    budget: json['budget'] as int?,
    genres: _parseGenres(json),
    homepage: json['homepage'] as String?,
    imdbId: json['imdb_id'] as String?,
    originCountry:
        (json['origin_country'] as List?)
            ?.map((country) => country.toString())
            .toList(),
    originalLanguage: json['original_language'] as String?,
    originalTitle: json['original_title'] as String?,
    overview: json['overview'] as String?,
    popularity: (json['popularity'] as num?)?.toDouble(),
    posterPath: json['poster_path'] as String?,
    productionCompanies:
        (json['production_companies'] is List)
            ? (json['production_companies'] as List<dynamic>)
                .map((pc) => Company.fromJson(pc))
                .toList()
            : [],
    productionCountries:
        (json['production_countries'] as List?)?.cast<Map<String, dynamic>>(),
    releaseDate: _parseReleaseDate(json['release_date'] as String?),
    revenue: json['revenue'] as int?,
    runtime: json['runtime'] as int?,
    spokenLanguages:
        (json['spoken_languages'] as List?)?.cast<Map<String, dynamic>>(),
    status: json['status'] as String?,
    tagline: json['tagline'] as String?,
    title: json['title'] as String?,
    video: json['video'] as bool?,
    voteAverage: (json['vote_average'] as num?)?.toDouble(),
    voteCount: json['vote_count'] as int?,
    favorite: json['favorite'] as bool? ?? false,
  );

  static List<Genre> _parseGenres(Map<String, dynamic> json) {
    if (json['genres'] != null && json['genres'] is List) {
      final genres = json['genres'] as List;
      return genres.map((json) => Genre.fromJson(json)).toList();
    } else if (json['genre_ids'] != null && json['genre_ids'] is List) {
      final ids = (json['genre_ids'] as List).cast<int>();
      return ids.map((id) => Genre(id: id)).toList();
    }
    return [];
  }

  static DateTime? _parseReleaseDate(String? rawDate) {
    if (rawDate != null && rawDate.isNotEmpty) {
      return DateTime.tryParse(rawDate);
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
    'appId': appId,
    'id': id,
    'adult': adult,
    'backdrop_path': backdropPath,
    'belongs_to_collection': collection?.toJson(),
    'budget': budget,
    'genres': genres?.map((genre) => genre.toJson()).toList(),
    'homepage': homepage,
    'imdb_id': imdbId,
    'origin_country': originCountry,
    'original_language': originalLanguage,
    'original_title': originalTitle,
    'overview': overview,
    'popularity': popularity,
    'poster_path': posterPath,
    'production_companies':
        productionCompanies?.map((company) => company.toJson()).toList(),
    'production_countries': productionCountries,
    'release_date': releaseDate?.toIso8601String(),
    'revenue': revenue,
    'runtime': runtime,
    'spoken_languages': spokenLanguages,
    'status': status,
    'tagline': tagline,
    'title': title,
    'video': video,
    'vote_average': voteAverage,
    'vote_count': voteCount,
    'favorite': favorite,
  };
}
