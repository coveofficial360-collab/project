import 'package:flutter/foundation.dart';

import '../models/app_user.dart';

class AppSession {
  AppSession._();

  static final AppSession instance = AppSession._();

  final ValueNotifier<AppUser?> currentUserNotifier = ValueNotifier<AppUser?>(
    null,
  );

  AppUser? get currentUser => currentUserNotifier.value;

  bool get isLoggedIn => currentUser != null;

  void setCurrentUser(AppUser user) {
    currentUserNotifier.value = user;
  }

  void clear() {
    currentUserNotifier.value = null;
  }
}
