import 'dart:typed_data';

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

  Future<List<Map<String, dynamic>>> fetchCommunitySuggestions() async {
    final rows = await _client
        .from('community_suggestion_feed_v')
        .select()
        .order('created_at', ascending: false);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchAdminCommunitySuggestions() async {
    final rows = await _client
        .from('admin_community_suggestion_feed_v')
        .select()
        .order('created_at', ascending: false);

    return _castRows(rows);
  }

  Future<Map<String, dynamic>?> fetchCommunitySuggestion(
    String suggestionId,
  ) async {
    final rows = await _client
        .from('community_suggestion_feed_v')
        .select()
        .eq('id', suggestionId)
        .limit(1);

    final records = _castRows(rows);
    if (records.isEmpty) {
      return null;
    }

    return records.first;
  }

  Future<List<Map<String, dynamic>>> fetchCommunitySuggestionComments(
    String suggestionId,
  ) async {
    final rows = await _client
        .from('community_suggestion_comments_v')
        .select()
        .eq('suggestion_id', suggestionId)
        .order('created_at', ascending: true);

    return _castRows(rows);
  }

  Future<bool> isCurrentUserCommunitySuggestionMember(
    String suggestionId,
  ) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return false;
    }

    final rows = await _client
        .from('community_suggestion_members')
        .select('suggestion_id')
        .eq('suggestion_id', suggestionId)
        .eq('user_id', currentUser.id)
        .limit(1);

    return _castRows(rows).isNotEmpty;
  }

  Future<Map<String, dynamic>?> joinCommunitySuggestion({
    required String suggestionId,
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'join_community_suggestion',
      params: {'p_user_id': currentUser.id, 'p_suggestion_id': suggestionId},
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(response.first as Map);
  }

  Future<Map<String, dynamic>?> createCommunitySuggestion({
    required String title,
    required String category,
    required String summary,
    required String details,
    String audienceScope = 'all_residents',
    bool pollEnabled = true,
    int targetVotes = 24,
    String? coverImageUrl,
    String iconName = 'lightbulb',
    String accentHex = '#005BBF',
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'create_community_suggestion',
      params: {
        'p_user_id': currentUser.id,
        'p_title': title.trim(),
        'p_category': category.trim(),
        'p_summary': summary.trim(),
        'p_details': details.trim(),
        'p_audience_scope': audienceScope,
        'p_poll_enabled': pollEnabled,
        'p_target_votes': targetVotes,
        'p_cover_image_url': coverImageUrl?.trim(),
        'p_icon_name': iconName,
        'p_accent_hex': accentHex,
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(response.first as Map);
  }

  Future<Map<String, dynamic>?> addCommunitySuggestionComment({
    required String suggestionId,
    required String body,
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'add_community_suggestion_comment',
      params: {
        'p_user_id': currentUser.id,
        'p_suggestion_id': suggestionId,
        'p_body': body.trim(),
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(response.first as Map);
  }

  Future<Map<String, dynamic>?> reviewCommunitySuggestion({
    required String suggestionId,
    required String decision,
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'review_community_suggestion',
      params: {
        'p_admin_user_id': currentUser.id,
        'p_suggestion_id': suggestionId,
        'p_decision': decision,
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(response.first as Map);
  }

  Future<Map<String, dynamic>?> voteCommunitySuggestion({
    required String suggestionId,
    required String voteKind,
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'vote_community_suggestion',
      params: {
        'p_user_id': currentUser.id,
        'p_suggestion_id': suggestionId,
        'p_vote_kind': voteKind,
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(response.first as Map);
  }

  Future<List<Map<String, dynamic>>> fetchCommunityMeetings() async {
    final rows = await _client
        .from('community_meetings')
        .select()
        .order('meeting_date', ascending: false);

    return _castRows(rows);
  }

  Future<Map<String, dynamic>?> fetchCommunityMeeting(String meetingId) async {
    final rows = await _client
        .from('community_meetings')
        .select()
        .eq('id', meetingId)
        .limit(1);

    final records = _castRows(rows);
    if (records.isEmpty) {
      return null;
    }

    return records.first;
  }

  Future<List<Map<String, dynamic>>> fetchCommunitySupportFaqs() async {
    final rows = await _client
        .from('community_support_faqs')
        .select()
        .order('sort_order', ascending: true)
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

  Future<List<Map<String, dynamic>>> fetchAdminComplaints() async {
    final rows = await _client
        .from('admin_complaints_v')
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
    required String category,
    required String title,
    required String description,
    required String urgency,
    required String iconName,
    required String accentHex,
    String? locationLabel,
    String? preferredAccessTime,
    String? photoUrl,
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'create_resident_complaint',
      params: {
        'p_user_id': currentUser.id,
        'p_category': category.trim().toLowerCase(),
        'p_title': title.trim(),
        'p_description': description.trim(),
        'p_location_label': locationLabel?.trim(),
        'p_urgency': urgency.trim().toLowerCase(),
        'p_preferred_access_time': preferredAccessTime?.trim(),
        'p_photo_url': photoUrl?.trim(),
        'p_icon_name': iconName,
        'p_accent_hex': accentHex,
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(response.first as Map);
  }

  Future<String?> uploadComplaintPhoto({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null || bytes.isEmpty) {
      return null;
    }

    final cleanedName = fileName.trim().replaceAll(
      RegExp(r'[^a-zA-Z0-9._-]'),
      '_',
    );
    final safeName = cleanedName.isEmpty ? 'complaint-photo.jpg' : cleanedName;
    final storagePath =
        '${currentUser.id}/${DateTime.now().millisecondsSinceEpoch}_$safeName';

    await _client.storage
        .from('complaint-photos')
        .uploadBinary(
          storagePath,
          bytes,
          fileOptions: FileOptions(
            contentType: _contentTypeForFileName(safeName),
            upsert: false,
          ),
        );

    return _client.storage.from('complaint-photos').getPublicUrl(storagePath);
  }

  Future<Map<String, dynamic>?> updateAdminComplaintStatus({
    required String complaintId,
    required String state,
    String? assignedTo,
    String? adminNotes,
    String? resolutionNote,
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'update_complaint_admin_status',
      params: {
        'p_admin_user_id': currentUser.id,
        'p_complaint_id': complaintId,
        'p_state': state,
        'p_assigned_to': assignedTo?.trim(),
        'p_admin_notes': adminNotes?.trim(),
        'p_resolution_note': resolutionNote?.trim(),
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

  Future<Map<String, dynamic>?> createGuardVisitorEntry({
    required String visitorName,
    required String unitNumber,
    required String purpose,
    String? phone,
    String visitorKind = 'guest',
    String decision = 'approved',
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'create_guard_visitor_entry',
      params: {
        'p_guard_user_id': currentUser.id,
        'p_visitor_name': visitorName.trim(),
        'p_unit_number': unitNumber.trim(),
        'p_purpose': purpose.trim(),
        'p_phone': phone?.trim(),
        'p_visitor_kind': visitorKind,
        'p_decision': decision,
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(response.first as Map);
  }

  Future<Map<String, dynamic>?> processGuardVisitorPass({
    required String passId,
    required String decision,
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'process_guard_visitor_pass',
      params: {
        'p_guard_user_id': currentUser.id,
        'p_pass_id': passId,
        'p_decision': decision,
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(response.first as Map);
  }

  Future<Map<String, dynamic>?> processGuardQrEntry({
    required String code,
    String decision = 'approved',
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'process_guard_qr_entry',
      params: {
        'p_guard_user_id': currentUser.id,
        'p_code': code.trim(),
        'p_decision': decision,
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(response.first as Map);
  }

  List<Map<String, dynamic>> _castRows(dynamic rows) {
    if (rows is! List) {
      return const [];
    }

    return rows.map((row) => Map<String, dynamic>.from(row as Map)).toList();
  }

  String _contentTypeForFileName(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.png')) {
      return 'image/png';
    }
    if (lower.endsWith('.webp')) {
      return 'image/webp';
    }
    if (lower.endsWith('.gif')) {
      return 'image/gif';
    }
    return 'image/jpeg';
  }
}
