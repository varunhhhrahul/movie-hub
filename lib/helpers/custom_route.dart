import 'package:flutter/material.dart';

// For unnamed routes
class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({WidgetBuilder? builder, RouteSettings? settings})
      : super(builder: builder!, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == '/') {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

// For name routes
class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    var begin = const Offset(0.0, 1.0);
    var end = Offset.zero;
    var tween = Tween(begin: begin, end: end).chain(
      CurveTween(
        curve: Curves.easeOutCubic,
      ),
    );
    var offsetAnimation = animation.drive(tween);
    if (route.settings.name == '/') {
      return child;
    }

    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }
}
