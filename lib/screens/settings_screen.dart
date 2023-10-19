import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/enums/result_render.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:cool_dropdown/options/dropdown_item_options.dart';
import 'package:cool_dropdown/options/dropdown_options.dart';
import 'package:cool_dropdown/options/result_options.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:wave_ai_assistant/services/shared_preferences_service.dart';

import '../constants/constants.dart';
import '../services/TTSService.dart';
import '../services/chatgpt_service.dart';
import '../utils/language_util.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/base_screen_state.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/frosted_glass_background.dart';
import '../widgets/gradient_button.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends BaseScreenState<SettingsScreen> {
  double speechRate = 1;
  double speechPitch = 1;

  @override
  void initState() {
    super.initState();

    speechRate = TTSService.getSpeechRate();
    speechPitch = TTSService.getSpeechPitch();
  }

  @override
  Widget buildScreen(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 56.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Speech Pitch",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                ),
                Text(
                  "Set the pitch of your assistant's voice",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                ),
                CupertinoSlider(
                  value: speechPitch,
                  onChanged: (double value) {
                    setState(() {
                      speechPitch = value;
                      print(value);
                      TTSService.setSpeechPitch(value);
                      SharedPreferencesService.setSpeechPitch(value);
                    });
                  },
                  min: 0.5,
                  max: 2,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Speech Rate",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                ),
                Text(
                  "Set the speed at which your voice assistant will speak to you",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                ),
                CupertinoSlider(
                  value: speechRate,
                  onChanged: (double value) {
                    setState(() {
                      speechRate = value;
                      print(value);
                      TTSService.setSpeechRate(value);
                      SharedPreferencesService.setSpeechRate(value);
                    });
                  },
                  min: 0,
                  max: 1,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 62, right: 62, top: 8),
            child: Column(
              children: [
                Text(
                  "Primary Language",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                ),
                Text(
                  "Set the primary language for your voice assistant",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CoolDropdown(
                      isMarquee: true,
                      defaultItem: CoolDropdownItem(
                          label: LanguageUtil()
                              .languages
                              .firstWhere((element) => element.code == TTSService.primaryLanguage)
                              .name,
                          value: TTSService.primaryLanguage,
                          icon: CountryFlag.fromCountryCode(
                            LanguageUtil()
                                .languages
                                .firstWhere((element) => element.code == TTSService.primaryLanguage)
                                .code
                                .substring(3),
                            height: 24,
                            width: 24,
                            borderRadius: 8,
                          )),
                      dropdownOptions: const DropdownOptions(color: Colors.white),
                      resultOptions: const ResultOptions(
                          isMarquee: true,
                          render: ResultRender.all,
                          width: 200,
                          boxDecoration: BoxDecoration(color: Colors.white),
                          openBoxDecoration: BoxDecoration(color: Colors.white),
                          textStyle: TextStyle(color: Colors.black)),
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
                        TTSService.primaryLanguage = value;
                        await TTSService.setLanguage(value);
                        SharedPreferencesService.setPrimaryLanguage(value);
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Implement the speech recognition and text-to-speech logic here.
}
