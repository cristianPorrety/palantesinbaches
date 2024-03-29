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
    apiKey: 'AIzaSyAfX8uqiqS85yVazdWB6YjwNQg7WzAE_G4',
    appId: '1:567287834916:web:6ff14f3fb3e1f7e963ebb1',
    messagingSenderId: '567287834916',
    projectId: 'pilasconelhueco-60b96',
    authDomain: 'pilasconelhueco-60b96.firebaseapp.com',
    storageBucket: 'pilasconelhueco-60b96.appspot.com',
    measurementId: 'G-WXTYF1TXE3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCqPiSmL5s0JLalY8vvbrzvHYIY3nRMtVg',
    appId: '1:567287834916:android:eb9fe0b3d49a405763ebb1',
    messagingSenderId: '567287834916',
    projectId: 'pilasconelhueco-60b96',
    storageBucket: 'pilasconelhueco-60b96.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDpYQZo3ecO8xJ1Q_qIaqqTWqokGej8kCw',
    appId: '1:567287834916:ios:a28b3c1cd47a30d363ebb1',
    messagingSenderId: '567287834916',
    projectId: 'pilasconelhueco-60b96',
    storageBucket: 'pilasconelhueco-60b96.appspot.com',
    iosBundleId: 'com.example.pilasconelhueco',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDpYQZo3ecO8xJ1Q_qIaqqTWqokGej8kCw',
    appId: '1:567287834916:ios:2312fa88beedba9763ebb1',
    messagingSenderId: '567287834916',
    projectId: 'pilasconelhueco-60b96',
    storageBucket: 'pilasconelhueco-60b96.appspot.com',
    iosBundleId: 'com.example.pilasconelhueco.RunnerTests',
  );
}
