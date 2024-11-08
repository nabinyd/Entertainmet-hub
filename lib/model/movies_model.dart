class MoviesModel {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final String voteAveragerating;
  final String releaseDate;
  final String voteCount;
  final String popularity;


  MoviesModel({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.voteAveragerating,
    required this.releaseDate,
    required this.voteCount,
    required this.popularity,
    required this.id,
  });

  factory MoviesModel.fromJson(Map<String, dynamic> json) {
    return MoviesModel(
      id: json['id'].toString() ?? '',
      title: json['title'] ?? '',
      imageUrl: json['poster_path'] ?? '',
      description: json['overview'] ?? '',
      voteAveragerating: json['vote_average'].toString() ?? '',
      releaseDate: json['release_date'] ?? '',
      voteCount: json['vote_count'].toString() ?? '',
      popularity: json['popularity'].toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_path': imageUrl,
      'overview': description,
      'vote_average': voteAveragerating,
      'release_date': releaseDate,
      'vote_count': voteCount,
      'popularity': popularity,
    };
  }
}