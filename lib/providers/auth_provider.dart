import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wave_ai_assistant/services/firebase_service.dart';
import 'package:wave_ai_assistant/services/shared_preferences_service.dart';

// Add the following line to the build method to retrieve state
// final authProvider = Provider.of<AuthProvider>(context);

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookAuth facebookAuth = FacebookAuth.instance;

  String? _anonymousUid;
  User? _user;

  User? get user => _user;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // This method is called when the user logs in
  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  bool isUserLoggedIn() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<User?> handleGoogleSignIn() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      // User is already signed in
      Fluttertoast.showToast(
        msg: "User is already signed in as ${currentUser.displayName}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER_RIGHT,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      return currentUser;
    } else {
      try {
        final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult = await _auth.signInWithCredential(credential);
        final User? user = authResult.user;

        print("${user?.displayName} has been logged in.");

        setUser(user);

        FirebaseService.addUserToFirestore(user!);

        return user;
      } catch (error) {
        print(error);
        return null;
      }
    }
  }

  Future<User?> handleFacebookSignIn() async {
    try {
      final LoginResult loginResult = await facebookAuth.login();
      final AccessToken? accessToken = loginResult.accessToken;
      final AuthCredential credential = FacebookAuthProvider.credential(accessToken!.token);
      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      setUser(user);

      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<User?> signInAnonymously() async {
    // Check if the user is already signed in anonymously
    _anonymousUid = await SharedPreferencesService.getAnonymousUid();

    if (_anonymousUid != null && _anonymousUid != '') {
      try {
        UserCredential authResult = await _auth.signInAnonymously();
        User? user = authResult.user;
        // Check if the newly signed-in user has the same UID as the previously stored one
        if (user?.uid != _anonymousUid) {
          await user?.delete();
          authResult = await _auth.signInAnonymously();
          user = authResult.user;
        }
        setUser(user);
        FirebaseService.updateAnonymousUser(_anonymousUid!, user!.uid);

        _anonymousUid = user?.uid;
        await SharedPreferencesService.setAnonymousUid(_anonymousUid!);
        return user;
      } catch (error) {
        print(error);
        return null;
      }
    } else {
      try {
        UserCredential authResult = await _auth.signInAnonymously();
        User? user = authResult.user;

        FirebaseService.updateAnonymousUser(_anonymousUid!, user!.uid);

        _anonymousUid = user.uid;
        await SharedPreferencesService.setAnonymousUid(_anonymousUid!);
        setUser(user);
        return user;
      } catch (error) {
        print(error);
        return null;
      }
    }
  }

  // This method is called when the user logs out
  Future<User?> handleSignOut() async {
    try {
      if (_user != null) {
        await _auth.signOut();

        try {
          // For Google Sign-In, sign out from GoogleSignIn
          if (await googleSignIn.isSignedIn()) {
            await googleSignIn.signOut();
          }
        } catch (error) {
          print("Google $error");
        }

        try {
          // For Facebook Sign-In, log out from FacebookAuth
          if (await facebookAuth.accessToken != null) {
            await facebookAuth.logOut();
          }
        } catch (error) {
          print("Facebook $error");
        }

        setUser(null); // Set the user to null in your AuthProvider
      }
    } catch (error) {
      print("This is an error $error");
    }

    return _user;
  }
}
