// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyALD8KiHlFOUuPt8juitzZcj1h1BDqqhiE',
    appId: '1:263414541910:web:22036375380089353c95f7',
    messagingSenderId: '263414541910',
    projectId: 'wave-ai-assistant',
    authDomain: 'wave-ai-assistant.firebaseapp.com',
    storageBucket: 'wave-ai-assistant.appspot.com',
    measurementId: 'G-5RNN21KBFM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDISvW0AdBZ3Y1t0susLh3Hw1X7qOjHcKk',
    appId: '1:263414541910:android:f400bccbc1cb36673c95f7',
    messagingSenderId: '263414541910',
    projectId: 'wave-ai-assistant',
    storageBucket: 'wave-ai-assistant.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC0joYCTiEyRGpU8JBuH4LAS0JrqFkMydc',
    appId: '1:263414541910:ios:8406cf77ff6114773c95f7',
    messagingSenderId: '263414541910',
    projectId: 'wave-ai-assistant',
    storageBucket: 'wave-ai-assistant.appspot.com',
    iosBundleId: 'com.waveaiassistant',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC0joYCTiEyRGpU8JBuH4LAS0JrqFkMydc',
    appId: '1:263414541910:ios:8406cf77ff6114773c95f7',
    messagingSenderId: '263414541910',
    projectId: 'wave-ai-assistant',
    storageBucket: 'wave-ai-assistant.appspot.com',
    iosBundleId: 'com.waveaiassistant',
  );
}
