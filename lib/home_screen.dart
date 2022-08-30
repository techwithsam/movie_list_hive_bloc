import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_list_hive/models/movie_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Movie> moviesBox;
  @override
  void initState() {
    super.initState();
    moviesBox = Hive.box('favorite_movies');
    debugPrint('Movies: ${moviesBox.values}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorite Movies'),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showModalBottomSheet(movieBox: moviesBox),
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: moviesBox.listenable(),
        builder: (context, Box<Movie> box, _) {
          List<Movie> movies = box.values.toList().cast<Movie>();
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              Movie movie = movies[index];
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
                        moviesBox.put(
                          movie.id,
                          movie.copyWith(
                              addedToWatchList: !movie.addedToWatchList),
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
                          movieBox: moviesBox,
                          movie: movie,
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        box.delete(movie.id);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showModalBottomSheet({Movie? movie, required Box movieBox}) {
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
                decoration: const InputDecoration(labelText: 'Movie'),
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
                    moviesBox.put(
                      movie.id,
                      movie.copyWith(
                        name: nameController.text,
                        imageUrl: imgUrlController.text,
                      ),
                    );
                  } else {
                    Movie movie = Movie(
                      id: '${random.nextInt(10000)}',
                      name: nameController.text,
                      imageUrl: imgUrlController.text,
                      addedToWatchList: false,
                    );

                    movieBox.put(movie.id, movie);
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
