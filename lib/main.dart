import 'dart:io';

import 'package:eight_app/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import './constants/theme.dart';
import 'screens/home_screen.dart';

void main() async {
  Hive.registerAdapter(MovieModelAdapter());
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox<Movie>('movies');
  runApp(
    const MyApp(),
  );
}

class MyApp extends HookWidget {
  // This widget is the root of your application.
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Box<Movie> movieBox = Hive.box("movies");
    return MaterialApp(
      title: 'Movie Hub',
      // themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      theme: theme,
      // ignore: unnecessary_null_comparison
      home: movieBox == null
          ? const CircularProgressIndicator()
          : const HomeScreen(title: 'Movie Hub'),
    );
  }
}
