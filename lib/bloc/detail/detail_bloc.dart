import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../models/movie.dart';
import '../../repository/movies_repository.dart';

part 'detail_events.dart';
part 'detail_states.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final MoviesRepository moviesRepository =
      GetIt.instance.get<MoviesRepository>();

  DetailBloc() : super(DetailInitial()) {
    on<GetDetailEvent>((event, emit) async {
      emit(DetailLoading());
      try {
        final movie = await moviesRepository.getMovie(event.movieId);
        emit(DetailLoaded(movie));
      } catch (e, stackTrace) {
        emit(DetailError(e.toString()));
        debugPrint(stackTrace.toString());
      }
    });

    on<DetailSwitchFavoriteMovieEvent>((event, emit) async {
      try {
        final currentState = state;
        if (currentState is DetailLoaded) {
          final loadedMovie = currentState.movie;
          loadedMovie.favorite = !loadedMovie.favorite!;
          if (loadedMovie.favorite!) {
            await moviesRepository.addFavorite(event.movie);
          } else {
            await moviesRepository.removeFavorite(event.movie);
          }
          emit(DetailLoaded(loadedMovie));
        }
      } catch (e, stackTrace) {
        emit(DetailError(e.toString()));
        debugPrint(stackTrace.toString());
      }
    });
  }
}
