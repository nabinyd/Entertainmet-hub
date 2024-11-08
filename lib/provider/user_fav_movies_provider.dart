import 'package:entertainmethub/model/movies_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserFavouriteMovieProvider extends ChangeNotifier {
  final List<MoviesModel> _favMovies = [];
  List<MoviesModel> get favMovies => _favMovies;

  Future<void> addFavMovie(MoviesModel movie) async {
    _favMovies.add(movie);
    notifyListeners();
  }

  Future<void> toggleFavMovie(MoviesModel movie) {
    print("movies.id: $movie");
    if (_favMovies.contains(movie)) {
      _favMovies.remove(movie);
      Fluttertoast.showToast(
        msg: 'Removed from Favourite',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      _favMovies.add(movie);
      Fluttertoast.showToast(
        msg: 'Added to Favourite',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    notifyListeners();
    return Future.value();
  }
}
