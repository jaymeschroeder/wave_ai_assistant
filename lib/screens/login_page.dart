import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wave_ai_assistant/constants/constants.dart';

import '../providers/auth_provider.dart';
import '../widgets/base_screen_state.dart';
import 'main_menu.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends BaseScreenState<LoginPage> {
  @override
  Widget buildScreen(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Stack(
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
                        blurRadius: 44 // Shadow color
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
                        blurRadius: 44 // Shadow color
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
    );
  }
}
