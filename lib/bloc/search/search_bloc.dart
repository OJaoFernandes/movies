import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../models/movie.dart';
import '../../repository/movies_repository.dart';

part 'search_events.dart';
part 'search_states.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MoviesRepository _moviesRepository =
      GetIt.instance.get<MoviesRepository>();

  SearchBloc() : super(SearchInitial()) {
    on<SearchLoadEvent>((event, emit) async {
      emit(SearchLoading());
      try {
        final movies = await _moviesRepository.search(event.query);
        final favoritesIds = await _moviesRepository.getFavoritesIds();
        for (var movie in movies) {
          movie.favorite = favoritesIds.contains(movie.id);
        }
        emit(SearchLoaded(movies));
      } catch (e, stackTrace) {
        emit(SearchError(e.toString()));
        debugPrint(stackTrace.toString());
      }
    });
    on<SearchClearEvent>((event, emit) async {
      emit(SearchInitial());
    });
    on<SearchSwitchFavoriteMovieEvent>((event, emit) async {
      final currentState = state;
      if (currentState is SearchLoaded) {
        final updatedMovies = [...currentState.movies];
        final index = updatedMovies.indexWhere((m) => m.id == event.movie.id);
        if (index != -1) {
          final movie = updatedMovies[index];
          final updatedMovie = event.movie..favorite = !movie.favorite!;
          if (updatedMovie.favorite!) {
            await _moviesRepository.addFavorite(updatedMovie);
          } else {
            await _moviesRepository.removeFavorite(updatedMovie);
          }
          updatedMovies[index] = updatedMovie;
          emit(SearchLoaded(updatedMovies));
        }
      }
    });
  }
}
