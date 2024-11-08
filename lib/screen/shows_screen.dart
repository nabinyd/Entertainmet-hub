import 'package:entertainmethub/component/moviecard.dart';
import 'package:entertainmethub/model/movies_model.dart';
import 'package:entertainmethub/provider/shows_provider.dart';
import 'package:entertainmethub/provider/user_fav_shows_provider.dart';
import 'package:entertainmethub/user/user_favourite_movies.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowsScreen extends StatefulWidget {
  const ShowsScreen({super.key});

  @override
  State<ShowsScreen> createState() => _ShowsScreenState();
}

class _ShowsScreenState extends State<ShowsScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<MoviesModel> _showsList = [];

  @override
  void initState() {
    Provider.of<ShowsProvider>(context, listen: false).fetchShows();
    super.initState();
  }

  Future<void> _fetchShows() async {
    final tvShowProvider = Provider.of<ShowsProvider>(context, listen: false);
    await tvShowProvider.fetchShows();
    final response = tvShowProvider.showsList;
    setState(() {
      _showsList = response;
    });
  }

  Future<void> _searchShows(String query) async {
    final tvShowProvider = Provider.of<ShowsProvider>(context, listen: false);
    await tvShowProvider.searchShows(query);
    final response = tvShowProvider.showsList;
    setState(() {
      _showsList = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tvShowProvider = Provider.of<ShowsProvider>(context);

    final userFavShowProvider =
        Provider.of<UserFavouriteShowsProvider>(context, listen: false);
    FavServiceProvider favserviceProvider =
        Provider.of<FavServiceProvider>(context, listen: false);

    _showsList = tvShowProvider.showsList;

    return Scaffold(
      appBar: AppBar(
        title: SearchBar(
          hintText: 'Search Shows',
          controller: _searchController,
          backgroundColor: WidgetStatePropertyAll(Colors.blueGrey[50]),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )),
          onChanged: (value) {
            if (value.isEmpty) {
              _fetchShows();
            } else {
              _searchShows(value);
            }
          },
          onSubmitted: (value) {
            if (value.isEmpty) {
              _fetchShows();
            } else {
              _searchShows(value);
            }
          },
        ),
      ),
      body: tvShowProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 400,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: _showsList.length,
                      itemBuilder: (context, index) {
                        final MoviesModel show = _showsList[index];
                        return MoviesCard(
                          title: show.title.toString(),
                          overview: show.description.toString(),
                          posterPath: show.imageUrl.toString(),
                          id: int.parse(show.id),
                          releaseDate: show.releaseDate,
                          voteAverage: double.parse(show.voteAveragerating),
                          popularity: double.parse(show.popularity),
                          onFavourite: () async {
                            userFavShowProvider.toggleFavShow(show);
                            final favShows = userFavShowProvider.favShows;
                            await favserviceProvider.saveShowList(favShows);
                            await favserviceProvider.getShowList();
                          },
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          tvShowProvider.decrementPage();
                          _fetchShows();
                        },
                        label: const Text("Previous"),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          tvShowProvider.incrementPage();
                          _fetchShows();
                        },
                        label: const Text("Next"),
                        icon: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
