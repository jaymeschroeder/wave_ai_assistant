import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wave_ai_assistant/constants/constants.dart';

import '../providers/auth_provider.dart';
import 'main_menu.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

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
    final authProvider = Provider.of<AuthProvider>(context);

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
              colors: [Colors.purple.withOpacity(0.2),Colors.blue.withOpacity(0.3),  Colors.purpleAccent.withOpacity(0.1)], // Define your gradient colors
            )
          ),
          child: Stack(
            children: [
              // Background Gradient Decoration
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Spacer(),

                    Text(
                      "Wave",
                      textAlign: TextAlign.center,
                      style: TextStyle(

                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        shadows: [
                          Shadow(

                              offset: Offset(-6, -6), // Adjust the shadow offset as needed
                              color: Colors.black,
                              blurRadius: 44// Shadow color
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "AI Assistant",
                      textAlign: TextAlign.center,
                      style: TextStyle(

                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(

                            offset: Offset(-6, -6), // Adjust the shadow offset as needed
                            color: Colors.black,
                            blurRadius: 44// Shadow color
                          ),
                        ],
                      ),
                    ),


                    Spacer(),

                    // Google Sign-In Button
                    ElevatedButton.icon(
                      onPressed: () async {
                        // Handle Google Sign-In
                        User? user = await authProvider.handleGoogleSignIn();



                      },
                      icon: const Icon(
                        Icons.g_translate, // You can use any Google-like icon here
                        color: Colors.blue, // Google's blue color
                      ),
                      label: const Text(
                        'Sign in with Google',
                        style: TextStyle(
                          color: Colors.black, // Google uses black for the text color
                          fontSize: 16.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.white,
                        // Google's blue color for the splash effect
                        elevation: 2.0,
                        // Add a subtle elevation
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Facebook Sign-In Button
                    ElevatedButton.icon(
                      onPressed: () async {
                        authProvider.handleFacebookSignIn();
                      },
                      icon: Icon(
                        Icons.facebook,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Sign in with Facebook',
                        style: TextStyle(color: Colors.white70),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1877F2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Continue Without Logging In Button
                    TextButton(
                      onPressed: () {
                        // Handle continue without logging in
                      },
                      child: Text(
                        'Continue Without Logging In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
