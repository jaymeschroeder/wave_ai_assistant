import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

class GradientButton extends StatelessWidget {
  final Function onTap;
  final Color iconColor;
  final double buttonSize;

  GradientButton(this.onTap, {super.key, required this.iconColor, required this.buttonSize});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(74),
      highlightColor: Colors.white70.withOpacity(0),
      onTap: () {
        // Handle the button tap here
        onTap();
      },
      child: OutlineGradientButton(
        gradient: LinearGradient(
          colors: [Colors.blue.withOpacity(1), Colors.purpleAccent.withOpacity(1)],
          begin: const Alignment(-1, -1),
          end: const Alignment(2, 2),
        ),
        strokeWidth: 3,
        padding: EdgeInsets.zero,
        radius: Radius.circular(333),
        child: SizedBox(
          width: buttonSize,
          height: buttonSize,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Icon(Icons.touch_app, color: iconColor, size: buttonSize * 0.35),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 18.0),
                child: Text('Tap to speak', style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
