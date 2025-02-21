import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../core/database/db_services/movies_service.dart';
import '../models/movie.dart';

class MoviesRepository {
  final getIt = GetIt.instance;
  late final dio = getIt.get<Dio>();

  Future<List<Movie>> discover() async {
    try {
      final response = await dio.get('/discover/movie');
      final results = response.data['results'] as List;
      final movies = results.map((json) => Movie.fromJson(json)).toList();
      final favorites = await getIt.get<MoviesService>().findFavoriteIds();
      for (var movie in movies) {
        if (favorites.contains(movie.id)) {
          movie.favorite = true;
        }
      }
      return movies;
    } catch (e) {
      throw Exception('Failed to load movies: $e');
    }
  }

  Future<Movie> getMovie(int id) async {
    final response = await dio.get('/movie/$id');
    final data = response.data as Map<String, dynamic>;
    return Movie.fromJson(data);
  }

  Future<List<Movie>> search(String query) async {
    final response = await dio.get(
      '/search/movie',
      queryParameters: {'query': query},
    );
    final data = response.data['results'] as List;
    return data.map((json) => Movie.fromJson(json)).toList();
  }

  Future<List<Movie>> getFavorites() async {
    final moviesSevice = getIt.get<MoviesService>();
    return moviesSevice.findAll();
  }

  Future<List<int>> getFavoritesIds() async {
    final moviesSevice = getIt.get<MoviesService>();
    return moviesSevice.findFavoriteIds();
  }

  Future<List<Movie>> searchFavorites(String query) async {
    final moviesSevice = getIt.get<MoviesService>();
    return moviesSevice.findAll(name: query);
  }

  Future<Movie> addFavorite(Movie movie) async {
    final moviesSevice = getIt.get<MoviesService>();
    movie.favorite = true;
    return await moviesSevice.create(movie);
  }

  Future<Movie> removeFavorite(Movie movie) async {
    final moviesSevice = getIt.get<MoviesService>();
    movie.favorite = false;
    return await moviesSevice.delete(movie);
  }

  Future<List<Movie>> clearFavorites() async {
    final moviesSevice = getIt.get<MoviesService>();
    return await moviesSevice.deleteAll();
  }
}
