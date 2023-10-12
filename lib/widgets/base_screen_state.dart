import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

abstract class BaseScreenState<T extends StatefulWidget> extends State<T> with SingleTickerProviderStateMixin {
  late AuthProvider authProvider;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation; // Use double type for fade effect

  // Abstract method that must be implemented by subclasses
  Widget buildScreen(BuildContext context);

  @override
  void initState() {
    super.initState();

    authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Initialize the animation controller
    _controller = AnimationController(
      duration: Duration(milliseconds: 750),  // Set the duration as needed
      vsync: this,
    );

    // Create a fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0, // Start with transparency 0 (fully transparent)
      end: 1.0, // End with transparency 1 (fully opaque)
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubicEmphasized, // Use a suitable curve
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
            Colors.grey.withOpacity(0.09),
            Colors.blue.withOpacity(0.06),
            Colors.grey.withOpacity(0.09),
          ], // Define your gradient colors
        ),
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: buildScreen(context),
      ),
    );
  }
}
