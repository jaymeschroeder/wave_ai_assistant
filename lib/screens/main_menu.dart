import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wave_ai_assistant/utils/alert_dialog_util.dart';

import '../constants/constants.dart';
import '../providers/auth_provider.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {

// Define the categoryIcons map with IconData and Color
  Map<String, MapEntry<IconData, Color>> categoryIcons = {
    "General Knowledge": const MapEntry(Icons.info, Colors.blue),
    "Education": const MapEntry(Icons.school, Colors.red),
    "Entertainment": const MapEntry(Icons.favorite, Colors.green),
    "Health and Wellness": const MapEntry(Icons.favorite_border, Colors.pink),
    "Technology": const MapEntry(Icons.computer, Colors.orange),
    "Travel and Geography": const MapEntry(Icons.map, Colors.purple),
    "Lifestyle": const MapEntry(Icons.people, Colors.teal),
    "Hobbies and Interests": const MapEntry(Icons.star, Colors.yellow),
    "Business and Finance": const MapEntry(Icons.attach_money, Colors.brown),
    "Legal and Ethical Matters": const MapEntry(Icons.gavel, Colors.indigo),
    "Parenting and Family": const MapEntry(Icons.child_care, Colors.deepOrange),
    "Spirituality and Philosophy": const MapEntry(Icons.accessibility, Colors.amber),
    "Cooking and Food": const MapEntry(Icons.restaurant, Colors.brown),
    "Emergency and Safety Information": const MapEntry(Icons.warning, Colors.red),
    "Language and Translation": const MapEntry(Icons.translate, Colors.blue),
    "Environmental Awareness": const MapEntry(Icons.eco, Colors.green),
    "Gaming and Entertainment": const MapEntry(Icons.gamepad, Colors.indigo),
    "Job and Career": const MapEntry(Icons.work, Colors.blueGrey),
    "Community and Social Interaction": const MapEntry(Icons.group, Colors.teal),
  };

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
              ),
            ),
            backgroundColor: Color(0xFF294E5D).withOpacity(1),
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Align(
                  alignment: Alignment.centerLeft, child: Text(
                "Menu",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              )),
              title: Align(
                alignment: Alignment.bottomLeft,
                child: 
                ElevatedButton(onPressed: () {
                  AlertDialogUtil.showConfirmationDialog(message: "Are you sure you would like to sign out?", onConfirm: authProvider.handleSignOut, context: context);

                  },
                  child: Icon(Icons.menu),)
                
              ),
            ),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return buildGridItem(index);
              },
              childCount: categoryIcons.length, // Adjust this as needed
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGridItem(int index) {
    String category = categoryIcons.keys.elementAt(index);
    MapEntry<IconData, Color> iconEntry = categoryIcons[category] ?? const MapEntry(Icons.category, Colors.black); // Default icon and color

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Material(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: iconEntry.value.withOpacity(1)),
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        color: iconEntry.value.withOpacity(0.2), // Use the specified color as the background
        elevation: 5, // Add elevation and shadow
        child: InkWell(
          onTap: () {

            AlertDialogUtil.showSubcategoryDialog(context, "Select Sub-category", "Please select a sub-category to help ChatGPT suit your needs", "Proceed");
            // Handle the button click here
            print("Grid Item $index clicked!");
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconEntry.key,
                  size: 32, // Adjust the icon size as needed
                  color: iconEntry.value,
                ),
                SizedBox(height: 4), // Add spacing between icon and text
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    category,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}