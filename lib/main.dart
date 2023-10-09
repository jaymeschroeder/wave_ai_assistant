import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:wave_ai_assistant/constants/constants.dart';
import 'package:wave_ai_assistant/providers/auth_provider.dart';
import 'package:wave_ai_assistant/screens/assistant_screen.dart';
import 'package:wave_ai_assistant/screens/intro.dart';
import 'package:wave_ai_assistant/screens/login_page.dart';
import 'package:wave_ai_assistant/screens/main_screen.dart';
import 'package:wave_ai_assistant/services/shared_preferences_service.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => AuthProvider()), // Include AuthProvider here
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(testDeviceIds: [DEVICE_ID_S9]),
  );
  MobileAds.instance.initialize();
  await Firebase.initializeApp();

  final bool hasSeenIntro = await SharedPreferencesService.hasSeenIntro();

  runApp(
    MultiProvider(
      providers: providers,
      child: Main(
        hasSeenIntro: hasSeenIntro,
      ),
    ),
  );
}

class Main extends StatefulWidget {
  const Main({Key? key, required this.hasSeenIntro});

  final bool hasSeenIntro;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    authProvider.authStateChanges.listen((user) {
      if (user != null) {
        authProvider.setUser(user); // Update the user state in authProvider
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wave AI',
      theme: ThemeData(
        primaryTextTheme: GoogleFonts.montserratTextTheme(),
        textTheme: GoogleFonts.montserratTextTheme(),
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Colors.blue.withOpacity(0),
      ),
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.user == null) {
            // User is not authenticated, return to the sign-in page.
            if (widget.hasSeenIntro) {
              return LoginPage();
            } else {
              return Intro();
            }
          } else {
            // User is authenticated, show the main menu.
            return MainScreen();
          }
        },
      ),
    );
  }
}
