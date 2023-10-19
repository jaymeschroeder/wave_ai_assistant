import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

abstract class BaseScreenState<T extends StatefulWidget> extends State<T>
    with SingleTickerProviderStateMixin {
  late AuthProvider authProvider;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation; // Use double type for fade effect

  List<Color> _gradientColors = [Colors.purple, Colors.blue, Colors.green, Colors.pink, Colors.cyan];
  int _currentColorIndex = 0;

  // Abstract method that must be implemented by subclasses
  Widget buildScreen(BuildContext context);

  @override
  void initState() {
    super.initState();

    authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Initialize the animation controller
    _controller = AnimationController(
      duration: Duration(milliseconds: 750), // Set the duration as needed
      vsync: this,
    );

    // Create a fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0, // Start with transparency 0 (fully transparent)
      end: 1.0, // End with transparency 1 (fully opaque)
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic, // Use a suitable curve
      ),
    );

    // Start the animation after a small delay, but only if the widget is still mounted
    if (!mounted) return;
    _controller.forward(from: 0.0);
    // Start a periodic timer to change the gradient colors smoothly
    Timer.periodic(Duration(seconds: 10), (Timer timer) {
      if (!mounted) return;
     //
      setState(() {
        _currentColorIndex = (_currentColorIndex + 1) % _gradientColors.length;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[
        Container(
          child: AnimatedContainer(
            duration: Duration(seconds: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, // Define the gradient's start and end points
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey
                      .withOpacity(0.08), // Use the current color with opacity
                  _gradientColors[(_currentColorIndex + 1) % _gradientColors.length]
                      .withOpacity(0.12),
                  Colors.grey
                      .withOpacity(0.08),
                ], // Define your gradient colors
              ),
            ),
          ),
        ),
        FadeTransition(
          opacity: _fadeAnimation,
          child: buildScreen(context),
        ),
      ]
    );
  }
}
