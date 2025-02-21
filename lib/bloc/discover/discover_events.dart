part of 'discover_bloc.dart';

@immutable
sealed class DiscoverEvent {}

class DiscoverLoadEvent extends DiscoverEvent {}

class DiscoverLoadMoreEvent extends DiscoverEvent {}

class DiscoverSwitchFavoriteMovieEvent extends DiscoverEvent {
  final Movie movie;
  DiscoverSwitchFavoriteMovieEvent(this.movie);
}
