import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/favorites/favorites_bloc.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final baseImageUrl = 'https://image.tmdb.org/t/p/w500';

  @override
  void initState() {
    super.initState();
    context.read<FavoritesBloc>().add(GetFavoritesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        if (state is FavoritesLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is FavoritesLoaded) {
          if (state.favorites.isEmpty) {
            return const Center(
              child: Text(
                'Seus favoritos ainda não estão aqui, vamos adicionar!',
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final movie = state.favorites[index];
                final heroTag =
                    movie.tagline?.isNotEmpty == true
                        ? 'tagline-${movie.id}-${movie.tagline}'
                        : 'poster-${movie.id}';
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Hero(
                    tag: heroTag,
                    child: Card(
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: '$baseImageUrl${movie.posterPath}',
                            fit: BoxFit.cover,
                            placeholder:
                                (_, __) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                            errorWidget: (_, __, ___) => const Icon(Icons.error),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              color: Colors.black87,
                              padding: const EdgeInsets.only(left: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      movie.title!,
                                      style: const TextStyle(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    isSelected: movie.favorite == true,
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (context) => AlertDialog(
                                              title: Text(
                                                'Tem certeza que deseja remover ${movie.title} dos favoritos?',
                                              ),
                                              content: const Text(
                                                'Após remover, para adicionar novamente voce precisará pesquisar o filme novamente na tela de busca.',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () =>
                                                          Navigator.pop(context),
                                                  child: const Text('Cancelar'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    context
                                                        .read<FavoritesBloc>()
                                                        .add(
                                                          RemoveFavoriteEvent(
                                                            movie: movie,
                                                          ),
                                                        );
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Remover'),
                                                ),
                                              ],
                                            ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        if (state is FavoritesError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
