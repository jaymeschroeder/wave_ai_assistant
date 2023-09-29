import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class BaseScreenState<T extends StatefulWidget> extends State<T> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  // Abstract method that must be implemented by subclasses
  Widget buildScreen(BuildContext context);

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: Duration(seconds: 1), // Set the duration as needed
      vsync: this,
    );

    // Create a fade animation
    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    // Start the animation after a small delay, but only if the widget is still mounted
    if (!mounted) return;

    Future.delayed(Duration(milliseconds: 500), () {
      if (!mounted) return; // Check again before starting the animation
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft, // Define the gradient's start and end points
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.withOpacity(0.2),
              Colors.blue.withOpacity(0.3),
              Colors.purpleAccent.withOpacity(0.1)
            ], // Define your gradient colors
          )),
          child: buildScreen(context),
        ),
      ),
    );
  }
}
