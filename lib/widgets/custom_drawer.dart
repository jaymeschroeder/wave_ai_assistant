import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../providers/auth_provider.dart';
import '../utils/alert_dialog_util.dart';
import 'frosted_glass_background.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
        gradient: LinearGradient(
          begin: Alignment.topLeft, // Define the gradient's start and end points
          end: Alignment.bottomRight,
          colors: [Colors.blue.withOpacity(0.5), Colors.green.withOpacity(0.2)], // Define your gradient colors
        ),
      ),
      child: Drawer(
        backgroundColor: Colors.black26.withOpacity(0.2),
        child: FrostedGlassBackground(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.0),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Spacer(),
                      Text(
                        'Menu',
                        style: TextStyle(
                          fontSize: 48,
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
                      ),
                      Spacer(),
                      Divider(
                        thickness: 0.3,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.translate_rounded,
                  color: Colors.white,
                ),
                title: Text(
                  'Translation',
                  style: TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  // Handle drawer item tap for Home
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.settings_rounded,
                  color: Colors.white,
                ),
                title: Text(
                  'Settings',
                  style: TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  // Handle drawer item tap for Settings
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.chat_rounded,
                  color: Colors.white,
                ),
                title: Text(
                  'Show Text View',
                  style: TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  // Handle drawer item tap for Settings
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  AlertDialogUtil.showConfirmationDialog(
                      message: "Are you sure you would like to sign out?",
                      onConfirm: authProvider.handleSignOut,
                      context: context);
                },
              ),
              // Add more ListTile widgets for additional items
            ],
          ),
        ),
      ),
    );
  }
}
