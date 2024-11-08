import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';

class JokesProvider extends ChangeNotifier {
  final Dio _dio = Dio();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _joke = '';
  String get joke => _joke;

  Future<String> fetchJokes() async {
    _isLoading = true;
    try {
      final response = await _dio.get(
        'https://api.api-ninjas.com/v1/jokes',
        options: Options(headers: {
          'X-Api-Key': dotenv.env['JOKES_API_KEY'],
        }),
      );

      _joke = response.data[0]['joke'];
      _isLoading = false;
      return _joke;
    } catch (e) {
      _isLoading = false;
      Fluttertoast.showToast(
        msg: 'Failed to fetch jokes',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      rethrow;
    } finally {
      _isLoading = false;
    }
  }
}
