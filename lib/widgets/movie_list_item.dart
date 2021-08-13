import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../constants/color_constants.dart';
import '../models/movie.dart';
import './bounce_animation.dart';

class MovieListItem extends HookWidget {
  final Movie movie;
  final Function? updateMovie;
  final Function? deleteMovie;

  const MovieListItem({
    Key? key,
    required this.movie,
    this.updateMovie,
    this.deleteMovie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BounceAnimation(
      onPress: () {},
      child: Container(
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: '${movie.id}image',
                    child: Container(
                      height: 180.0,
                      width: 180.0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Image(
                        image: NetworkImage(
                          movie.imageUrl,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 25.0,
                    ),
                    alignment: Alignment.center,
                    child: Hero(
                      tag: movie.id,
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          movie.name,
                          style: const TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 5.0,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      movie.director,
                      style: const TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 14.0,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 145.0,
              left: 0.0,
              child: FloatingActionButton(
                heroTag: 'four${movie.id}',
                backgroundColor: ColorConstants.PRIMARY,
                tooltip: 'Delete ${movie.name}',
                mini: true,
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 20.0,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(
                        'Are your sure?',
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              fontFamily: 'OpenSans',
                            ),
                      ),
                      content: const Text(
                          'Once done, this action can\'t be undone.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'CANCEL',
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      fontFamily: 'OpenSans',
                                      color: ColorConstants.SECONDARY,
                                    ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => {
                            deleteMovie!(movie.id),
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(
                                  seconds: 3,
                                ),
                                backgroundColor: Colors.white,
                                content: Text(
                                  '${movie.name} is deleted',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Navigator.of(context).pop(),
                          },
                          child: Text(
                            'DELETE',
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      fontFamily: 'OpenSans',
                                      color: ColorConstants.PRIMARY,
                                    ),
                          ),
                        )
                      ],
                    ),
                  );

                  // );
                },
              ),
            ),
            Positioned(
              top: 145.0,
              right: 0.0,
              child: FloatingActionButton(
                heroTag: 'three${movie.id}',
                backgroundColor: ColorConstants.SECONDARY,
                tooltip: 'Edit ${movie.name}',
                mini: true,
                child: const Icon(
                  Icons.edit_rounded,
                  color: Colors.white,
                  size: 20.0,
                ),
                onPressed: () => {
                  updateMovie!(),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
