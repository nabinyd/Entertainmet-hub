import 'package:entertainmethub/provider/jokes_provider.dart';
import 'package:entertainmethub/provider/movies_provider.dart';
import 'package:entertainmethub/provider/shows_provider.dart';
import 'package:entertainmethub/provider/user_fav_jokes_provider.dart';
import 'package:entertainmethub/provider/user_fav_movies_provider.dart';
import 'package:entertainmethub/provider/user_fav_shows_provider.dart';
import 'package:entertainmethub/screen/favourite_screen.dart';
import 'package:entertainmethub/screen/joke_screen.dart';
import 'package:entertainmethub/screen/movie_screen.dart';
import 'package:entertainmethub/screen/shows_screen.dart';
import 'package:entertainmethub/user/user_favourite_movies.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MoviesProvider()),
        ChangeNotifierProvider(
            create: (context) => UserFavouriteMovieProvider()),
        ChangeNotifierProvider(
            create: (context) => UserFavouriteShowsProvider()),
        ChangeNotifierProvider(create: (context) => UserFavJokesProvider()),
        ChangeNotifierProvider(create: (context) => ShowsProvider()),
        ChangeNotifierProvider(create: (context) => JokesProvider()),
        ChangeNotifierProvider(create: (context) => FavServiceProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: FToastBuilder(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      const MovieScreen(),
      const ShowsScreen(),
      const JokesScreen(),
      const FavouriteScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entertainment Hub',
            style: TextStyle(fontSize: 20, color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF6200EE),
      ),
      body: PersistentTabView(
        context,
        screens: _buildScreens(),
        controller: _controller,
        navBarStyle: NavBarStyle.style1,
        items: [
          PersistentBottomNavBarItem(
              icon: const Icon(Icons.movie), title: 'Movies'),
          PersistentBottomNavBarItem(
              icon: const Icon(Icons.tv), title: 'TV Shows'),
          PersistentBottomNavBarItem(
              icon: const Icon(Icons.music_note), title: 'Joke'),
          PersistentBottomNavBarItem(
              icon: const Icon(Icons.favorite), title: 'Favourites'),
        ],
      ),
    );
  }
}
