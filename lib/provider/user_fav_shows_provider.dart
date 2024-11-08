import 'package:entertainmethub/model/movies_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserFavouriteShowsProvider extends ChangeNotifier {
  final List<MoviesModel> _favShows = [];
  List<MoviesModel> get favShows => _favShows;

  void toggleFavShow(MoviesModel show) {
    if (_favShows.contains(show)) {
      _favShows.remove(show);
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
      _favShows.add(show);
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
  }
}
