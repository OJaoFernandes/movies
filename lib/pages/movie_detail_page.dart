import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/detail/detail_bloc.dart';
import '../models/movie.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({super.key});

  final baseImageUrl = 'https://image.tmdb.org/t/p/w500';

  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)!.settings.arguments as Movie;
    final tag =
        movie.tagline?.isNotEmpty == true
            ? 'tagline-${movie.id}-${movie.tagline}'
            : 'poster-${movie.id}';
    final imageUrl =
        (movie.posterPath?.isNotEmpty == true)
            ? '$baseImageUrl${movie.backdropPath}'
            : 'https://via.placeholder.com/500';

    final currencyFormatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: 'U\$',
      decimalDigits: 2,
    );
    return Scaffold(
      appBar: AppBar(title: Text(movie.title ?? 'Detalhes')),
      body: SingleChildScrollView(
        child: BlocBuilder<DetailBloc, DetailState>(
          builder: (context, state) {
            if (state is DetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is DetailLoaded) {
              state.movie.favorite = movie.favorite;
              final detailedMovie = state.movie;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: tag,
                    child: Stack(
                      children: [
                        Image.network(imageUrl, fit: BoxFit.cover),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.black54,
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    movie.title ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text('${movie.voteAverage}/10'),
                                IconButton(
                                  isSelected: movie.favorite == true,
                                  selectedIcon: const Icon(
                                    Icons.star,
                                    color: Colors.orangeAccent,
                                  ),
                                  icon: const Icon(
                                    Icons.star,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    context.read<DetailBloc>().add(
                                      DetailSwitchFavoriteMovieEvent(movie),
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
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 10.0,
                    ),
                    child: Text(detailedMovie.overview ?? ''),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(color: Colors.grey),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 4.0,
                    ),
                    child: Text(
                      'Produção - ${detailedMovie.productionCompanies!.map((company) => company.name).join(', ')}',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 4.0,
                    ),
                    child: Text('Duração - ${detailedMovie.runtime} minutos'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 4.0,
                    ),
                    child: Text(
                      'Lançamento - ${detailedMovie.releaseDate!.day}/${detailedMovie.releaseDate!.month}/${detailedMovie.releaseDate!.year}',
                    ),
                  ),
                  if (detailedMovie.collection != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        bottom: 4.0,
                      ),
                      child: Text(
                        'Coleção - ${detailedMovie.collection!.name!}',
                      ),
                    ),
                  if (detailedMovie.genres != null &&
                      detailedMovie.genres!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        bottom: 4.0,
                      ),
                      child: Text(
                        'Generos - ${detailedMovie.genres!.map((genre) => genre.name).join(', ')}',
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 4.0,
                    ),
                    child: Text(
                      'País de origem - ${detailedMovie.originCountry!.join(', ')}',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 4.0,
                    ),
                    child: Text(
                      'Idioma original - ${detailedMovie.originalLanguage}',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 4.0,
                    ),
                    child: Text(
                      'Título original - ${detailedMovie.originalTitle}',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 4.0,
                    ),
                    child: Text(
                      'Orçamento - ${currencyFormatter.format(detailedMovie.budget)}',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 4.0,
                    ),
                    child: Text(
                      'Receita - ${currencyFormatter.format(detailedMovie.revenue)}',
                    ),
                  ),
                  if (detailedMovie.homepage != null &&
                      detailedMovie.homepage!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        bottom: 4.0,
                      ),
                      child: Text('Link - ${detailedMovie.homepage}'),
                    ),
                ],
              );
            }
            if (state is DetailError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
