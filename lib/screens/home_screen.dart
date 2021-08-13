import 'package:eight_app/models/movie.dart';
import 'package:eight_app/widgets/main_drawer.dart';
import 'package:eight_app/widgets/movie_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'movies/movies_overview_screen.dart';

class HomeScreenArguments {
  HomeScreenArguments();
}

class HomeScreen extends HookWidget {
  static const String route = '/';
  final HomeScreenArguments? arguments;
  final String title;
  const HomeScreen({Key? key, this.arguments, required this.title})
      : super(key: key);

  void openAddOrUpdateMovieModal({
    required BuildContext context,
    Movie? movie,
    required Function movieFunction,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      isScrollControlled: true,
      builder: (builderContext) {
        return GestureDetector(
          onTap: () {},
          child: ListView(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Center(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            30,
                          ),
                        ),
                      ),
                      color: Colors.grey,
                      margin: EdgeInsets.all(10),
                      child: SizedBox(
                        height: 5,
                        width: 20,
                      ),
                    ),
                  ),
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: Wrap(
                      children: [
                        MovieForm(
                          movieFunction: movieFunction,
                          movie: movie,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Box<Movie> movieBox = Hive.box<Movie>("movies");

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: Builder(
            builder: (context) => Container(
              margin: const EdgeInsets.only(
                  // left: 35.0,
                  ),
              child: IconButton(
                icon: const Icon(
                  Icons.menu_rounded,
                  color: Colors.black,
                ),
                alignment: Alignment.center,
                splashRadius: 20.0,
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(
                right: 10.0,
              ),
              child: IconButton(
                tooltip: 'Add a new product',
                icon: const Icon(
                  Icons.add_circle_outline_outlined,
                  color: Colors.black,
                ),
                alignment: Alignment.center,
                splashRadius: 20.0,
                onPressed: () => openAddOrUpdateMovieModal(
                  context: context,
                  movieFunction: movieBox.put,
                ),
              ),
            ),
          ]),
      drawer: MainDrawer(
        title: title,
      ),
      body: MoviesOverviewScreen(
        openAddOrUpdateMovieModal: openAddOrUpdateMovieModal,
      ),
    );
  }
}
