import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../bloc/search/search_bloc.dart';
import 'components/movie_hero.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller =
      GetIt.instance.get<TextEditingController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Pesquise por um filme...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
                  onSubmitted: (value) {
                    context.read<SearchBloc>().add(
                      value.isEmpty
                          ? SearchClearEvent()
                          : SearchLoadEvent(value),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final query = _controller.text.trim();
                  if (query.isNotEmpty) {
                    context.read<SearchBloc>().add(SearchLoadEvent(query));
                  }
                },
                child: const Text('Buscar'),
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchInitial) {
                return const Center(child: Text('Procure seu filme favorito.'));
              }
              if (state is SearchLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is SearchLoaded) {
                if (state.movies.isEmpty) {
                  return const Center(child: Text('Nenhum filme encontrado.'));
                }
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                            context.read<SearchBloc>().add(
                              SearchSwitchFavoriteMovieEvent(movie),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              }
              if (state is SearchError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
