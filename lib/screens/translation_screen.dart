import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:wave_ai_assistant/widgets/frosted_glass_background.dart';

import '../constants/constants.dart';
import '../services/chatgpt_service.dart';
import '../utils/language_util.dart';
import '../widgets/base_screen_state.dart';
import '../widgets/gradient_button.dart';

class TranslationScreen extends StatefulWidget {
  @override
  _TranslationScreenState createState() => _TranslationScreenState();
}

class _TranslationScreenState extends BaseScreenState<TranslationScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final stt.SpeechToText speech = stt.SpeechToText();
  String recognizedText = '';
  String statusText = "Not Listening";
  String previousMessage = '';
  String currentLanguage = "en-US";
  bool isListening = false;
  bool isProcessing = false; // Add a flag for processing speech
  bool isResponseInListFormat = false; // Add a variable to track list format response

  @override
  void initState() {
    super.initState();

    try {
      initializeTextToSpeech();
    } catch (error) {
      print("TTS ERROR: $error");
    }
  }

  @override
  Widget buildScreen(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 56.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: CoolDropdown(
                isMarquee: true,
                defaultItem: CoolDropdownItem(
                    label: 'English (United States)',
                    value: "en-US",
                    icon: CountryFlag.fromCountryCode(
                      "en-US".substring(3),
                      height: 24,
                      width: 24,
                      borderRadius: 8,
                    )),
                dropdownOptions: const DropdownOptions(color: Colors.white38),
                resultOptions: const ResultOptions(
                    isMarquee: true,
                    render: ResultRender.all,
                    width: 200,
                    boxDecoration: BoxDecoration(color: Colors.white10),
                    openBoxDecoration: BoxDecoration(color: Colors.white10),
                    textStyle: TextStyle(color: Colors.white)),
                dropdownItemOptions: const DropdownItemOptions(
                    selectedBoxDecoration: BoxDecoration(color: Colors.black38), isMarquee: true),
                dropdownList: LanguageUtil()
                    .languages
                    .map((e) => CoolDropdownItem(
                          label: e.name,
                          value: e.code,
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: CountryFlag.fromCountryCode(
                              e.code.substring(3),
                              height: 24,
                              width: 24,
                              borderRadius: 8,
                            ),
                          ),
                        ))
                    .toList(),
                controller: DropdownController(),
                onChange: (value) async {
                  currentLanguage = value;
                  await flutterTts.setLanguage(value);
                }),
          ),
        ),
        const Spacer(),
        Container(
          height: 150.0, // Set a fixed height for the container
          alignment: Alignment.center, // Center its content vertically
          child: Visibility(
            visible: isListening,
            child: SpinKitPulse(
              duration: const Duration(seconds: 3),
              color: primaryColor,
              size: 150.0,
            ),
          ),
        ),
        Text(
          statusText, // When listening or not listening
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                  offset: Offset(-2, -2), // Adjust the shadow offset as needed
                  color: Colors.black,
                  blurRadius: 14 // Shadow color
                  ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            statusText == "Not Listening" ? previousMessage : recognizedText,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
        const Spacer(),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: GradientButton(
            () {
              isProcessing ? null : (isListening ? stopListening() : startListening());
            },
            iconColor: (statusText == "Listening") ? Colors.cyan : Colors.grey,
            buttonSize: 75,
          ),
        ),
      ],
    );
  }

  // Check and request microphone permission
  Future<void> checkAndRequestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      print("permission granted for microphone");
      await Permission.microphone.request();
    }
  }

  Future<void> initializeTextToSpeech() async {
    List<dynamic> voices = await flutterTts.getVoices;

    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.2);

    await flutterTts.setSpeechRate(0.5);

    // Call this function before starting speech recognition
    await checkAndRequestMicrophonePermission();
  }

  Future<void> startListening() async {
    try {
      if (await speech.initialize(
        onError: (error) {
          print(error);
        },
        onStatus: (status) async {
          print("SPEECH STATUS: $status");
          if (status == stt.SpeechToText.listeningStatus) {
            setState(() {
              statusText = "Listening";
              isListening = true;
            });
          }
          if (status == stt.SpeechToText.doneStatus) {
            if (recognizedText.isNotEmpty) {
              setState(() {
                print("Changing status text");
                statusText = "Processing";
              });

              String response = await ChatGPTService.translateMessage(recognizedText, currentLanguage);

              print(response);
              // Read out the response using text-to-speech
              setState(() {
                previousMessage = recognizedText;
                recognizedText = ''; // Reset recognizedText
                statusText = "Wave Assistant Speaking";
              });

              flutterTts.setCompletionHandler(() {
                setState(() {
                  statusText = "Not Listening";
                });
              });

              await flutterTts.speak(response);
            } else {
              setState(() {
                statusText = "Not Listening";
              });
            }

            stopListening();
          }
        },
      )) {
        speech.listen(
          onResult: (result) async {
            print("TTS RESULT : $result");
            setState(() {
              recognizedText = result.recognizedWords;
            });
          },
        );
      }
    } catch (error) {
      print("TTS Error: $error");
    }
  }

  Future<void> stopListening() async {
    try {
      await speech.stop();
      setState(() {
        isListening = false;
        isProcessing = true; // Set processing flag to true
      });

      // Implement logic to send recognizedText to ChatGPT API
      // and play the response using text-to-speech

      // After processing, reset the processing flag to false
      setState(() {
        isProcessing = false;
      });
    } catch (error) {
      print("TTS Error: $error");
    }
  }

  Future<void> resetConversation() async {
    // Implement logic to send recognizedText to ChatGPT API
    // and play the response using text-to-speech

    ChatGPTService.resetAssistant();

    setState(() {
      previousMessage = "";
      recognizedText = "";
    });

    // Read out the response using text-to-speech
    await flutterTts.speak("Conversation cleared");
  }
}
