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
    apiKey: 'AIzaSyDdOkP5h5ZqEFmG91HxryDidYDxa8k5guI',
    appId: '1:773255757835:web:7f1dbd6c3244245bc2070e',
    messagingSenderId: '773255757835',
    projectId: 'habitapp-c9814',
    authDomain: 'habitapp-c9814.firebaseapp.com',
    storageBucket: 'habitapp-c9814.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDZQzcov7f6pH7qX91cWPv0fusiyX7rrGM',
    appId: '1:773255757835:android:dd17e09375701ae3c2070e',
    messagingSenderId: '773255757835',
    projectId: 'habitapp-c9814',
    storageBucket: 'habitapp-c9814.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB1B47jDOQobzF7d54nNeKA6TlKkV2FN3o',
    appId: '1:773255757835:ios:c45a0db4fe0cf8d7c2070e',
    messagingSenderId: '773255757835',
    projectId: 'habitapp-c9814',
    storageBucket: 'habitapp-c9814.appspot.com',
    iosBundleId: 'com.example.habitFlow',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB1B47jDOQobzF7d54nNeKA6TlKkV2FN3o',
    appId: '1:773255757835:ios:c45a0db4fe0cf8d7c2070e',
    messagingSenderId: '773255757835',
    projectId: 'habitapp-c9814',
    storageBucket: 'habitapp-c9814.appspot.com',
    iosBundleId: 'com.example.habitFlow',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDdOkP5h5ZqEFmG91HxryDidYDxa8k5guI',
    appId: '1:773255757835:web:330d3ced7017414ec2070e',
    messagingSenderId: '773255757835',
    projectId: 'habitapp-c9814',
    authDomain: 'habitapp-c9814.firebaseapp.com',
    storageBucket: 'habitapp-c9814.appspot.com',
  );
}
