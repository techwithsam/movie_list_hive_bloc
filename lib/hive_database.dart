import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_list_hive/models/movie_model.dart';

class HiveDatabase {
  String boxName = 'favorite_movies';

  Future<Box> openBox() async {
    Box box = await Hive.openBox<Movie>(boxName);
    return box;
  }

  List<Movie> getMovie(Box box) {
    return box.values.toList().cast<Movie>();
  }

  Future<void> addMovies(Box box, Movie movie) async {
    await box.put(movie.id, movie);
  }

  Future<void> updateMovie(Box box, Movie movie) async {
    await box.put(movie.id, movie);
  }

  Future<void> deleteMovie(Box box, Movie movie) async {
    await box.delete(movie.id);
  }

  Future<void> deleteAllMovie(Box box, Movie movie) async {
    await box.clear();
  }
}
