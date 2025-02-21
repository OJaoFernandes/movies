import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'bloc/detail/detail_bloc.dart';
import 'bloc/discover/discover_bloc.dart';
import 'bloc/favorites/favorites_bloc.dart';
import 'bloc/search/search_bloc.dart';
import 'core/database/database_service.dart';
import 'core/database/db_services/collections_service.dart';
import 'core/database/db_services/companies_service.dart';
import 'core/database/db_services/genres_service.dart';
import 'core/database/db_services/movies_service.dart';
import 'core/routes/routes.dart';
import 'core/theme/app_theme.dart';
import 'repository/movies_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeDependencies();
  runApp(MyApp());
}

Future<void> _initializeDependencies() async {
  final getIt = GetIt.instance;
  final databaseService = DatabaseService();
  final searchController = TextEditingController();

  await databaseService.database;

  getIt.registerSingleton<DatabaseService>(databaseService);
  getIt.registerSingleton<MoviesService>(MoviesService());
  getIt.registerSingleton<CollectionsService>(CollectionsService());
  getIt.registerSingleton<GenresService>(GenresService());
  getIt.registerSingleton<CompaniesService>(CompaniesService());
  getIt.registerSingleton<MoviesRepository>(MoviesRepository());
  getIt.registerSingleton<Routes>(Routes());
  getIt.registerSingleton<Dio>(
    Dio(
      BaseOptions(
        baseUrl: 'https://api.themoviedb.org/3',
        queryParameters: {
          'api_key': 'bf850661de2471df3599be142a33aad0',
          'language': 'pt-BR',
        },
      ),
    ),
  );
  getIt.registerSingleton<TextEditingController>(searchController);
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final getIt = GetIt.instance;

  @override
  Widget build(BuildContext context) {
    final routes = getIt.get<Routes>().routes;

    return MultiBlocProvider(
      providers: [
        BlocProvider<DiscoverBloc>(create: (context) => DiscoverBloc()),
        BlocProvider<FavoritesBloc>(create: (context) => FavoritesBloc()),
        BlocProvider<SearchBloc>(create: (context) => SearchBloc()),
        BlocProvider(create: (context) => DetailBloc()),
      ],
      child: MaterialApp(
        title: 'MoviesApp',
        theme: AppTheme.darkTheme(),
        initialRoute: '/',
        routes: {...routes},
      ),
    );
  }
}
