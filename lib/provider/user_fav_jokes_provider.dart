import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserFavJokesProvider extends ChangeNotifier {
  final List<String> _favJokes = [];
  List<String> get favJokes => _favJokes;

  Future<void> addFavJoke(dynamic joke) async {
    _favJokes.add(joke);
    notifyListeners();
  }

  void toggleFavJoke(String joke) {
    if (_favJokes.contains(joke)) {
      _favJokes.remove(joke);
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
      _favJokes.add(joke);
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
