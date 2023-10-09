import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class BaseScreenState<T extends StatefulWidget> extends State<T> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  // Abstract method that must be implemented by subclasses
  Widget buildScreen(BuildContext context);

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: Duration(milliseconds: 500), // Set the duration as needed
      vsync: this,
    );

    // Create a slide animation with a bounce effect
    _slideAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0), // Start off-screen to the right
      end: Offset(0.0, 0.0), // End at the center of the screen
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack, // Use a bounce curve
      ),
    );

    // Start the animation after a small delay, but only if the widget is still mounted
    if (!mounted) return;

    Future.delayed(Duration(milliseconds: 250), () {
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, // Define the gradient's start and end points
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.2),
            Colors.blue.withOpacity(0.3),
            Colors.black.withOpacity(0.1),
          ], // Define your gradient colors
        ),
      ),
      child: SlideTransition(
        position: _slideAnimation,
        child: buildScreen(context),
      ),
    );
  }
}
