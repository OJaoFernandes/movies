part of 'discover_bloc.dart';

@immutable
sealed class DiscoverState {}

class DiscoverInitial extends DiscoverState {}

class DiscoverLoading extends DiscoverState {}

class DiscoverLoaded extends DiscoverState {
  final List<Movie> movies;
  DiscoverLoaded(this.movies);
}

class DiscoverError extends DiscoverState {
  final String message;
  DiscoverError(this.message);
}