import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../session/app_session.dart';
import '../supabase/avenue_repository.dart';
import '../supabase/supabase_client.dart';

class ResidentNotificationsController {
  ResidentNotificationsController._() {
    AppSession.instance.currentUserNotifier.addListener(_handleUserChanged);
    _handleUserChanged();
  }

  static final ResidentNotificationsController instance =
      ResidentNotificationsController._();

  final AvenueRepository _repository = AvenueRepository();

  final ValueNotifier<List<Map<String, dynamic>>> rowsNotifier = ValueNotifier(
    const [],
  );
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  final ValueNotifier<int> unreadCountNotifier = ValueNotifier(0);

  StreamSubscription<List<Map<String, dynamic>>>? _subscription;
  String? _activeUserId;

  Future<void> refresh() async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null || currentUser.role != AppRole.resident) {
      _setRows(const []);
      isLoadingNotifier.value = false;
      return;
    }

    isLoadingNotifier.value = true;
    try {
      final rows = await _repository.fetchCurrentUserNotifications();
      _setRows(rows);
    } finally {
      isLoadingNotifier.value = false;
    }
  }

  Future<void> markAllAsRead() async {
    await _repository.markAllCurrentUserNotificationsRead();
    final updatedRows = rowsNotifier.value
        .map((row) => {...row, 'is_unread': false})
        .toList(growable: false);
    _setRows(updatedRows);
  }

  Future<void> _handleUserChanged() async {
    final currentUser = AppSession.instance.currentUser;

    if (currentUser == null || currentUser.role != AppRole.resident) {
      await _stopListening();
      return;
    }

    if (_activeUserId == currentUser.id) {
      return;
    }

    await _startListening(currentUser.id);
  }

  Future<void> _startListening(String userId) async {
    await _stopListening(clearRows: false);

    _activeUserId = userId;
    isLoadingNotifier.value = true;

    _subscription = supabase
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .listen(
          (rows) {
            final castRows = rows
                .map((row) => Map<String, dynamic>.from(row))
                .toList(growable: false);
            _setRows(castRows);
            isLoadingNotifier.value = false;
          },
          onError: (_, error) async {
            await refresh();
          },
        );
  }

  Future<void> _stopListening({bool clearRows = true}) async {
    await _subscription?.cancel();
    _subscription = null;
    _activeUserId = null;
    isLoadingNotifier.value = false;

    if (clearRows) {
      _setRows(const []);
    }
  }

  void _setRows(List<Map<String, dynamic>> rows) {
    rowsNotifier.value = List<Map<String, dynamic>>.unmodifiable(rows);
    unreadCountNotifier.value = rows
        .where((row) => row['is_unread'] == true)
        .length;
  }
}
