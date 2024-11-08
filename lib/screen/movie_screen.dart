import 'package:entertainmethub/component/moviecard.dart';
import 'package:entertainmethub/model/movies_model.dart';
import 'package:entertainmethub/provider/movies_provider.dart';
import 'package:entertainmethub/provider/user_fav_movies_provider.dart';
import 'package:entertainmethub/user/user_favourite_movies.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<MoviesModel> _moviesList = [];
  List<MoviesModel> _popularMoviesList = [];

  @override
  void initState() {
    final prov = Provider.of<MoviesProvider>(context, listen: false);
    prov.fetchNowPlayingMovies();
    prov.fetchPopularMovies();
    super.initState();
  }

  Future<void> _fetchMovies() async {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    await moviesProvider.fetchNowPlayingMovies();
    final response = moviesProvider.moviesList;
    setState(() {
      _moviesList = response;
    });
  }

  Future<void> _searchMovies(String query) async {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    await moviesProvider.searchMovies(query);
    final response = moviesProvider.moviesList;
    setState(() {
      _moviesList = response;
    });
  }

  Future<void> _fetchPopularMovies() async {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    await moviesProvider.fetchPopularMovies();
    final response = moviesProvider.popularMoviesList;
    setState(() {
      _popularMoviesList = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: true);
    final favserviceProvider =
        Provider.of<FavServiceProvider>(context, listen: false);
    final UserFavouriteMovieProvider userFavProvider =
        Provider.of<UserFavouriteMovieProvider>(context, listen: false);

    _moviesList = moviesProvider.moviesList;
    _popularMoviesList = moviesProvider.popularMoviesList;

    return Scaffold(
      appBar: AppBar(
        title: SearchBar(
          hintText: 'Search Movies',
          controller: _searchController,
          backgroundColor: WidgetStatePropertyAll(Colors.blueGrey[50]),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onChanged: (value) {
            if (value.isEmpty) {
              _fetchMovies();
            } else {
              _searchMovies(value);
            }
          },
          onSubmitted: (value) {
            if (value.isEmpty) {
              _fetchMovies();
            }
            _searchMovies(value);
          },
        ),
      ),
      body: moviesProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Movies',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(
                    height: 400,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: _moviesList.length,
                      itemBuilder: (context, index) {
                        final movie = _moviesList[index];
                        return MoviesCard(
                          title: movie.title,
                          overview: movie.description,
                          posterPath: movie.imageUrl,
                          id: int.parse(movie.id),
                          releaseDate: movie.releaseDate,
                          voteAverage: double.parse(movie.voteAveragerating),
                          popularity: double.parse(movie.popularity),
                          onFavourite: () async {
                            await userFavProvider.toggleFavMovie(movie);
                            final favMovies = userFavProvider.favMovies;
                            await favserviceProvider.saveMovieList(favMovies);
                            await favserviceProvider.getMovieList();
                          },
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          moviesProvider.decrementPage();
                          _fetchMovies();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          moviesProvider.incrementPage();
                          _fetchMovies();
                        },
                      ),
                    ],
                  ),
                  Text(
                    "Upcoming Movies",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(
                    height: 400,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: _popularMoviesList.length,
                      itemBuilder: (context, index) {
                        final movie = _popularMoviesList[index];
                        return MoviesCard(
                          title: movie.title,
                          overview: movie.description,
                          posterPath: movie.imageUrl,
                          id: int.parse(movie.id),
                          releaseDate: movie.releaseDate,
                          voteAverage: double.parse(movie.voteAveragerating),
                          popularity: double.parse(movie.popularity),
                          onFavourite: () async {
                            await userFavProvider.toggleFavMovie(movie);
                            final favMovies = userFavProvider.favMovies;
                            await favserviceProvider.saveMovieList(favMovies);
                            await favserviceProvider.getMovieList();
                          },
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          moviesProvider.decrementPopularPage();
                          _fetchPopularMovies();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          moviesProvider.incrementPopularPage();
                          _fetchPopularMovies();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
