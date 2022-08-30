part of 'movies_bloc.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object> get props => [];
}

class LoadMovies extends MoviesEvent {}

class UpdateMovie extends MoviesEvent {
  final Movie movie;

  const UpdateMovie({required this.movie});

  @override
  List<Object> get props => [movie];
}

class AddMovie extends MoviesEvent {
  final Movie movie;

  const AddMovie({required this.movie});

  @override
  List<Object> get props => [movie];
}

class DeleteMovie extends MoviesEvent {
  final Movie movie;

  const DeleteMovie({required this.movie});

  @override
  List<Object> get props => [movie];
}

class DeleteAllMovies extends MoviesEvent {}
