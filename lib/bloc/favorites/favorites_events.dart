part of 'favorites_bloc.dart';

@immutable
sealed class FavoritesEvent {}

class GetFavoritesEvent extends FavoritesEvent {}

class RemoveFavoriteEvent extends FavoritesEvent {
  final Movie movie;
  RemoveFavoriteEvent({required this.movie});
}

class ClearFavoritesEvent extends FavoritesEvent {}