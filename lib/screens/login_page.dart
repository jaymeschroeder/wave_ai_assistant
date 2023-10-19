import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wave_ai_assistant/constants/constants.dart';
import 'package:wave_ai_assistant/services/shared_preferences_service.dart';

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
    return Material(
      color: Colors.white.withOpacity(0),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Spacer(),

                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Wave',
                        style: TextStyle(
                          color: Colors.cyan,
                          fontSize: 48, // Adjust the font size as needed
                          fontWeight: FontWeight.bold, // You can also make it bold for emphasis
                          shadows: [
                            Shadow(
                              color: Colors.black, // Shadow color
                              offset: Offset(2, 2), // Shadow offset
                              blurRadius: 4, // Shadow blur radius
                            ),
                          ],
                        ),
                      ),
                      TextSpan(
                        text: 'ai',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48, // Adjust the font size as needed
                          fontWeight: FontWeight.bold, // You can also make it bold for emphasis
                          shadows: [
                            Shadow(
                              color: Colors.black, // Shadow color
                              offset: Offset(2, 2), // Shadow offset
                              blurRadius: 4, // Shadow blur radius
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  "Assistant",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42, // Adjust the font size as needed
                    fontWeight: FontWeight.bold, // You can also make it bold for emphasis
                    shadows: [
                      Shadow(
                        color: Colors.black, // Shadow color
                        offset: Offset(2, 2), // Shadow offset
                        blurRadius: 4, // Shadow blur radius
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

                /*
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

                 */

                // Continue Without Logging In Button
                TextButton(
                  onPressed: () {
                    // Handle continue without logging in
                    authProvider.signInAnonymously();
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
    );
  }
}
