import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/detail/detail_bloc.dart';
import '../../models/movie.dart';

class MovieHero extends StatelessWidget {
  final Movie movie;
  final void Function() onFavoriteSwitch;
  const MovieHero({
    super.key,
    required this.movie,
    required this.onFavoriteSwitch,
  });

  final baseImageUrl = 'https://image.tmdb.org/t/p/w500';

  @override
  Widget build(BuildContext context) {
    final tag =
        movie.tagline?.isNotEmpty == true
            ? 'tagline-${movie.id}-${movie.tagline}'
            : 'poster-${movie.id}';
    final posterUrl =
        (movie.posterPath?.isNotEmpty == true)
            ? '$baseImageUrl${movie.posterPath}'
            : 'https://via.placeholder.com/500';
    return GestureDetector(
      onTap: () async {
        context.read<DetailBloc>().add(GetDetailEvent(movie.id!));
        Navigator.pushNamed(context, '/movie', arguments: movie);
      },
      child: Hero(
        tag: tag,
        child: Card(
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: posterUrl,
                fit: BoxFit.cover,
                placeholder:
                    (_, __) => const Center(child: CircularProgressIndicator()),
                errorWidget:
                    (_, __, ___) => const Center(child: Icon(Icons.error)),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black87,
                  padding: const EdgeInsets.only(left: 8.0),
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
                        icon: const Icon(Icons.star, color: Colors.grey),
                        selectedIcon: const Icon(
                          Icons.star,
                          color: Colors.orangeAccent,
                        ),
                        onPressed: onFavoriteSwitch,
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
  }
}
