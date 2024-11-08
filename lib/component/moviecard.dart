import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MoviesCard extends StatefulWidget {
  final String title;
  final String overview;
  final String posterPath;
  final String? releaseDate;
  final double? voteAverage;
  final int id;
  final double? popularity;
  final Function? onFavourite;
  const MoviesCard({
    super.key,
    required this.title,
    required this.overview,
    required this.posterPath,
    this.releaseDate,
    this.voteAverage,
    required this.id,
    this.popularity,
    this.onFavourite,
  });

  @override
  State<MoviesCard> createState() => _MoviesCardState();
}

class _MoviesCardState extends State<MoviesCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(5),
      width: 300,
      height: 300,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: CachedNetworkImage(
              imageUrl: 'https://image.tmdb.org/t/p/w500${widget.posterPath}',
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              widget.overview,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Icon(Icons.star),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(widget.voteAverage.toString()),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(widget.releaseDate ?? ''),
                ],
              ),
              IconButton(
                  onPressed: widget.onFavourite as void Function()?,
                  icon: const Icon(Icons.favorite)),
            ],
          )
        ],
      ),
    );
  }
}
