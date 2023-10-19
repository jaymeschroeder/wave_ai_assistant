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

  static Future<void> setSpeechRate(double speechRate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('speechRate', speechRate);
  }

  static Future<double> getSpeechRate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('speechRate') ?? 0.5; // Default to false if the value is not set
  }

  static Future<void> setSpeechPitch(double speechPitch) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('speechPitch', speechPitch);
  }

  static Future<double> getSpeechPitch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('speechPitch') ?? 1; // Default to false if the value is not set
  }

  static Future<void> setPrimaryLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('primaryLanguage', language);
  }

  static Future<String> getPrimaryLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('primaryLanguage') ?? "en-US";
  }

  static Future<void> setAnonymousUid(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('anonymousUid', uid);
  }

  static Future<String> getAnonymousUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('anonymousUid') ?? "";
  }
}