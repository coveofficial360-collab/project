import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/app_user.dart';
import '../session/app_session.dart';
import 'supabase_client.dart';

class AvenueRepository {
  AvenueRepository({SupabaseClient? client}) : _client = client ?? supabase;

  final SupabaseClient _client;

  Future<AppUser?> authenticate({
    required String email,
    required String password,
    required AppRole role,
  }) async {
    final response = await _client.rpc(
      'authenticate_app_user',
      params: {
        'p_email': email.trim().toLowerCase(),
        'p_password': password,
        'p_role': role.dbValue,
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    final row = Map<String, dynamic>.from(response.first as Map);
    return AppUser.fromAuthRow(row);
  }

  Future<AppUser?> fetchCurrentUserProfile() async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final row = await _client
        .from('app_users')
        .select(
          'id, email, full_name, status, unit_number, tower, phone, avatar_url, job_title',
        )
        .eq('id', currentUser.id)
        .single();

    return AppUser.fromProfileRow(
      Map<String, dynamic>.from(row),
      currentUser.role,
    );
  }

  Future<List<Map<String, dynamic>>> fetchCurrentUserBills() async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return const [];
    }

    final rows = await _client
        .from('bills')
        .select()
        .eq('user_id', currentUser.id)
        .order('due_date', ascending: true);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchAmenities() async {
    final rows = await _client
        .from('amenities')
        .select()
        .order('created_at', ascending: true);

    return _castRows(rows);
  }

  Future<Map<String, dynamic>?> fetchAmenityByCode(String code) async {
    final rows = await _client
        .from('amenities')
        .select()
        .eq('code', code)
        .limit(1);
    final records = _castRows(rows);
    if (records.isEmpty) {
      return null;
    }

    return records.first;
  }

