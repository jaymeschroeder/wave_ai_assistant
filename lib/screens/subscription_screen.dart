import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../constants/constants.dart';
import '../services/chatgpt_service.dart';
import '../services/stripe_service.dart';
import '../utils/language_util.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/base_screen_state.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/frosted_glass_background.dart';
import '../widgets/gradient_button.dart';

class SubscriptionScreen extends StatefulWidget {
  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends BaseScreenState<SubscriptionScreen> {
  @override
  void initState() {
    super.initState();

    //StripeService.getSubscriptions(customerId)
  }

  @override
  Widget buildScreen(BuildContext context) {
    return FutureBuilder(
      future: StripeService.getSubscriptions(authProvider.user!.uid),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        print(snapshot.data);

        if (snapshot.data == null) {
          return Center(
              child: const CircularProgressIndicator(
            color: Colors.purpleAccent,
          ));
        } else if (snapshot.data == false) {
          return Center(
            child: //TODO Test button for subscription; USES TEST CUSTOMER ID - to be deleted
                IconButton(
                    onPressed: () async {
                      final result = await StripeService.addCard(context, authProvider.user!.uid,
                          onCardAdded: () => print("Sub Screen card added"));

                      if (result == true) setState(() {});
                    },
                    icon: const Icon(
                      Icons.subscriptions,
                      size: 42,
                      color: Colors.purpleAccent,
                    )),
          );
        } else {
          return Center(
              child: const Text(
            "Thank you for being a subscriber!",
            style: TextStyle(fontSize: 42, color: Colors.white70),
          ));
        }
      },
    );
  }

// Implement the speech recognition and text-to-speech logic here.
}
