import '../../pages/homepage.dart';
import '../../pages/movie_detail_page.dart';

class Routes {
  Map<String, dynamic> routes = {
    '/': (context) => const Homepage(),
    '/movie': (context,) => const MovieDetailPage(),
  };
}