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

  Future<List<Map<String, dynamic>>> fetchCurrentUserMaintenanceBills() async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return const [];
    }

    final rows = await _client
        .from('bills')
        .select()
        .eq('user_id', currentUser.id)
        .ilike('category', 'maintenance')
        .order('due_date', ascending: true)
        .order('created_at', ascending: false);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchAmenities() async {
    final rows = await _client
        .from('amenities')
        .select()
        .order('sort_order', ascending: true)
        .order('created_at', ascending: true);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchAmenityTimeSlots(
    String amenityId,
  ) async {
    final rows = await _client
        .from('amenity_time_slots')
        .select()
        .eq('amenity_id', amenityId)
        .order('sort_order', ascending: true)
        .order('start_time', ascending: true);

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
        .filter('booking_status', 'in', '(confirmed,pending)')
        .order('booking_date', ascending: true);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchAdminAmenityBookings() async {
    final rows = await _client
        .from('admin_amenity_bookings_v')
        .select()
        .order('booking_date', ascending: false);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchServiceProviders() async {
    final rows = await _client
        .from('service_providers')
        .select()
        .order('is_featured', ascending: false)
        .order('rating', ascending: false)
        .order('jobs_completed', ascending: false)
        .order('created_at', ascending: false);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchResidentServiceProviders() async {
    final rows = await _client
        .from('service_providers')
        .select()
        .eq('is_featured', true)
        .order('rating', ascending: false)
        .order('jobs_completed', ascending: false)
        .order('created_at', ascending: false);

    return _castRows(rows);
  }

  Future<Map<String, dynamic>?> fetchResidentServiceProviderById(
    String providerId,
  ) async {
    final rows = await _client
        .from('service_providers')
        .select()
        .eq('id', providerId)
        .limit(1);

    final records = _castRows(rows);
    if (records.isEmpty) {
      return null;
    }

    return records.first;
  }

  Future<List<Map<String, dynamic>>> fetchTreasurerDashboardMetrics() async {
    final rows = await _client
        .from('admin_treasurer_dashboard_v')
        .select()
        .limit(1);

    final records = _castRows(rows);
    if (records.isEmpty) {
      return const [];
    }

    return records;
  }

  Future<List<Map<String, dynamic>>> fetchFinanceVendors() async {
    final rows = await _client
        .from('admin_vendor_directory_v')
        .select()
        .order('contract_end_date', ascending: true)
        .order('company_name', ascending: true);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchTreasurerExpenses() async {
    final rows = await _client
        .from('admin_expense_management_v')
        .select()
        .order('expense_date', ascending: false)
        .order('created_at', ascending: false);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchFinancialMonthlySummary() async {
    final rows = await _client
        .from('admin_financial_monthly_summary_v')
        .select()
        .order('month_bucket', ascending: true);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchVendorComparisonRows() async {
    final rows = await _client
        .from('admin_vendor_comparison_v')
        .select()
        .order('is_best_value', ascending: false)
        .order('service_rating', ascending: false);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchVendorContractHistory(
    String vendorId,
  ) async {
    final rows = await _client
        .from('vendor_contract_history')
        .select()
        .eq('vendor_id', vendorId)
        .order('start_date', ascending: false);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchVendorQuotationRequests() async {
    final rows = await _client
        .from('vendor_quotation_requests')
        .select()
        .order('created_at', ascending: false);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchRequestInvitedVendors(
    String requestId,
  ) async {
    final rows = await _client
        .from('vendor_quotation_request_vendors')
        .select('*, finance_vendors(*)')
        .eq('request_id', requestId);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchRequestQuotations(
    String requestId,
  ) async {
    final rows = await _client
        .from('vendor_quotations')
        .select('*, finance_vendors(*)')
        .eq('request_id', requestId)
        .order('is_best_value', ascending: false)
        .order('quoted_amount', ascending: true)
        .order('created_at', ascending: false);

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
    final currentUser = AppSession.instance.currentUser;
    final rows = await _client
        .from('community_suggestion_feed_v')
        .select()
        .order('created_at', ascending: false);

    final records = _castRows(rows);
    if (currentUser == null) {
      return records;
    }

    final targetedRows = records
        .where(
          (row) =>
              (row['audience_scope']?.toString().toLowerCase() ?? '') ==
              'selected_residents',
        )
        .toList();
    if (targetedRows.isEmpty) {
      return records;
    }

    final targetAudienceRows = await _client
        .from('community_suggestion_target_residents')
        .select('suggestion_id')
        .eq('resident_user_id', currentUser.id);
    final allowedSuggestionIds = _castRows(targetAudienceRows)
        .map((row) => row['suggestion_id']?.toString())
        .whereType<String>()
        .toSet();

    final visibleRecords = records.where((row) {
      final audienceScope =
          row['audience_scope']?.toString().toLowerCase() ?? 'all_residents';
      if (audienceScope != 'selected_residents') {
        return true;
      }

      final suggestionId = row['id']?.toString();
      final createdBy = row['created_by']?.toString();
      return (suggestionId != null &&
              allowedSuggestionIds.contains(suggestionId)) ||
          createdBy == currentUser.id;
    }).toList();

    if (visibleRecords.isEmpty) {
      return visibleRecords;
    }

    final joinedRows = await _client
        .from('community_suggestion_members')
        .select('suggestion_id')
        .eq('user_id', currentUser.id);
    final joinedSuggestionIds = _castRows(joinedRows)
        .map((row) => row['suggestion_id']?.toString())
        .whereType<String>()
        .toSet();

    return visibleRecords.map((row) {
      final next = Map<String, dynamic>.from(row);
      final suggestionId = next['id']?.toString();
      final createdBy = next['created_by']?.toString();
      next['has_joined'] =
          (suggestionId != null &&
              joinedSuggestionIds.contains(suggestionId)) ||
          createdBy == currentUser.id;
      return next;
    }).toList();
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

    final membershipRows = await _client
        .from('community_suggestion_members')
        .select('suggestion_id')
        .eq('suggestion_id', suggestionId)
        .eq('user_id', currentUser.id)
        .limit(1);

    if (_castRows(membershipRows).isNotEmpty) {
      return true;
    }

    final creatorRows = await _client
        .from('community_suggestions')
        .select('id')
        .eq('id', suggestionId)
        .eq('created_by', currentUser.id)
        .limit(1);

    return _castRows(creatorRows).isNotEmpty;
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
    List<String> selectedResidentIds = const [],
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
        'p_selected_resident_ids': selectedResidentIds,
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

  Future<List<Map<String, dynamic>>> fetchAdminMaintenanceResidentLog() async {
    final rows = await _client
        .from('admin_maintenance_resident_log_v')
        .select()
        .order('due_date', ascending: true);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchMaintenanceBillsForResident(
    String residentUserId,
  ) async {
    final rows = await _client
        .from('bills')
        .select()
        .eq('user_id', residentUserId)
        .ilike('category', 'maintenance')
        .order('due_date', ascending: false)
        .order('created_at', ascending: false);

    return _castRows(rows);
  }

  Future<List<Map<String, dynamic>>> fetchMaintenancePaymentHistoryForResident(
    String residentUserId,
  ) async {
    final rows = await _client
        .from('payment_activity')
        .select()
        .eq('user_id', residentUserId)
        .ilike('activity_category', 'maintenance')
        .order('activity_at', ascending: false);

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

  Future<Map<String, dynamic>?> createAmenityBooking({
    required String amenityId,
    required DateTime bookingDate,
    required String timeSlot,
    required int guestCount,
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'create_amenity_booking',
      params: {
        'p_user_id': currentUser.id,
        'p_amenity_id': amenityId,
        'p_booking_date': bookingDate.toIso8601String().split('T').first,
        'p_time_slot': timeSlot.trim(),
        'p_guest_count': guestCount,
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(response.first as Map);
  }

  Future<Map<String, dynamic>?> payMaintenanceBill({
    required String billId,
    String paymentMethod = 'UPI',
    String? transactionRef,
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'pay_maintenance_bill',
      params: {
        'p_user_id': currentUser.id,
        'p_bill_id': billId,
        'p_payment_method': paymentMethod,
        'p_transaction_ref': transactionRef,
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(response.first as Map);
  }

  Future<Map<String, dynamic>?> createAdminAmenity({
    required String name,
    required String category,
    required String description,
    required String locationLabel,
    required String statusLabel,
    required String availabilityText,
    required String occupancyNote,
    required int capacityPercent,
    required bool bookingRequired,
    String? imageUrl,
    String? accessNote,
    List<String> rules = const [],
    List<Map<String, dynamic>> timeSlots = const [],
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'create_admin_amenity',
      params: {
        'p_admin_user_id': currentUser.id,
        'p_name': name.trim(),
        'p_category': category.trim(),
        'p_description': description.trim(),
        'p_location_label': locationLabel.trim(),
        'p_status_label': statusLabel.trim(),
        'p_availability_text': availabilityText.trim(),
        'p_occupancy_note': occupancyNote.trim(),
        'p_capacity_percent': capacityPercent,
        'p_booking_required': bookingRequired,
        'p_image_url': imageUrl?.trim(),
        'p_access_note': accessNote?.trim(),
        'p_rules': rules,
        'p_time_slots': timeSlots,
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(response.first as Map);
  }

  Future<Map<String, dynamic>?> updateAdminAmenity({
    required String amenityId,
    required String name,
    required String category,
    required String description,
    required String locationLabel,
    required String statusLabel,
    required String availabilityText,
    required String occupancyNote,
    required int capacityPercent,
    required bool bookingRequired,
    String? imageUrl,
    String? accessNote,
    List<String> rules = const [],
    List<Map<String, dynamic>> timeSlots = const [],
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'update_admin_amenity',
      params: {
        'p_admin_user_id': currentUser.id,
        'p_amenity_id': amenityId,
        'p_name': name.trim(),
        'p_category': category.trim(),
        'p_description': description.trim(),
        'p_location_label': locationLabel.trim(),
        'p_status_label': statusLabel.trim(),
        'p_availability_text': availabilityText.trim(),
        'p_occupancy_note': occupancyNote.trim(),
        'p_capacity_percent': capacityPercent,
        'p_booking_required': bookingRequired,
        'p_image_url': imageUrl?.trim(),
        'p_access_note': accessNote?.trim(),
        'p_rules': rules,
        'p_time_slots': timeSlots,
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(response.first as Map);
  }

  Future<Map<String, dynamic>?> updateAdminAmenityStatus({
    required String amenityId,
    required String statusLabel,
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'update_admin_amenity_status',
      params: {
        'p_admin_user_id': currentUser.id,
        'p_amenity_id': amenityId,
        'p_status_label': statusLabel.trim(),
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(response.first as Map);
  }

  Future<Map<String, dynamic>?> createServiceProvider({
    required String fullName,
    required String specialty,
    required String phone,
    required String experienceLabel,
    required String availabilityStatus,
    String? notes,
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'create_admin_service_provider',
      params: {
        'p_admin_user_id': currentUser.id,
        'p_full_name': fullName.trim(),
        'p_specialty': specialty.trim(),
        'p_phone': phone.trim(),
        'p_experience_label': experienceLabel.trim(),
        'p_availability_status': availabilityStatus.trim(),
        'p_notes': notes?.trim(),
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

  Future<Map<String, dynamic>?> createFinanceVendor({
    required String companyName,
    required String contactName,
    required String phone,
    String? email,
    String? address,
    String serviceType = 'General',
    String? serviceScope,
    String? gstin,
    String? licenseNumber,
    double monthlyCost = 0,
    double? hourlyRate,
    int staffCount = 0,
    String onboardingStatus = 'active',
    DateTime? contractStartDate,
    DateTime? contractEndDate,
    String? serviceAgreementUrl,
    String? notes,
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'create_finance_vendor',
      params: {
        'p_admin_user_id': currentUser.id,
        'p_company_name': companyName.trim(),
        'p_contact_name': contactName.trim(),
        'p_phone': phone.trim(),
        'p_email': email?.trim(),
        'p_address': address?.trim(),
        'p_service_type': serviceType.trim(),
        'p_service_scope': serviceScope?.trim(),
        'p_gstin': gstin?.trim(),
        'p_license_number': licenseNumber?.trim(),
        'p_monthly_cost': monthlyCost,
        'p_hourly_rate': hourlyRate,
        'p_staff_count': staffCount,
        'p_onboarding_status': onboardingStatus,
        'p_contract_start_date': contractStartDate?.toIso8601String().split('T').first,
        'p_contract_end_date': contractEndDate?.toIso8601String().split('T').first,
        'p_service_agreement_url': serviceAgreementUrl?.trim(),
        'p_notes': notes?.trim(),
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(response.first as Map);
  }

  Future<Map<String, dynamic>?> createTreasurerExpense({
    required DateTime expenseDate,
    required String category,
    String? vendorId,
    String? vendorName,
    required double amount,
    required String description,
    String paymentMode = 'bank_transfer',
    String? receiptUrl,
    String approvalStatus = 'approved',
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'create_treasurer_expense',
      params: {
        'p_admin_user_id': currentUser.id,
        'p_expense_date': expenseDate.toIso8601String().split('T').first,
        'p_category': category.trim(),
        'p_vendor_id': vendorId,
        'p_vendor_name': vendorName?.trim(),
        'p_amount': amount,
        'p_description': description.trim(),
        'p_payment_mode': paymentMode,
        'p_receipt_url': receiptUrl?.trim(),
        'p_approval_status': approvalStatus,
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(response.first as Map);
  }

  Future<Map<String, dynamic>?> createVendorQuotationRequest({
    required String requestTitle,
    required String serviceType,
    DateTime? requestedStartDate,
    String? contractDuration,
    double? estimatedBudget,
    int? staffRequired,
    String? requirements,
    required List<String> vendorIds,
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'create_vendor_quotation_request',
      params: {
        'p_admin_user_id': currentUser.id,
        'p_request_title': requestTitle.trim(),
        'p_service_type': serviceType.trim(),
        'p_requested_start_date': requestedStartDate?.toIso8601String().split('T').first,
        'p_contract_duration': contractDuration?.trim(),
        'p_estimated_budget': estimatedBudget,
        'p_staff_required': staffRequired,
        'p_requirements': requirements?.trim(),
        'p_vendor_ids': vendorIds,
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(response.first as Map);
  }

  Future<Map<String, dynamic>?> renewFinanceVendorContract({
    required String vendorId,
    required DateTime startDate,
    required DateTime endDate,
    required double monthlyAmount,
    String? termsSummary,
    String? slaSummary,
    int? qualityRating,
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'renew_finance_vendor_contract',
      params: {
        'p_admin_user_id': currentUser.id,
        'p_vendor_id': vendorId,
        'p_start_date': startDate.toIso8601String().split('T').first,
        'p_end_date': endDate.toIso8601String().split('T').first,
        'p_monthly_amount': monthlyAmount,
        'p_terms_summary': termsSummary?.trim(),
        'p_sla_summary': slaSummary?.trim(),
        'p_quality_rating': qualityRating,
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(response.first as Map);
  }

  Future<Map<String, dynamic>?> adminMarkMaintenancePaid({
    required String billId,
    String? note,
    DateTime? markPaidOn,
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'admin_mark_maintenance_paid',
      params: {
        'p_admin_user_id': currentUser.id,
        'p_bill_id': billId,
        'p_note': note,
        'p_mark_paid_on': markPaidOn?.toIso8601String().split('T').first,
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(response.first as Map);
  }

  Future<Map<String, dynamic>?> sendMaintenanceAlerts({
    required List<String> residentUserIds,
    required String messageTemplate,
    List<String> channels = const ['push'],
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null || residentUserIds.isEmpty) {
      return null;
    }

    final response = await _client.rpc(
      'send_maintenance_alerts',
      params: {
        'p_admin_user_id': currentUser.id,
        'p_resident_user_ids': residentUserIds,
        'p_message_template': messageTemplate,
        'p_channels': channels,
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(response.first as Map);
  }

  Future<Map<String, dynamic>?> fetchAdminMaintenanceNotificationSettings()
  async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final rows = await _client
        .from('admin_maintenance_notification_settings')
        .select()
        .eq('admin_user_id', currentUser.id)
        .limit(1);
    final records = _castRows(rows);
    if (records.isEmpty) {
      return null;
    }

    return records.first;
  }

  Future<Map<String, dynamic>?> saveAdminMaintenanceNotificationSettings({
    required bool beforeDueEnabled,
    required int beforeDueDays,
    required bool onDueEnabled,
    required bool followUpEnabled,
    required String followUpFrequency,
    required bool weeklyOverdueEnabled,
    required bool channelPushEnabled,
    required bool channelEmailEnabled,
    required bool channelSmsEnabled,
    required String templateBody,
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'upsert_admin_maintenance_notification_settings',
      params: {
        'p_admin_user_id': currentUser.id,
        'p_before_due_enabled': beforeDueEnabled,
        'p_before_due_days': beforeDueDays,
        'p_on_due_enabled': onDueEnabled,
        'p_follow_up_enabled': followUpEnabled,
        'p_follow_up_frequency': followUpFrequency,
        'p_weekly_overdue_enabled': weeklyOverdueEnabled,
        'p_channel_push_enabled': channelPushEnabled,
        'p_channel_email_enabled': channelEmailEnabled,
        'p_channel_sms_enabled': channelSmsEnabled,
        'p_template_body': templateBody,
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

  Future<Map<String, dynamic>?> fetchGuardTodayAttendance() async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final today = DateTime.now().toIso8601String().split('T').first;
    final rows = await _client
        .from('guard_attendance_logs')
        .select()
        .eq('guard_user_id', currentUser.id)
        .eq('attendance_date', today)
        .limit(1);
    final records = _castRows(rows);
    if (records.isEmpty) {
      return null;
    }

    return records.first;
  }

  Future<List<Map<String, dynamic>>> fetchGuardAttendanceHistory() async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return const [];
    }

    final rows = await _client
        .from('guard_attendance_logs')
        .select()
        .eq('guard_user_id', currentUser.id)
        .order('attendance_date', ascending: false)
        .order('created_at', ascending: false)
        .limit(31);

    return _castRows(rows);
  }

  Future<Map<String, dynamic>?> setGuardAttendance({
    required String action,
    String? notes,
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final response = await _client.rpc(
      'set_guard_attendance',
      params: {
        'p_guard_user_id': currentUser.id,
        'p_action': action,
        'p_notes': notes,
      },
    );

    if (response is! List || response.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(response.first as Map);
  }

  Future<List<Map<String, dynamic>>> fetchGuardVisitorLogs() async {
    final visitorRows = await _client
        .from('visitor_passes')
        .select()
        .order('expected_arrival', ascending: false);
    final records = _castRows(visitorRows);

    if (records.isEmpty) {
      return records;
    }

    final residentIds = records
        .map((row) => row['resident_user_id']?.toString())
        .whereType<String>()
        .toSet()
        .toList();

    if (residentIds.isEmpty) {
      return records;
    }

    final residentRows = await _client
        .from('app_users')
        .select('id, full_name, unit_number, tower')
        .inFilter('id', residentIds);
    final residentsById = {
      for (final row in _castRows(residentRows))
        row['id']?.toString() ?? '': row,
    };

    return records.map((row) {
      final resident =
          residentsById[row['resident_user_id']?.toString()] ??
          const <String, dynamic>{};
      return {
        ...row,
        'resident_name': resident['full_name'],
        'unit_number': resident['unit_number'],
        'tower': resident['tower'],
      };
    }).toList();
  }

  Future<Map<String, dynamic>?> checkoutGuardVisitorPass({
    required String passId,
  }) async {
    final currentUser = AppSession.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    final passRows = await _client
        .from('visitor_passes')
        .select('id, visitor_name, status, resident_user_id')
        .eq('id', passId)
        .limit(1);
    final passes = _castRows(passRows);
    if (passes.isEmpty) {
      return null;
    }

    final pass = passes.first;
    final status = pass['status']?.toString().trim().toLowerCase() ?? '';
    if (status == 'checked_out' || status == 'denied') {
      return pass;
    }

    final residentRows = await _client
        .from('app_users')
        .select('unit_number')
        .eq('id', pass['resident_user_id'])
        .limit(1);
    final unitNumber = _castRows(residentRows).isEmpty
        ? null
        : _castRows(residentRows).first['unit_number']?.toString();

    await _client
        .from('visitor_passes')
        .update({'status': 'checked_out'})
        .eq('id', passId);

    await _client.from('guard_duty_logs').insert({
      'guard_user_id': currentUser.id,
      'title': 'Visitor checked out',
      'details':
          '${pass['visitor_name'] ?? 'Visitor'} has been checked out at the gate.',
      'related_visitor_name': pass['visitor_name'],
      'related_unit': unitNumber,
      'log_status': 'completed',
      'logged_at': DateTime.now().toIso8601String(),
    });

    return {...pass, 'status': 'checked_out', 'unit_number': unitNumber};
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
