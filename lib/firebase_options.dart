import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are only configured for Web.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyDRm7FXfFnWEMfywD78bYQQAMl7lkRfe3Y",
    authDomain: "spotify-clone-bbf05.firebaseapp.com",
    projectId: "spotify-clone-bbf05",
    storageBucket: "spotify-clone-bbf05.firebasestorage.app",
    messagingSenderId: "179497767964",
    appId: "1:179497767964:web:b940bc70a7f067d4233bd9",
    measurementId: "G-K9YXWZ4H78",
  );
}
