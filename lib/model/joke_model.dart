class JokesModel {
  final String joke;

  JokesModel({required this.joke});

  factory JokesModel.fromJson(Map<String, dynamic> json) {
    return JokesModel(
      joke: json['joke'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'joke': joke,
    };
  }

  @override
  String toString() {
    return joke;
  }
}
