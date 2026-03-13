import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Android configuration from google-services.json
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB1LMOCtn18HAaq7UOKoGFG6C1isUZhCOE',
    appId: '1:799273722522:android:1e5a92e3558235b1107523',
    messagingSenderId: '799273722522',
    projectId: 'charippi-7c315',
    storageBucket: 'charippi-7c315.firebasestorage.app',
  );

  // Web configuration - needs to be added from Firebase Console
  // Go to: Firebase Console > Project Settings > General > Web App > Add App
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB1LMOCtn18HAaq7UOKoGFG6C1isUZhCOE',
    appId: '1:799273722522:web:charippi7c315web',
    messagingSenderId: '799273722522',
    projectId: 'charippi-7c315',
    storageBucket: 'charippi-7c315.firebasestorage.app',
    authDomain: 'charippi-7c315.firebaseapp.com',
  );

  // iOS configuration - placeholder for future use
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB1LMOCtn18HAaq7UOKoGFG6C1isUZhCOE',
    appId: '1:799273722522:ios:charippi7c315ios',
    messagingSenderId: '799273722522',
    projectId: 'charippi-7c315',
    storageBucket: 'charippi-7c315.firebasestorage.app',
    iosBundleId: 'com.cycleguard.safety',
  );
}
