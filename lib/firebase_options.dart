// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyCUigxH9KJ42CW5elo8Rbi8U8cL_JFpCU8',
    appId: '1:206112462960:web:8fea99ffe8e8b0895a7cb5',
    messagingSenderId: '206112462960',
    projectId: 'apass1bywypm',
    authDomain: 'apass1bywypm.firebaseapp.com',
    storageBucket: 'apass1bywypm.appspot.com',
    measurementId: 'G-0Z0ZK3XKWE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBfsR8Z5P9DU-K9-FWUOkdGWYQFPM3uecA',
    appId: '1:206112462960:android:bfe5c4c324def4d55a7cb5',
    messagingSenderId: '206112462960',
    projectId: 'apass1bywypm',
    storageBucket: 'apass1bywypm.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCETJkIz1VJoQs8l9t4GRYVKKl3G3QELRs',
    appId: '1:206112462960:ios:f1a0f775c5c7170d5a7cb5',
    messagingSenderId: '206112462960',
    projectId: 'apass1bywypm',
    storageBucket: 'apass1bywypm.appspot.com',
    iosBundleId: 'com.example.wypmApdp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCETJkIz1VJoQs8l9t4GRYVKKl3G3QELRs',
    appId: '1:206112462960:ios:f1a0f775c5c7170d5a7cb5',
    messagingSenderId: '206112462960',
    projectId: 'apass1bywypm',
    storageBucket: 'apass1bywypm.appspot.com',
    iosBundleId: 'com.example.wypmApdp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCUigxH9KJ42CW5elo8Rbi8U8cL_JFpCU8',
    appId: '1:206112462960:web:57ce27df22e03f565a7cb5',
    messagingSenderId: '206112462960',
    projectId: 'apass1bywypm',
    authDomain: 'apass1bywypm.firebaseapp.com',
    storageBucket: 'apass1bywypm.appspot.com',
    measurementId: 'G-GRTB5E6L5Y',
  );
}