import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    if (Platform.isAndroid) {
      return android;
    }
    if (Platform.isIOS) {
      return ios;
    }
    if (Platform.isMacOS) {
      return macos;
    }
    return android; // Fallback
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDG6HywB1d98nyN5HbO3pqVVC36_vh8LJI',
    appId: '1:66815410352:android:40afd91897b1a0cb52fb75',
    messagingSenderId: '66815410352',
    projectId: 'campus-share-6accf',
    storageBucket: 'campus-share-6accf.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDG6HywB1d98nyN5HbO3pqVVC36_vh8LJI',
    appId: '1:66815410352:web:campus-share-web',
    messagingSenderId: '66815410352',
    projectId: 'campus-share-6accf',
    authDomain: 'campus-share-6accf.firebaseapp.com',
    storageBucket: 'campus-share-6accf.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDG6HywB1d98nyN5HbO3pqVVC36_vh8LJI',
    appId: '1:66815410352:ios:campus-share-ios',
    messagingSenderId: '66815410352',
    projectId: 'campus-share-6accf',
    storageBucket: 'campus-share-6accf.firebasestorage.app',
    iosBundleId: 'com.example.doctorInfoApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDG6HywB1d98nyN5HbO3pqVVC36_vh8LJI',
    appId: '1:66815410352:macos:campus-share-macos',
    messagingSenderId: '66815410352',
    projectId: 'campus-share-6accf',
    storageBucket: 'campus-share-6accf.firebasestorage.app',
    iosBundleId: 'com.example.doctorInfoApp',
  );
}
