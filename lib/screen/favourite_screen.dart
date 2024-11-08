import 'package:cached_network_image/cached_network_image.dart';
import 'package:entertainmethub/model/movies_model.dart';
import 'package:entertainmethub/user/user_favourite_movies.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List _favMovies = [];
  List _favShows = [];
  List _favJokes = [];

  @override
  void initState() {
    _showFavMovies();
    _showFavShows();
    _showFavJokes();
    super.initState();
  }

  Future<void> _showFavMovies() async {
    final favserviceProvider =
        Provider.of<FavServiceProvider>(context, listen: false);
    await favserviceProvider.getMovieList();
    final favMovies = favserviceProvider.favMovies;
    setState(() {
      _favMovies = favMovies;
    });
  }

  Future<void> _showFavShows() async {
    final favserviceProvider =
        Provider.of<FavServiceProvider>(context, listen: false);
    await favserviceProvider.getShowList();
    final favShows = favserviceProvider.favShows;
    setState(() {
      _favShows = favShows;
    });
  }

  Future<void> _showFavJokes() async {
    final favserviceProvider =
        Provider.of<FavServiceProvider>(context, listen: false);
    await favserviceProvider.getJokeList();
    final favJokes = favserviceProvider.favJokes;
    setState(() {
      _favJokes = favJokes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favserviceProvider =
        Provider.of<FavServiceProvider>(context, listen: true);

    _favMovies = favserviceProvider.favMovies;
    _favShows = favserviceProvider.favShows;
    _favJokes = favserviceProvider.favJokes;

    return Scaffold(
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Favourite Movies', style: TextStyle(fontSize: 25)),
          ),
          if (_favMovies.isNotEmpty)
            for (MoviesModel movie in _favMovies)
              ListTile(
                title: Text(movie.title),
                subtitle: Text(
                  movie.description,
                  overflow: TextOverflow.ellipsis,
                ),
                leading: CachedNetworkImage(
                  imageUrl: 'https://image.tmdb.org/t/p/w500${movie.imageUrl}',
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Favourite Shows',
              style: TextStyle(fontSize: 25),
            ),
          ),
          if (_favShows.isNotEmpty)
            for (MoviesModel show in _favShows)
              ListTile(
                title: Text(show.title),
                subtitle: Text(
                  show.description,
                  overflow: TextOverflow.ellipsis,
                ),
                leading: CachedNetworkImage(
                  imageUrl: 'https://image.tmdb.org/t/p/w500${show.imageUrl}',
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Favourite Jokes', style: TextStyle(fontSize: 25)),
          ),
          if (_favJokes.isNotEmpty)
            for (var joke in _favJokes)
              ListTile(
                title: Text(joke),
              ),
        ],
      ),
    );
  }
}
