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
import '../services/TTSService.dart';
import '../services/chatgpt_service.dart';
import '../utils/language_util.dart';
import '../widgets/base_screen_state.dart';
import '../widgets/gradient_button.dart';

class TranslationScreen extends StatefulWidget {
  @override
  _TranslationScreenState createState() => _TranslationScreenState();
}

class _TranslationScreenState extends BaseScreenState<TranslationScreen> {
  @override
  void initState() {
    super.initState();

    TTSService.setOnComplete((){
      setState(() {

      });
    });

    try {
      TTSService.initializeTextToSpeech();
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
                    label: LanguageUtil()
                        .languages
                        .firstWhere((element) => element.code == TTSService.currentLanguage)
                        .name,
                    value: TTSService.currentLanguage,
                    icon: CountryFlag.fromCountryCode(
                      LanguageUtil()
                          .languages
                          .firstWhere((element) => element.code == TTSService.currentLanguage)
                          .code
                          .substring(3),
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
                  TTSService.currentLanguage = value;
                  await TTSService.setLanguage(value);
                }),
          ),
        ),
        const Spacer(),
        Container(
          height: 150.0, // Set a fixed height for the container
          alignment: Alignment.center, // Center its content vertically
          child: Visibility(
            visible: TTSService.isListening,
            child: SpinKitPulse(
              duration: const Duration(seconds: 3),
              color: primaryColor,
              size: 150.0,
            ),
          ),
        ),
        Text(
          TTSService.statusText, // When listening or not listening
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
            TTSService.statusText == "Not Listening" ? TTSService.previousMessage : TTSService.recognizedText,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
        const Spacer(),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: GradientButton(
            () {
              TTSService.isProcessing
                  ? null
                  : (TTSService.isListening ? TTSService.stopListening() : TTSService.startListening(true));
            },
            iconColor: (TTSService.statusText == "Listening") ? Colors.cyan : Colors.grey,
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

  @override
  void dispose() {
    TTSService.dispose();
    super.dispose();
  }
}
