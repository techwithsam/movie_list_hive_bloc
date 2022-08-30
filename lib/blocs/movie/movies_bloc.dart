import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_list_hive/hive_database.dart';
import 'package:movie_list_hive/models/movie_model.dart';
part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final HiveDatabase hiveDatabase;
  MoviesBloc({required this.hiveDatabase}) : super(MovieLoading()) {
    on<LoadMovies>(_onLoadMovies);
    on<UpdateMovie>(_onUpdateMovie);
    on<AddMovie>(_onAddMovie);
    on<DeleteMovie>(_onDeleteMovie);
    on<DeleteAllMovies>(_onDeleteAllMovies);
  }

  void _onLoadMovies(
    LoadMovies event,
    Emitter<MoviesState> emit,
  ) async {
    Future.delayed(const Duration(seconds: 1));
  }

  void _onUpdateMovie(
    UpdateMovie event,
    Emitter<MoviesState> emit,
  ) async {}

  void _onAddMovie(
    AddMovie event,
    Emitter<MoviesState> emit,
  ) async {}

  void _onDeleteMovie(
    DeleteMovie event,
    Emitter<MoviesState> emit,
  ) async {}

  void _onDeleteAllMovies(
    DeleteAllMovies event,
    Emitter<MoviesState> emit,
  ) async {}
}
