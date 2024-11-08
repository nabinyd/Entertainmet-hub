import 'package:entertainmethub/provider/jokes_provider.dart';
import 'package:entertainmethub/provider/user_fav_jokes_provider.dart';
import 'package:entertainmethub/user/user_favourite_movies.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JokesScreen extends StatefulWidget {
  const JokesScreen({super.key});

  @override
  State<JokesScreen> createState() => _JokesScreenState();
}

class _JokesScreenState extends State<JokesScreen> {
  String joke = '';
  @override
  void initState() {
    _fetchJokes();
    super.initState();
  }

  Future<void> _fetchJokes() async {
    final jokesProvider = Provider.of<JokesProvider>(context, listen: false);
    final response = await jokesProvider.fetchJokes();

    setState(() {
      joke = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    final jokesProvider = Provider.of<JokesProvider>(context, listen: true);
    final userFavJokesProvider = Provider.of<UserFavJokesProvider>(context);
    final favserviceProvider = Provider.of<FavServiceProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jokes',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: jokesProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(5),
                      width: 300,
                      height: 400,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          joke,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20),
                        ),
                      )),
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(Color(0xFF6200EE)),
                    ),
                    onPressed: () async {
                      await _fetchJokes();
                    },
                    child: const Text(
                      'New Joke',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(Color(0xFF6200EE)),
                    ),
                    onPressed: () async {
                      userFavJokesProvider.toggleFavJoke(joke);
                      final favJokes = userFavJokesProvider.favJokes;
                      await favserviceProvider.saveJokeList(favJokes);
                      await favserviceProvider.getJokeList();
                    },
                    child: const Text('Favourite',
                        style: TextStyle(color: Color(0xFFFFFFFF))),
                  )
                ],
              ),
            ),
    );
  }
}
