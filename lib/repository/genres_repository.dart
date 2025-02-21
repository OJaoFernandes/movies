import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../models/genre.dart';

class GenresRepository {
  final dio = GetIt.I.get<Dio>();

  Future<List<Genre>> findMovieGenres() async { 
    final data = await dio.get('genres/movie/list') as List<Map<String, dynamic>>;
    return data.map((genre) => Genre.fromJson(genre)).toList();
  }

  Future<List<Genre>> findTvGenres() async { 
    final data = await dio.get('genres/tv/list') as List<Map<String, dynamic>>;
    return data.map((genre) => Genre.fromJson(genre)).toList();
  }
}