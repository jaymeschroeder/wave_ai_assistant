import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:wave_ai_assistant/services/shared_preferences_service.dart';

import 'chatgpt_service.dart';

class TTSService {
  static final FlutterTts Tts = FlutterTts();
  static final SpeechToText Stt = SpeechToText();
  static String recognizedText = '';
  static String statusText = "Not Listening";
  static String previousMessage = '';
  static String currentLanguage = "en-US";
  static String primaryLanguage = "en-US";
  static bool isListening = false;
  static bool isProcessing = false; // Add a flag for processing speech
  static bool isResponseInListFormat = false; // Add a variable to track list format response
  static double speechRate = 0.5;
  static double speechPitch = 1.2;

  static late Function onComplete;

  static setOnComplete(Function onCompleteCallback) {
    onComplete = onCompleteCallback;
  }

  static dispose() {
    Tts.stop(); // Stop the text-to-speech engine
    Stt.stop(); //
  }

  // Check and request microphone permission
  static Future<void> checkAndRequestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      print("permission granted for microphone");
      await Permission.microphone.request();
    }
  }

  static Future<void> setSpeechRate(double value) async {
    speechRate = value;
    Tts.setSpeechRate(value);
  }

  static double getSpeechRate() {
    return speechRate;
  }

  static Future<void> setSpeechPitch(double value) async {
    speechPitch = value;
    Tts.setPitch(value);
  }

  static double getSpeechPitch() {
    return speechPitch;
  }

  static Future<void> setPrimaryLanguage(String language) async {
    Tts.setLanguage(language);
  }

  static Future<void> initializeTextToSpeech() async {
    recognizedText = '';
    statusText = "Not Listening";
    previousMessage = '';

    primaryLanguage = await SharedPreferencesService.getPrimaryLanguage();
    currentLanguage = primaryLanguage;
    speechRate = await SharedPreferencesService.getSpeechRate();
    speechPitch = await SharedPreferencesService.getSpeechPitch();

    await Tts.setLanguage(primaryLanguage);
    await Tts.setPitch(speechPitch);
    await Tts.setSpeechRate(speechRate);

    onComplete();
    // Call this function before starting speech recognition
    await checkAndRequestMicrophonePermission();
  }

  static Future<void> setLanguage(String language) async {
    Tts.setLanguage(language);
  }

  static Future<void> startListening(bool isTranslating) async {
    try {
      if (await Stt.initialize()) {
        Stt.statusListener = (status) async {
          print("SPEECH STATUS: $status");
          if (status == SpeechToText.listeningStatus) {
            statusText = "Listening";
            isListening = true;
            onComplete();
          }
          if (status == SpeechToText.doneStatus) {
            if (recognizedText.isNotEmpty) {
              print("Changing status text");
              statusText = "Processing";

              String response;

              if (isTranslating) {
                print("istranslating");
                response = await ChatGPTService.translateMessage(recognizedText, currentLanguage);
              } else {
                print("isassistanting");
                response = await ChatGPTService.sendMessage(recognizedText);
              }

              print(response);
              // Read out the response using text-to-speech

              previousMessage = recognizedText;
              recognizedText = ''; // Reset recognizedText
              statusText = "Wave Assistant Speaking";
              onComplete();

              Tts.setCompletionHandler(() {
                statusText = "Not Listening";
                onComplete();
              });

              await Tts.speak(response);
            } else {
              statusText = "Not Listening";
              onComplete();
            }

            stopListening();
          }
        };

        Stt.listen(
          onResult: (result) async {
            recognizedText = result.recognizedWords;
            onComplete();
          },
        );
      }
    } catch (error) {
      print("TTS Error: $error");
    }
  }

  static Future<void> stopListening() async {
    try {
      await Stt.stop();

      isListening = false;
      isProcessing = true; // Set processing flag to true

      // Implement logic to send recognizedText to ChatGPT API
      // and play the response using text-to-speech

      // After processing, reset the processing flag to false

      isProcessing = false;
      onComplete();
    } catch (error) {
      print("TTS Error: $error");
    }
  }

  static Future<void> resetConversation() async {
    // Implement logic to send recognizedText to ChatGPT API
    // and play the response using text-to-speech

    ChatGPTService.resetAssistant();

    previousMessage = "";
    recognizedText = "";

    onComplete();

    // Read out the response using text-to-speech
    await Tts.speak("Conversation cleared");
  }
}
