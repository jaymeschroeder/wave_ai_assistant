import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wave_ai_assistant/screens/settings_screen.dart';
import 'package:wave_ai_assistant/screens/translation_screen.dart';
import 'package:wave_ai_assistant/widgets/base_screen_state.dart';

import '../providers/auth_provider.dart';
import '../utils/alert_dialog_util.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/frosted_glass_background.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends BaseScreenState<MainScreen> {
  late AuthProvider authProvider;
  Widget? _currentScreen;

  @override
  void initState() {
    super.initState();

    authProvider = Provider.of<AuthProvider>(context, listen: false);

    _currentScreen = Container();
  }

  @override
  Widget buildScreen(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          /*
          actions: [
            IconButton(
              icon: Icon(Icons.lightbulb, color: ThemeSetting.kColorSecondary,),
              onPressed: () {
                setState(() {
                  ThemeSetting.switchTheme();
                });
              },
            ),
          ],

           */
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.cyan,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          centerTitle: true,
          title: Text(
            'Wave AI',
            style: TextStyle(color: Colors.cyan),
          ),
          backgroundColor: Colors.grey.withOpacity(0.15),
        ),
        body: Stack(children: List<Widget>.from(<Widget?>[_currentScreen, BannerAdWidget()])),
        drawer: Drawer(
          backgroundColor: Colors.black26.withOpacity(0.2),
          child: FrostedGlassBackground(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
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
                    Navigator.pop(context);
                    setState(() {
                      _currentScreen = TranslationScreen();
                    });
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
                    Navigator.pop(context);
                    setState(() {
                      _currentScreen = SettingsScreen();
                    });
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
        )

        /*
        Drawer(
          backgroundColor: ThemeSetting.kBackgroundColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              if (user != null) CustomDrawerHeader(),
              getDrawerRow('Home', Icons.home, Container()),
              getDrawerRow((user?.type == Constants.USER_TYPE_CUST) ? 'Request An Estimate' : 'View Estimate Requests',
                  Icons.sticky_note_2_rounded, EstimateRequestPage(appUser: user)),
              getDrawerRow('Settings', Icons.settings, SettingsPage(appUser: user)),
              // if (user != null && user.type == UserType.Technician.index)... {
              getDrawerRow('History', Icons.folder, HistoryPage(appUser: user)),
              // }
              getDrawerRow('Help', Icons.help, HelpPage()),
              getDrawerRow('Contact Us', Icons.contacts, ContactPage(appUser: user)),

              if (user != null && user.type == Constants.USER_TYPE_CUST) ...{
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Divider(
                    color: Colors.white12,
                    thickness: 1.5,
                    indent: 45,
                    endIndent: 45,
                  ),
                ),
                getDrawerRow('Manage Subscription', Icons.card_membership, SubscriptionPage(user: user),
                    iconColor: Colors.amber),
              },

              Divider(
                color: Colors.white12,
                thickness: 1.5,
                indent: 45,
                endIndent: 45,
              ),
              getDrawerRowAction('Logout', Icons.arrow_back, () {
                AlertDialogUtil.showConfirmationDialog(context, () {
                  Navigator.pop(context);
                  _loginViewModel.signOut();
                  AppUserContainer.of(context).updateUser(null);
                }, content: 'Are you sure you want to sign out?', center: false);
              }),

              GestureDetector(
                onTap: () => AlertDialogUtil.showPrivacyPolicyDialog(context),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: Text(
                        "Privacy Policy",
                        style: ThemeSetting.kBodyText2Small.copyWith(fontSize: 10),
                      ),
                    )),
              )
            ],
          ),
        )

    */
        );
  }
}
