import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../models/movie.dart';
import '../../repository/movies_repository.dart';

part 'favorites_events.dart';
part 'favorites_states.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final MoviesRepository _moviesRepository = GetIt.instance.get<MoviesRepository>();

  FavoritesBloc() : super(FavoritesInitial()) {
    on<GetFavoritesEvent>((event, emit) async {
      emit(FavoritesLoading());
      try {
      final movies = await _moviesRepository.getFavorites();
      emit(FavoritesLoaded(movies));        
      } catch (e, stackTrace) {
        emit(FavoritesError(e.toString()));
        debugPrint(stackTrace.toString());
      }
    });
    on<RemoveFavoriteEvent>((event, emit) async {
      try {
        await _moviesRepository.removeFavorite(event.movie);
        add(GetFavoritesEvent());
      } catch (e, stackTrace) {
        emit(FavoritesError(e.toString()));
        debugPrint(stackTrace.toString());
      }
    });
    on<ClearFavoritesEvent>((event, emit) async {
      try {
        await _moviesRepository.clearFavorites();
        add(GetFavoritesEvent());
      } catch (e, stackTrace) {
        emit(FavoritesError(e.toString()));
        debugPrint(stackTrace.toString());
      }
    });
  }
  
}
