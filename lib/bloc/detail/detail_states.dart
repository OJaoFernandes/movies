part of 'detail_bloc.dart';

@immutable
sealed class DetailState {}

class DetailInitial extends DetailState {}

class DetailLoading extends DetailState {}

class DetailLoaded extends DetailState {
  final Movie movie;
  DetailLoaded(this.movie);
}

class DetailError extends DetailState {
  final String message;
  DetailError(this.message);
}