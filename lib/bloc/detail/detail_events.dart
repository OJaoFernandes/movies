part of 'detail_bloc.dart';

@immutable
sealed class DetailEvent {}

class GetDetailEvent extends DetailEvent {
  final int movieId;
  GetDetailEvent(this.movieId);
}

class DetailSwitchFavoriteMovieEvent extends DetailEvent {
  final Movie movie;
  DetailSwitchFavoriteMovieEvent(this.movie);
}
