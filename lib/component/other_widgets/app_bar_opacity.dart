import 'dart:ui';

import 'package:flutter/cupertino.dart';

Widget appBarOpacity() {
  return ClipRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(255, 255, 255, 0.9),
              Color.fromRGBO(255, 255, 255, 0.80),
              Color.fromRGBO(255, 255, 255, 0.60),
              Color.fromRGBO(255, 255, 255, 0.40),
              Color.fromRGBO(255, 255, 255, 0.20),
              Color.fromRGBO(255, 255, 255, 0.0),
            ],
          ),
        ),
      ),
    ),
  );
}
