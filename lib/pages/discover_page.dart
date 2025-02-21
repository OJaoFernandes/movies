import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/discover/discover_bloc.dart';
import 'components/movie_hero.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  void initState() {
    super.initState();
    context.read<DiscoverBloc>().add(DiscoverLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverBloc, DiscoverState>(
      builder: (context, state) {
        if (state is DiscoverLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is DiscoverLoaded) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: state.movies.length,
              itemBuilder: (context, index) {
                final movie = state.movies[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: MovieHero(
                    movie: movie,
                    onFavoriteSwitch: () {
                      context.read<DiscoverBloc>().add(
                        DiscoverSwitchFavoriteMovieEvent(movie),
                      );
                    },
                  ),
                );
              },
            ),
          );
        }
        if (state is DiscoverError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
