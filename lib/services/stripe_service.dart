import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:wave_ai_assistant/constants/api_keys.dart';
import 'package:wave_ai_assistant/constants/constants.dart';

import '../utils/alert_dialog_util.dart';
import 'firebase_service.dart';

class StripeService {
  static Future<void> initStripeService() async {
    Stripe.publishableKey = STRIPE_PUBLISHABLE_KEY;
    Stripe.merchantIdentifier = "WaveAI";
    await Stripe.instance.applySettings();
  }


  Future<void> setupSubscription() async {

    HttpsCallable createSubscriptionPayment =
    FirebaseFunctions.instanceFor(region: "us-central1").httpsCallable('createSubscriptionPayment');

    final User user = FirebaseAuth.instance.currentUser!;
    if (user == null) {
      // Handle unauthenticated user
      return;
    }

    try {
      final HttpsCallableResult result = await createSubscriptionPayment.call({
        'totalPayment': 1000, // Replace with your desired payment amount
        'currency': 'usd', // Replace with your desired currency
        'email': user.email,
        'customer_name': user.displayName,
      });

      final String clientSecret = result.data['clientSecret'];
      //final SetupIntent setupIntent = await Stripe.instance.confirmSetupIntent(paymentIntentClientSecret: clientSecret, params: null);

      // Handle successful subscription setup
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  static Future<dynamic> _getSetupIntent(String uid) async {

    String? name = await FirebaseService.getUserName(uid);
    String? email = await FirebaseService.getUserEmail(uid);
    String? stripeId = await FirebaseService.getStripeCustomerId(uid);

    HttpsCallable getPaymentIntentFunction =
    FirebaseFunctions.instanceFor(region: "us-central1").httpsCallable('createSetupIntent');

    final result;

    if (stripeId == null) {
      result = await getPaymentIntentFunction(jsonDecode(
          '{"customer_name":"$name","email":"$email"}'));
    } else {
      result = await getPaymentIntentFunction(jsonDecode(
          '{"customer_name":"$name","customer_stripe_id":"$stripeId","email":"$email"}'));
    }

    return result.data;
  }

  static Future<dynamic> _setDefaultPaymentMethodIntent(String uid) async {

    String? stripeId = await FirebaseService.getStripeCustomerId(uid);

    HttpsCallable getPaymentIntentFunction =
    FirebaseFunctions.instanceFor(region: "us-central1").httpsCallable('setDefaultPaymentMethod');

    print("calling setDefault method intent");
    final result;

    result = await getPaymentIntentFunction(jsonDecode('{"customer_stripe_id":"$stripeId"}'));

    print("result should be received for setdefaultpaymentmethodintent with result: " + result.toString());

    return result.data;
  }

  static Future<dynamic> addCard(BuildContext context, String uid, {Function? onCardAdded}) async {
    final _setupIntent = await _getSetupIntent(uid);
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
          style: ThemeMode.light,
          merchantDisplayName: '${APP_NAME}',
          setupIntentClientSecret: _setupIntent['setupIntent'],
          customerId: _setupIntent['customer'],),
    );

    // Update customer with stripe ID to save card to customer
    FirebaseService.addStripeCustomerId(uid, _setupIntent['customer']);

    try {
      await Stripe.instance.presentPaymentSheet();

      await _setDefaultPaymentMethodIntent(uid);

      await setupSubcription(uid);

      if (onCardAdded != null) onCardAdded();

      return true;
    } catch (e) {
      // TODO If error is stripe related, we need to handle each issue specifically
      if (e is StripeException) {
        if (e.error.code.toString() == "FailureCode.Canceled") {
          //AlertDialogUtil.showAlertDialog(_context!, "Payment form cancelled",
            //  content: "Please setup a payment method if you wish to use RV TechLink's on-demand service.");
          print("The error is: " + e.toString());
        } else {
         // AlertDialogUtil.showAlertDialog(_context!, "Payment method error",
            //  content:
             // "We were unable to add your payment method to your account due to the following error:\n\n ${e.error.code}\n");

          print("The error is: " + e.toString());
        }
      } else {
        print("There is an exception: " + e.toString());
      }

      return false;
    }
  }

  static Future<dynamic> getSubscriptions(String uid) async {
    String? stripeCustomerId = await FirebaseService.getStripeCustomerId(uid);

    if (stripeCustomerId != null) {
      HttpsCallable getSubscriptions =
          FirebaseFunctions.instanceFor(region: "us-central1").httpsCallable('getSubscriptions');

      final result;

      result = await getSubscriptions(jsonDecode('{"customer_stripe_id":"$stripeCustomerId"}'));

      print("Stripe result: " + result.data.toString());

      return result.data;
    }
  }

  static Future<dynamic> setupSubcription(String uid) async {
    String? stripeCustomerId = await FirebaseService.getStripeCustomerId(uid);

    if (stripeCustomerId != null) {
      HttpsCallable setupSubcriptionIntent =
          FirebaseFunctions.instanceFor(region: "us-central1").httpsCallable('subscribe');

      final result;

      result = await setupSubcriptionIntent(
          jsonDecode('{"customer_stripe_id":"$stripeCustomerId","price_id":"$STRIPE_SUB_BASIC"}'));

      print("Stripe result: " + result.data.toString());

      return result.data;
    }
  }

  static Future<dynamic> cancelSubscription(String uid) async {
    String? stripeCustomerId = await FirebaseService.getStripeCustomerId(uid);

    if (stripeCustomerId != null) {
      HttpsCallable cancelSubscriptionIntent =
          FirebaseFunctions.instanceFor(region: "us-central1").httpsCallable('cancelSubscription');

      final result;

      result = await cancelSubscriptionIntent(
          jsonDecode('{"customer_stripe_id":"$stripeCustomerId","price_id":"$STRIPE_SUB_BASIC"}'));

      print("Stripe result: " + result.data.toString());

      return result.data;
    }
  }
}
