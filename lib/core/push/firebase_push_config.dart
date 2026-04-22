import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

class FirebasePushConfig {
  static const String apiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const String messagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
  );
  static const String projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const String storageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
  );
  static const String iosBundleId = String.fromEnvironment(
    'FIREBASE_IOS_BUNDLE_ID',
  );
  static const String androidAppId = String.fromEnvironment(
    'FIREBASE_ANDROID_APP_ID',
  );
  static const String iosAppId = String.fromEnvironment('FIREBASE_IOS_APP_ID');

  static const String notificationChannelId = 'avenue360_announcements';
  static const String notificationChannelName = 'Avenue360 Alerts';
  static const String notificationChannelDescription =
      'Resident alerts and community announcements';

  static bool get isSupportedPlatform => Platform.isAndroid || Platform.isIOS;

  static bool get isConfiguredForCurrentPlatform {
    if (!isSupportedPlatform) {
      return false;
    }

    final platformAppId = Platform.isIOS ? iosAppId : androidAppId;
    final hasBaseConfig =
        apiKey.isNotEmpty &&
        messagingSenderId.isNotEmpty &&
        projectId.isNotEmpty &&
        platformAppId.isNotEmpty;

    if (!hasBaseConfig) {
      return false;
    }

    if (Platform.isIOS && iosBundleId.isEmpty) {
      return false;
    }

    return true;
  }

  static FirebaseOptions? get options {
    if (!isConfiguredForCurrentPlatform) {
      return null;
    }

    return FirebaseOptions(
      apiKey: apiKey,
      appId: Platform.isIOS ? iosAppId : androidAppId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      storageBucket: storageBucket.isEmpty ? null : storageBucket,
      iosBundleId: Platform.isIOS ? iosBundleId : null,
    );
  }
}
