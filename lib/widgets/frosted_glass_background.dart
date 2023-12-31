import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FrostedGlassBackground extends StatelessWidget {
  final Widget child;

  FrostedGlassBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, // Define the gradient's start and end points
              end: Alignment.bottomRight,
              colors: [Colors.blue.withOpacity(0.1),  Colors.black.withOpacity(0.9)], // Define your gradient colors
            )
          ), // Adjust opacity as needed
          child: child,
        ),
      ),
    );
  }
}