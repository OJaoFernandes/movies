part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}

class SearchLoadEvent extends SearchEvent {
  final String query;

  SearchLoadEvent(this.query);
}

class SearchClearEvent extends SearchEvent {}

class SearchSwitchFavoriteMovieEvent extends SearchEvent {
  final Movie movie;
  SearchSwitchFavoriteMovieEvent(this.movie);
}