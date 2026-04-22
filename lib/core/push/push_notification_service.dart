import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../session/app_session.dart';
import '../supabase/avenue_repository.dart';
import 'firebase_push_config.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final options = FirebasePushConfig.options;
  if (options != null && Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: options);
  }
}

class PushNotificationService {
  PushNotificationService._();

  static final PushNotificationService instance = PushNotificationService._();

  final AvenueRepository _repository = AvenueRepository();
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _foregroundMessageSubscription;
  bool _initialized = false;
  String? _lastRegisteredToken;
  String? _lastRegisteredUserId;

  Future<void> initialize() async {
    if (_initialized || !FirebasePushConfig.isConfiguredForCurrentPlatform) {
      return;
    }

    final options = FirebasePushConfig.options;
    if (options == null) {
      return;
    }

    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: options);
    }

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _initializeLocalNotifications();

    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _foregroundMessageSubscription = FirebaseMessaging.onMessage.listen(
      _showForegroundNotification,
    );
    _tokenRefreshSubscription = messaging.onTokenRefresh.listen(_registerToken);

    AppSession.instance.currentUserNotifier.addListener(_handleUserChanged);
    _initialized = true;

    await _syncCurrentToken();
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(settings);

    if (Platform.isAndroid) {
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          FirebasePushConfig.notificationChannelId,
          FirebasePushConfig.notificationChannelName,
          description: FirebasePushConfig.notificationChannelDescription,
          importance: Importance.max,
        ),
      );
    }
  }

  Future<void> _handleUserChanged() async {
    _lastRegisteredToken = null;
    _lastRegisteredUserId = null;
    await _syncCurrentToken();
  }

  Future<void> _syncCurrentToken() async {
    if (!_initialized) {
      return;
    }

    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    final token = await FirebaseMessaging.instance.getToken();
    if (token == null || token.isEmpty) {
      return;
    }

    await _registerToken(token);
  }

  Future<void> _registerToken(String token) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    if (_lastRegisteredToken == token &&
        _lastRegisteredUserId == currentUser.id) {
      return;
    }

    final platform = Platform.isIOS ? 'ios' : 'android';

    await _repository.registerDevicePushToken(
      token: token,
      platform: platform,
      deviceLabel: defaultTargetPlatform.name,
    );

    _lastRegisteredToken = token;
    _lastRegisteredUserId = currentUser.id;
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) {
      return;
    }

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          FirebasePushConfig.notificationChannelId,
          FirebasePushConfig.notificationChannelName,
          channelDescription: FirebasePushConfig.notificationChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    await _foregroundMessageSubscription?.cancel();
  }
}
