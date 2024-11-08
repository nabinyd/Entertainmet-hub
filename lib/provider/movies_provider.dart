import 'package:dio/dio.dart';
import 'package:entertainmethub/model/movies_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MoviesProvider extends ChangeNotifier {
  final Dio _dio = Dio();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _page = 1;
  int get page => _page;

  void incrementPage() {
    if (page > 0) {
      _page++;
    }
    notifyListeners();
  }

  void decrementPage() {
    if (page > 1) {
      _page--;
    }
    notifyListeners();
  }

  int _searchPage = 1;
  int get searchPage => _searchPage;

  void incrementSearchPage() {
    if (searchPage > 0) {
      _searchPage++;
    }
    notifyListeners();
  }

  void decrementSearchPage() {
    if (searchPage > 1) {
      _searchPage--;
    }
    notifyListeners();
  }

  final List<MoviesModel> _moviesList = [];
  List<MoviesModel> get moviesList => _moviesList;

  Future<void> searchMovies(String query) async {
    _isLoading = true;

    try {
      final response = await _dio.get(
        'https://api.themoviedb.org/3/search/movie',
        queryParameters: {
          'query': query,
          'include_adult': false,
          'language': 'en-US',
          'page': _searchPage.toString(),
        },
        options: Options(headers: {
          'Authorization': 'Bearer ${dotenv.env['TMDB_API_READ_ACCESS_TOKEN']}',
        }),
      );

      _moviesList.clear();

      for (var element in response.data['results']) {
        _moviesList.add(MoviesModel(
          id: element['id'].toString() ?? '',
          title: element['title'] ?? '',
          imageUrl: element['poster_path'] ?? '',
          description: element['overview'] ?? '',
          voteAveragerating: element['vote_average'].toString(),
          releaseDate: element['release_date'] ?? '',
          voteCount: element['vote_count'].toString() ?? '',
          popularity: element['popularity'].toString() ?? '',
        ));
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      Fluttertoast.showToast(
        msg: "Failed to search movies",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      rethrow;
    }
  }

  Future<void> fetchNowPlayingMovies() async {
    _isLoading = true;
    try {
      final response = await _dio.get(
          'https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=${_page.toString()}',
          options: Options(headers: {
            'Authorization':
                'Bearer ${dotenv.env['TMDB_API_READ_ACCESS_TOKEN']}',
          }));

      _moviesList.clear();

      print(response.data['results']);

      for (var movie in response.data['results']) {
        _moviesList.add(MoviesModel(
          id: movie['id'].toString(),
          title: movie['title'],
          imageUrl: movie['poster_path'],
          description: movie['overview'],
          voteAveragerating: movie['vote_average'].toString(),
          releaseDate: movie['release_date'],
          voteCount: movie['vote_count'].toString(),
          popularity: movie['popularity'].toString(),
        ));
      }

      notifyListeners();
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      Fluttertoast.showToast(
        msg: "Failed to fetch movies",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      rethrow;
    }
  }

  int _popularPage = 1;
  int get popularPage => _popularPage;

  void incrementPopularPage() {
    if (_popularPage > 0) {
      _popularPage++;
    }
    notifyListeners();
  }

  void decrementPopularPage() {
    if (_popularPage > 1) {
      _popularPage--;
    }
    notifyListeners();
  }

  final List<MoviesModel> _popularMoviesList = [];
  List<MoviesModel> get popularMoviesList => _popularMoviesList;

  Future<void> fetchPopularMovies() async {
    _isLoading = true;
    try {
      final response = await _dio.get(
          'https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=${_popularPage.toString()}',
          options: Options(headers: {
            'Authorization':
                'Bearer ${dotenv.env['TMDB_API_READ_ACCESS_TOKEN']}',
          }));

      _popularMoviesList.clear();

      for (var movie in response.data['results']) {
        _popularMoviesList.add(MoviesModel(
          id: movie['id'].toString(),
          title: movie['title'],
          imageUrl: movie['poster_path'],
          description: movie['overview'],
          voteAveragerating: movie['vote_average'].toString(),
          releaseDate: movie['release_date'],
          voteCount: movie['vote_count'].toString(),
          popularity: movie['popularity'].toString(),
        ));
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _popularMoviesList.clear();
      Fluttertoast.showToast(
        msg: "Failed to fetch movies",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      rethrow;
    }
  }
}
