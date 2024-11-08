import 'dart:convert';

import 'package:entertainmethub/model/movies_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavServiceProvider with ChangeNotifier {
  Future<void> saveMovieList(List<MoviesModel> movies) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonStringList =
        movies.map((movie) => jsonEncode(movie.toJson())).toList();
    await prefs.setStringList('favMovies', jsonStringList);
    notifyListeners();
  }

  List<MoviesModel> _favMovies = [];
  List<MoviesModel> get favMovies => _favMovies;

  Future<void> getMovieList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonStringList = prefs.getStringList('favMovies') ?? [];

    if (jsonStringList.isNotEmpty) {
      _favMovies = jsonStringList
          .map((jsonString) => MoviesModel.fromJson(jsonDecode(jsonString)))
          .toList();
      notifyListeners();
    }
  }

  Future<void> saveShowList(List<dynamic> shows) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonStringList =
        shows.map((show) => jsonEncode(show)).toList();
    await prefs.setStringList('favShows', jsonStringList);
    notifyListeners();
  }

  List<dynamic> _favShows = [];
  List<dynamic> get favShows => _favShows;

  Future<void> getShowList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonStringList = prefs.getStringList('favShows') ?? [];

    if (jsonStringList.isNotEmpty) {
      _favShows = jsonStringList
          .map((jsonString) => MoviesModel.fromJson(jsonDecode(jsonString)))
          .toList();

      notifyListeners();
    }
  }

  Future<void> saveJokeList(List<String> jokes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonStringList =
        jokes.map((joke) => jsonEncode(joke)).toList();
    await prefs.setStringList('favJokes', jsonStringList);
    notifyListeners();
  }

  List<String> _favJokes = [];
  List<String> get favJokes => _favJokes;

  Future<void> getJokeList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonStringList = prefs.getStringList('favJokes') ?? [];

    if (jsonStringList.isNotEmpty) {
      _favJokes = jsonStringList;
      notifyListeners();
    }
  }

  Future<void> clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}
