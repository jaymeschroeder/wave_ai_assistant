import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:wave_ai_assistant/services/TTSService.dart';
import 'package:wave_ai_assistant/services/chatgpt_service.dart';
import 'package:wave_ai_assistant/utils/alert_dialog_util.dart';
import 'package:wave_ai_assistant/utils/modal_sheet_utils.dart' as ppt;
import 'package:wave_ai_assistant/widgets/gradient_button.dart';
import 'package:wave_ai_assistant/utils/modal_sheet_utils.dart';

import '../constants/constants.dart';
import '../services/stripe_service.dart';
import '../widgets/base_screen_state.dart';

class AssistantScreen extends StatefulWidget {
  @override
  _AssistantScreenState createState() => _AssistantScreenState();
}

class _AssistantScreenState extends BaseScreenState<AssistantScreen> {
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {
                  AlertDialogUtil.showConfirmationDialog(
                      context: context,
                      message: "Are you sure you want to clear your current chat log?",
                      onConfirm: () => TTSService.resetConversation());
                },
                icon: const Icon(
                  Icons.cancel_presentation,
                  size: 42,
                  color: Colors.red,
                )),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: GradientButton(
                () {
                  try {

                      TTSService.isProcessing
                          ? null
                          : (TTSService.isListening ? TTSService.stopListening() : TTSService.startListening(false));

                  } catch (e) {
                    print("ERROR WITH STT: $e");
                  }
                },
                iconColor: (TTSService.statusText == "Listening") ? Colors.cyan : Colors.grey,
                buttonSize: 75,
              ),
            ),
            IconButton(
                onPressed: () {
                  ModalSheetUtils.showChatLogSheet(context);
                },
                icon: const Icon(
                  Icons.chat_rounded,
                  size: 42,
                  color: Colors.cyan,
                )),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    TTSService.dispose();
    super.dispose();
  }
}
