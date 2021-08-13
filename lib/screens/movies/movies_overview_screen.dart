import 'package:eight_app/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../widgets/not_found_card.dart';
import '../../widgets/movie_list_item.dart';

class ProductsOverviewScreenArguments {
  const ProductsOverviewScreenArguments();
}

class MoviesOverviewScreen extends HookWidget {
  final ProductsOverviewScreenArguments? arguments;
  final Function openAddOrUpdateMovieModal;

  const MoviesOverviewScreen({
    Key? key,
    this.arguments,
    required this.openAddOrUpdateMovieModal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Box<Movie> movieBox = Hive.box<Movie>("movies");

    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                bottom: 30.0,
              ),
              child: Text(
                'Movie Hub',
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontSize: 40.0,
                      letterSpacing: 2.0,
                    ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: movieBox.listenable(),
              builder: (BuildContext ctx, Box<Movie> movies, _) {
                return Container(
                  margin: EdgeInsets.only(
                    top: movieBox.keys.toList().isEmpty ? 30 : 150.0,
                  ),
                  child: movies.keys.toList().isEmpty
                      ? const Center(
                          child: NotFoundCard(
                            title: 'No movie added!',
                          ),
                        )
                      : GridView.builder(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio:
                                MediaQuery.of(context).size.height / 1650,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                          itemBuilder: (ctx, index) {
                            final movie =
                                movies.get(movies.keys.toList()[index]);
                            return MovieListItem(
                              movie: movie as Movie,
                              deleteMovie: movieBox.delete,
                              updateMovie: () => openAddOrUpdateMovieModal(
                                context: context,
                                movie: movie,
                                movieFunction: movieBox.put,
                              ),
                            );
                          },
                          itemCount: movies.keys.toList().length,
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