  Future<List<Map<String, dynamic>>> fetchCurrentUserAmenityBookings() async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return const [];
    }

    final rows = await _client
        .from('amenity_bookings')
        .select('*, amenities(name, code, location_label, image_url)')
        .eq('user_id', currentUser.id)
        .order('booking_date', ascending: true);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchNotices({int limit = 10}) async {
    final rows = await _client
        .from('notices')
        .select()
        .order('posted_at', ascending: false)
        .limit(limit);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchCurrentUserPaymentMethods() async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return const [];
    }

    final rows = await _client
        .from('payment_methods')
        .select()
        .eq('user_id', currentUser.id)
        .order('is_primary', ascending: false)
        .order('created_at', ascending: true);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchCurrentUserPaymentActivity() async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return const [];
    }

    final rows = await _client
        .from('payment_activity')
        .select()
        .eq('user_id', currentUser.id)
        .order('activity_at', ascending: false);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchCurrentUserComplaints() async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return const [];
    }

    final rows = await _client
        .from('complaints')
        .select()
        .eq('user_id', currentUser.id)
        .order('created_at', ascending: false);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchCurrentUserNotifications() async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return const [];
    }

    final rows = await _client
        .from('notifications')
        .select()
        .eq('user_id', currentUser.id)
        .order('created_at', ascending: false);

    return _castRows(rows);
  }

  Future<void> markAllCurrentUserNotificationsRead() async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    await _client
        .from('notifications')
        .update({'is_unread': false})
        .eq('user_id', currentUser.id)
        .eq('is_unread', true);
  }

  Future<void> registerDevicePushToken({
    required String token,
    required String platform,
    String? deviceLabel,
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    await _client.rpc(
      'register_device_push_token',
      params: {
        'p_user_id': currentUser.id,
        'p_fcm_token': token,
        'p_platform': platform,
        'p_device_label': deviceLabel,
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchCurrentUserVisitorPasses() async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return const [];
    }

    final rows = await _client
        .from('visitor_passes')
        .select()
        .eq('resident_user_id', currentUser.id)
        .order('expected_arrival', ascending: true);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchHouseholdMembers() async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return const [];
    }

    final rows = await _client
        .from('household_members')
        .select()
        .eq('user_id', currentUser.id)
        .order('created_at', ascending: true);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchVehicles() async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return const [];
    }

    final rows = await _client
        .from('vehicles')
        .select()
        .eq('user_id', currentUser.id)
        .order('created_at', ascending: true);

    return _castRows(rows);
  }

  Future<Map<String, dynamic>?> fetchAdminMetrics() async {
    final rows = await _client
        .from('admin_dashboard_metrics_v')
        .select()
        .limit(1);
    final records = rows as List<dynamic>;
    if (records.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(records.first as Map);
  }

  Future<List<Map<String, dynamic>>> fetchAdminTransactions() async {
    final rows = await _client
        .from('admin_transactions')
        .select()
        .order('created_at', ascending: false);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchAnnouncements() async {
    final rows = await _client
        .from('announcements')
        .select()
        .order('created_at', ascending: false);

    return _castRows(rows);
  }

  Future<Map<String, dynamic>?> createResident({
    required String email,
    required String fullName,
    required String phone,
    required String unitNumber,
    required String residentKind,
    String tempPassword = 'welcome123',
  }) async {
    final response = await _client.rpc(
      'create_resident_app_user',
      params: {
        'p_email': email.trim().toLowerCase(),
        'p_full_name': fullName.trim(),
        'p_phone': phone.trim(),
        'p_unit_number': unitNumber.trim(),
        'p_resident_kind': residentKind,
        'p_temp_password': tempPassword,
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(response.first as Map);
  }

  Future<Map<String, dynamic>?> createVisitorPass({
    required String visitorName,
    required String phone,
    required String visitorKind,
    required DateTime expectedArrival,
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'create_visitor_pass',
      params: {
        'p_resident_user_id': currentUser.id,
        'p_visitor_name': visitorName.trim(),
        'p_phone': phone.trim(),
        'p_visitor_kind': visitorKind,
        'p_expected_arrival': expectedArrival.toIso8601String(),
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(response.first as Map);
  }

  Future<Map<String, dynamic>?> createComplaint({
    required String title,
    required String description,
    required String iconName,
    required String accentHex,
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'create_resident_complaint',
      params: {
        'p_user_id': currentUser.id,
        'p_title': title.trim(),
        'p_description': description.trim(),
        'p_icon_name': iconName,
        'p_accent_hex': accentHex,
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(response.first as Map);
  }

  Future<Map<String, dynamic>?> createAnnouncement({
    required String kind,
    required String title,
    required String body,
    required String targetAudience,
    String state = 'sent',
    DateTime? scheduledFor,
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'create_announcement',
      params: {
        'p_created_by': currentUser.id,
        'p_kind': kind,
        'p_title': title.trim(),
        'p_body': body.trim(),
        'p_target_audience': targetAudience.trim(),
        'p_state': state,
        'p_scheduled_for': scheduledFor?.toIso8601String(),
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(response.first as Map);
  }

  Future<Map<String, dynamic>?> sendAnnouncementPush({
    required String announcementId,
  }) async {
    final response = await _client.functions.invoke(
      'send-announcement-push',
      body: {'announcement_id': announcementId},
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    return null;
  }

  Future<List<Map<String, dynamic>>> fetchResidentDirectory() async {
    final rows = await _client
        .from('resident_directory_v')
        .select()
        .order('full_name', ascending: true);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchGuardGateActivities() async {
    final rows = await _client
        .from('guard_gate_activity_v')
        .select()
        .order('expected_arrival', ascending: true);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchGuardDutyLogs() async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return const [];
    }

    final rows = await _client
        .from('guard_duty_logs')
        .select()
        .eq('guard_user_id', currentUser.id)
        .order('logged_at', ascending: false);

    return _castRows(rows);
  }

  List<Map<String, dynamic>> _castRows(dynamic rows) {
    if (rows is! List) {
      return const [];
    }

    return rows.map((row) => Map<String, dynamic>.from(row as Map)).toList();
  }
}
