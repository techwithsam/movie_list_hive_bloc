import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_list_hive/blocs/movie/movies_bloc.dart';
import 'package:movie_list_hive/hive_database.dart';
import 'package:movie_list_hive/home_screen.dart';
import 'package:movie_list_hive/models/movie_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(MovieAdapter());

  final hiveDatebase = HiveDatabase();
  await hiveDatebase.openBox();

  runApp(MyApp(hiveDatabase: hiveDatebase));
}

class MyApp extends StatelessWidget {
  final HiveDatabase? _hiveDatabase;
  const MyApp({Key? key, HiveDatabase? hiveDatabase})
      : _hiveDatabase = hiveDatabase,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _hiveDatabase,
      child: BlocProvider(
        create: (context) =>
            MoviesBloc(hiveDatabase: _hiveDatabase!)..add(LoadMovies()),
        child: MaterialApp(
          title: 'Movie List with BLoc & Hive',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: const MaterialColor(
              0xFF000A1F,
              <int, Color>{
                50: Color(0xFF000A1F),
                100: Color(0xFF000A1F),
                200: Color(0xFF000A1F),
                300: Color(0xFF000A1F),
                400: Color(0xFF000A1F),
                500: Color(0xFF000A1F),
                600: Color(0xFF000A1F),
                700: Color(0xFF000A1F),
              },
            ),
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
