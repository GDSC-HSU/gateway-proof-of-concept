// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBuGIG5UElMZ4dWuzc4-A7dc0N0E1jxxxx',
    appId: '1:162603779372:web:5147e3e6c5c957bef7d889',
    messagingSenderId: '162603779372',
    projectId: 'gdsc-gateway',
    authDomain: 'gdsc-gateway.firebaseapp.com',
    storageBucket: 'gdsc-gateway.appspot.com',
    measurementId: 'G-M62LMG8557',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBuGIG5UElMZ4dWuzc4-A7dc0N0E1jxxxx',
    appId: '1:162603779372:android:6509d21e2b49e021f7d889',
    messagingSenderId: '162603779372',
    projectId: 'gdsc-gateway',
    storageBucket: 'gdsc-gateway.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBuGIG5UElMZ4dWuzc4-A7dc0N0E1jxxxx',
    appId: '1:162603779372:ios:05c327bd1b044cbdf7d889',
    messagingSenderId: '162603779372',
    projectId: 'gdsc-gateway',
    storageBucket: 'gdsc-gateway.appspot.com',
    iosClientId:
        '162603779372-cn2912tudckk8h672hdrfcioauce656i.apps.googleusercontent.com',
    iosBundleId: 'com.example.pocTfliteAndQr',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBuGIG5UElMZ4dWuzc4-A7dc0N0E1jxxxx',
    appId: '1:162603779372:ios:05c327bd1b044cbdf7d889',
    messagingSenderId: '162603779372',
    projectId: 'gdsc-gateway',
    storageBucket: 'gdsc-gateway.appspot.com',
    iosClientId:
        '162603779372-cn2912tudckk8h672hdrfcioauce656i.apps.googleusercontent.com',
    iosBundleId: 'com.example.pocTfliteAndQr',
  );
}