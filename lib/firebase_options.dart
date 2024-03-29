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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCu71lMGtaPnZbTMQf1DXHblSuCgpLYTmA',
    appId: '1:1088647408284:web:a17c73b8e68f15046e9b59',
    messagingSenderId: '1088647408284',
    projectId: 'interview-task-fc4e5',
    authDomain: 'interview-task-fc4e5.firebaseapp.com',
    storageBucket: 'interview-task-fc4e5.appspot.com',
    measurementId: 'G-PK1T9L8XBY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCbwzGByqsTkdXjvhr-q-kfpAhsje2oSZ4',
    appId: '1:1088647408284:android:f67459ae2a831af66e9b59',
    messagingSenderId: '1088647408284',
    projectId: 'interview-task-fc4e5',
    storageBucket: 'interview-task-fc4e5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBY616h2fqAhoRrvgesivO9Tr7sHvti1ZU',
    appId: '1:1088647408284:ios:e7eaaee8491842d66e9b59',
    messagingSenderId: '1088647408284',
    projectId: 'interview-task-fc4e5',
    storageBucket: 'interview-task-fc4e5.appspot.com',
    androidClientId: '1088647408284-71bhn1ln8m12vlqfgjs8ncnok5anbeb6.apps.googleusercontent.com',
    iosClientId: '1088647408284-i4gqr6fnfg345vcbge6d5tlb262m8sat.apps.googleusercontent.com',
    iosBundleId: 'com.example.interviewTask',
  );
}
