import 'package:flutter/material.dart';

/// Padding values
const double small_100 = 8.0;

/// Border radius
BorderRadius normalBorderRadius = BorderRadius.circular(small_100);
BorderRadius normal3BorderRadius =
    const BorderRadius.only(topRight: Radius.circular(small_100), bottomRight: Radius.circular(small_100), bottomLeft: Radius.circular(small_100));

///                                  A    R    G    B
const Color color1 = Color.fromARGB(255, 150, 200, 255);
const Color color2 = Color.fromARGB(255, 255, 255, 0);
const Color color3 = Color.fromARGB(255, 255, 150, 200);

const LinearGradient linearGradientRo = LinearGradient(
  colors: [color1, color2, color3],
);
