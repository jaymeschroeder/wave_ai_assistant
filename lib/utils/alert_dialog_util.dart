import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:wave_ai_assistant/widgets/frosted_glass_background.dart';

import '../constants/constants.dart';

class AlertDialogUtil {

  static void showSubcategoryDialog(BuildContext context, String title, String message, String buttonText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Colors.cyan, // Change text color to cyan
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue, // Change button background color to blue
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Static method to display a simple information dialog.
  static void showInformationDialog({
    required BuildContext context,
    String title = 'Information',
    required String message,
    String buttonText = 'OK',
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }

  // Static method to display a confirmation dialog.
  static void showConfirmationDialog({
    required BuildContext context,
    String title = 'Confirmation',
    required String message,
    String confirmButtonText = 'Confirm',
    String cancelButtonText = 'Cancel',
    required Function onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FrostedGlassBackground(
          child: AlertDialog(
            backgroundColor: Colors.white10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
              side: BorderSide(color: primaryColor.withOpacity(0.3), width: 1.0), // Blue border
            ),
            title: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            content: Text(
              message,
              style: TextStyle(color: Colors.white70),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  cancelButtonText,
                  style: TextStyle(color: Colors.cyanAccent, fontSize: 16,fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (onConfirm != null) {
                    onConfirm();
                  }
                  Navigator.of(context).pop();
                },
                child: Text(
                  confirmButtonText,
                  style: TextStyle(color: Colors.cyanAccent, fontSize: 16,fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        );
      },
    );
  }

  // Static method to display an input dialog.
  static void showInputDialog({
    required BuildContext context,
    String title = 'Input',
    String hintText = 'Enter text',
    String confirmButtonText = 'OK',
    String cancelButtonText = 'Cancel',
    required Function(String) onConfirm,
  }) {
    TextEditingController textEditingController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: textEditingController,
            decoration: InputDecoration(hintText: hintText),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(cancelButtonText),
            ),
            TextButton(
              onPressed: () {
                if (onConfirm != null) {
                  onConfirm(textEditingController.text);
                }
                Navigator.of(context).pop();
              },
              child: Text(confirmButtonText),
            ),
          ],
        );
      },
    );
  }

  static void showPrivacyPolicyDialog(BuildContext context) {
    showAnimatedDialog(
        animationType: DialogTransitionType.fadeScale,
        duration: Duration(milliseconds: 350),
        curve: Curves.fastOutSlowIn,
        context: context,
        builder: (BuildContext context) => getPrivacyPolicyDialog(context));
  }

  static Center getPrivacyPolicyDialog(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          insetPadding: EdgeInsets.all(0),
          backgroundColor: Colors.black26,
          title: Center(
            child: Text(
              "Privacy Policy",
              style: TextStyle(fontSize: 22),
            ),
          ),
          content: Text(
            PRIVACY_POLICY,
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  child: Text('Close', style: TextStyle(color: Colors.white)),
                  onPressed: () => Navigator.of(context).pop()),
            ),
          ],
        ),
      ),
    );
  }

}