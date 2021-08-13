import 'package:flutter/material.dart';

class NotFoundCard extends StatelessWidget {
  final String title;
  const NotFoundCard({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: 300,
            height: 300,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  "https://media.istockphoto.com/vectors/error-page-dead-emoji-illustration-vector-id1095047472?k=6&m=1095047472&s=612x612&w=0&h=3pmxoo0x2rRQXv7z_3Ijm_tsMXMkJfImBdBsXmCJ_tQ=",
                ),
                fit: BoxFit.contain,
              ),
            ),
            child: null,
          ),
          Container(
            margin: const EdgeInsets.only(
              bottom: 20.0,
            ),
            child: Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontFamily: 'OpenSans',
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
