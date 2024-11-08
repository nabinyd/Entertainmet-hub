import 'package:dio/dio.dart';
import 'package:entertainmethub/model/movies_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShowsProvider extends ChangeNotifier {
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

  final List<MoviesModel> _showsList = [];
  List<MoviesModel> get showsList => _showsList;

  Future<void> fetchShows() async {
    _isLoading = true;
    try {
      final response = await _dio.get(
        'https://api.themoviedb.org/3/search/tv?query=air&include_adult=false&language=en-US&page=${_page.toString()}',
        options: Options(headers: {
          'Authorization': 'Bearer ${dotenv.env['TMDB_API_READ_ACCESS_TOKEN']}',
        }));

    _showsList.clear();

    for (var element in response.data['results']) {
      _showsList.add(MoviesModel(
        id: element['id'].toString() ?? '',
        title: element['name'] ?? '',
        imageUrl: element['poster_path'] ?? '',
        description: element['overview'] ?? '',
        voteAveragerating: element['vote_average'].toString(),
        releaseDate: element['first_air_date'] ?? '',
        voteCount: element['vote_count'].toString() ?? '',
        popularity: element['popularity'].toString() ?? '',
      ));
    }
    _isLoading = false;
    notifyListeners();
    } catch (e) {
      _isLoading = false;
      _showsList.clear();
      Fluttertoast.showToast(
        msg: 'Error fetching shows',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }
  }

  Future<void> searchShows(String query) async {
    _isLoading = true;

    try {
      final response = await _dio.get(
        'https://api.themoviedb.org/3/search/tv',
        queryParameters: {
          'query': query,
          'include_adult': false,
          'language': 'en-US',
        },
        options: Options(headers: {
          'Authorization': 'Bearer ${dotenv.env['TMDB_API_READ_ACCESS_TOKEN']}',
        }),
      );

      _showsList.clear();

      for (var element in response.data['results']) {
        _showsList.add(MoviesModel(
          id: element['id'].toString() ?? '',
          title: element['name'] ?? '',
          imageUrl: element['poster_path'] ?? '',
          description: element['overview'] ?? '',
          voteAveragerating: element['vote_average'].toString(),
          releaseDate: element['first_air_date'] ?? '',
          voteCount: element['vote_count'].toString() ?? '',
          popularity: element['popularity'].toString() ?? '',
        ));
      }
      _isLoading = false;
    } catch (e) {
      print("Error: $e");
      _isLoading = false;
      _showsList.clear();
      Fluttertoast.showToast(
        msg: 'Error fetching shows',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    _isLoading = false;
    notifyListeners();
  }
}
