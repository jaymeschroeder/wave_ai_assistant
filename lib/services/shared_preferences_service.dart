import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static Future<bool> hasSeenIntro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasSeenIntro') ?? false; // Default to false if the value is not set

  }

  static Future<void> markIntroAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenIntro', true);
  }
}