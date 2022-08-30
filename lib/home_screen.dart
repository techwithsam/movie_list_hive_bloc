import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_list_hive/blocs/movie/movies_bloc.dart';
import 'package:movie_list_hive/models/movie_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorite Movies'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              context.read<MoviesBloc>().add(DeleteAllMovies());
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showModalBottomSheet(context: context),
        label: const Text('Add Movie'),
        icon: const Icon(Icons.add),
      ),
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is MovieLoaded) {
            return ListView.builder(
              itemCount: state.movies.length,
              itemBuilder: (context, index) {
                Movie movie = state.movies[index];
                return ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: Image.network(
                    movie.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  title: Text(movie.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          context.read<MoviesBloc>().add(
                                UpdateMovie(
                                  movie: movie.copyWith(
                                      addedToWatchList:
                                          !movie.addedToWatchList),
                                ),
                              );
                        },
                        icon: Icon(
                          Icons.watch_later,
                          color: movie.addedToWatchList
                              ? Colors.grey
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _showModalBottomSheet(
                            movie: movie,
                            context: context,
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<MoviesBloc>().add(
                                DeleteMovie(movie: state.movies[index]),
                              );
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Text('Something went wrong!');
          }
        },
      ),
    );
  }

  void _showModalBottomSheet({Movie? movie, required BuildContext context}) {
    Random random = Random();
    TextEditingController nameController = TextEditingController();
    TextEditingController imgUrlController = TextEditingController();

    if (movie != null) {
      nameController.text = movie.name;
      imgUrlController.text = movie.imageUrl;
    }

    showModalBottomSheet(
      context: context,
      isDismissible: true,
      elevation: 5,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(labelText: 'Movie title'),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: imgUrlController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  if (movie != null) {
                    context.read<MoviesBloc>().add(
                          UpdateMovie(
                            movie: movie.copyWith(
                              name: nameController.text,
                              imageUrl: imgUrlController.text,
                            ),
                          ),
                        );
                  } else {
                    Movie movie = Movie(
                      id: '${random.nextInt(10000)}',
                      name: nameController.text,
                      imageUrl: imgUrlController.text,
                      addedToWatchList: false,
                    );
                    context.read<MoviesBloc>().add(AddMovie(movie: movie));
                  }

                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }
}
