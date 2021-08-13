import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  final String title;
  const MainDrawer({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
    return Drawer(
      elevation: 20.0,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    // shape: BoxShape.circle,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                  ),
                  child: const Image(
                    image: NetworkImage(
                      'https://user-images.githubusercontent.com/44650484/129349344-3bdc7aad-ac23-4b11-bb5e-907cdc45630d.png',
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 0.0),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 0.0,
                    bottom: 20.0,
                  ),
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
                  child: const Text(
                    'You very own place to list all your favorite movies',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Pacifico',
                      letterSpacing: 3.0,
                      fontSize: 22.0,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
