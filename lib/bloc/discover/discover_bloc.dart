import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../models/movie.dart';
import '../../repository/movies_repository.dart';

part 'discover_events.dart';
part 'discover_states.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final MoviesRepository _moviesRepository =
      GetIt.instance.get<MoviesRepository>();

  DiscoverBloc() : super(DiscoverInitial()) {
    on<DiscoverLoadEvent>((event, emit) async {
      emit(DiscoverLoading());
      try {
        final movies = await _moviesRepository.discover();
        final favoritesIds = await _moviesRepository.getFavoritesIds();
        for (var movie in movies) {
          movie.favorite = favoritesIds.contains(movie.id);
        }
        emit(DiscoverLoaded(movies));
      } catch (e, stackTrace) {
        emit(DiscoverError(e.toString()));
        debugPrint(stackTrace.toString());
      }
    });

    on<DiscoverLoadMoreEvent>((event, emit) async {
      emit(DiscoverLoading());
      try {
        final movies = await _moviesRepository.discover();
        emit(DiscoverLoaded(movies));
      } catch (e, stackTrace) {
        emit(DiscoverError(e.toString()));
        debugPrint(stackTrace.toString());
      }
    });

    on<DiscoverSwitchFavoriteMovieEvent>((event, emit) async {
      try {
        final currentState = state;
        if (currentState is DiscoverLoaded) {
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
            emit(DiscoverLoaded(updatedMovies));
          }
        }
      } catch (e, stackTrace) {
        emit(DiscoverError(e.toString()));
        debugPrint(stackTrace.toString());
      }
    });
  }
}
