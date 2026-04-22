import 'package:flutter/material.dart';

import '../../../app/app_page.dart';
import '../../../core/notifications/resident_notifications_controller.dart';
import '../../../core/session/app_session.dart';
import '../../../core/supabase/avenue_repository.dart';
import '../../../theme/avenue_theme.dart';
import '../../common/presentation/avenue_ui.dart';

const _residentAvatarUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCJ6EpMNgN7n9bh8EVIUs7N5SOo5Yl-IMIN9XmH6Yy-5ZQFuibLZUhdy_fSA1wZksMCirCpeAxKY-X3RhGG21edbtajSTdvIKPF-bAU_cgdKsh8O4-U9Ynedpa_iOPQvDGGNY_u9vM9PIETZpc_crPtmFthrBwf51AmmWx8Ymv72rHR1kQRjARNXhFro_rBfoEztKMZBRHWwESolqtAF7ekTFs603tp08kexUAy68IjY7VYyjoJirw5E8Oxqte5m_7dGXGGMAFX3P1e';
const _drawerAvatarUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuD01jq6wwzAfe2He4lwz5A50plLRcj7bguj_gHupxb2Xyzx1N-F443OX9XNc9J6Ve9_nqOzimLwAfaql-8laH4BiOytzTjxbvNAJ5WFqdKZI6byAFx5O0lEdoe92DfLxSIyy4KerqQGyh6u8mp4aN0fEJNro_wbIsW3QBLNFojkBRs5VeUfFwiqR2QtlepC04Hq2oZVddgQoIfMiXPwedtIoFNl3jlTU3Cq3pyjJ-9LRrSPeZZzMUzjeOt0_XisT33hovPAJlUdtcwE';
const _profileAvatarUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBg0i9YM5IEGdzLL17BoAjodnNcI3uMuhlrCCaBsSoWkHRuSTvuGGhC3LFb4q5Ebhr6wd0gKAU0tpfQsVa1Ys8kTPY4dwv5W1Rl_zaSIuSjTYx65EmI1873v2bqyYHmUjy10zff8OscnqTSqj6qLPrCX_mFqd5jOt4dcplv9SyfqD-xCFPkQzuakDhkKqvAvyELUbJ6nDQNQZ1YOlcDG4zOTMzbqZJzpihPXVJGtaro8oaY97tXbO0iD3P0D494f5t46VwIZa9jS5-3';
const _priyaAvatarUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuD3Uk5EaMJ3WGJLsCQIg0a8LodV8CLG2W9bMsn7CcIyoqx9U7LcfG4_VR-DfkFaZPR34SnVXHP4vBab2ZWDLOQbcCR_hElFK_EaI4SlnnL0R9rQxf11fdtxaN9chpV9j_h1PgVHoSMHdzduyg0Gd-Ya4jg2l56D-g8OxQeLhfgT_3TgQcJYCIe7Y_109_0DS4xIKG8TA2X5uKoQ4NDEz8vwaeglPMmejbSzALb6wnlkQU3nrQF8yIk1Wc79aE2fGc6Qv6GyN8TPoAPW';
const _arjunAvatarUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAkRLFKvKweGErGZn82oznlhjf66TuhSQlDOmesGonInjMpTkI4dBf5XvJUaVdAAEEifC4jUzTK4I1OyDBQH5zkBReluC3cu9yzWyzbPz48dj7AhmHfjmV5D9OCJJ1CVKi8pxPnpQ0IC2ajf-9jemSErS3MdXE7m4KF2NJoJj9RbzrvlJtf6ml7Xq0oKbZoChNiiT_gbSkVuqexUsAVzEdjvWMx3G4JEDBKqV_b4pd-6JdFnk5RTb2y8M5_682IlIM1r7RIDoscfnJ3';
const _guestAvatarUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAkrCaO4iRaep9vrU3FOtilMA7koGYVNB_3T1RY_imWxBxtmpiFaBC0lxc8NhAj4ZDYILwhiu8Z0_zR3h9tpaUkd4y3blt_r43WSXxUzp5pMRHf6gWhjOaz1laMK0sXdVs9PxpOyWApWuz4jtkeMxie5Ro_ClQxNfBumcnipFGy7FFKHUjgAWbI6p_xlXO2WdjdhcAlHpb7vuU8hb8jyNcglngUGexJ27oNBjt7a4b88QkjnqSLwN2UZBR-AJ2fEeOLcgnJdGNq-Bwe';
const _poolImageUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBxzm-dGnr-qUg3CunB_AYuyZuRG37ek0vFJXPFvgBu9IsZxGmlsT2ZZLza2KHK_VyptCVsa6goNGYiVM5iVQKh2OoXgJynnq17ZycQz0mx8QAYHbEF0hJ_3gItSrmGv3HmW8MqICkRx8gCK72ehyb5pMt1QXRPhq6nN-ZLuoPXiDD3AQhXTveXvWkmKzAO_rxNGKCqQr1Lw2wRnscP3PZDO8GW1hI4UrxhOgefXRQh2dksJSD1hHW8b67QYBbSIpOA0mNo3gLzDq0';
const _bookingPoolImageUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuDkxSj9F5pI8TpJqXogBdv9M60AYkORAkulvAUMaotV1m5eiR-JJUlyFXOupMlbmmkEwJQfA4Ge1LtgS1loXrr_nMuNHW5g_O_KhErhR15b29WQEIQcTAVsdVz35RmjqTKmLrC4bc2Y4ZSHxnBlazfcV15AduiRk1d9kPrj1wiiQ8LUzRNj3bgJ1djkMGHondFnRt-ZN904ID2BvqOV5B_dxc4p7flx_jY0c77MDJ1FLSw7FknWaYNRiMnEzY0x0x6f23zO3uHDTe0';
const _gymImageUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBWTTQ3UiXvD57t3y9l3xUZ6A7KeczByka3Xq2UojS4x44ReWHVyDmubL-CWJdb92iI2_iul9NP715Lo5AEkuYEu5dVcMtl2zeBkEsip6MvgrHMiAPxkZbbklk1MPOkK-KfWusX6tiNrBDemlRUUiOky0JZU0DExSaYFrEpEQ_wOFWUIvuh1QvGxVU74XYTBZ0U9H0Ay5rnnPJkaURiBg_cddNE8CFalkWpo38jzdNFFKtfsxN4kJKY9i7prr1n-dTnHdHtAQgXCWA';
const _gymDetailImageUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCDgtAD5nxPhJnLsKnPb51MHwwF3EmDmaroxehgRLOzk8Au236wW9kk8iNdZnuumakmCp8IxbPGTAwq1jG3bwtvPFSSBExVHXFqHiYJKUqBjklvLivt1dLvKmGqqdTTYbnlSMwnE1VEdOSjCmB3uYVuiLcuLmZW0Su-IZ2Z7YIH7oyRBwydQRaQ11rPHoVPicramdcAN6Qy8Noq0i89s_muiCUERDPjB4V48OS_eomq-_CmW-d_XqPurFHHNVQEb5_ILLjkLkKm_E8';
const _loungeImageUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBDq3lh2XEgyajN8zt4b-iBTuyGgfLZ9xixqax5xpr6ARMb_IM08URqgsQP3JJMAkGmCteSoVbiCQxeizU-wbEAdOHx6Py9gwomw7roFtjmjp-e1DLYSHphrozp2e3ONAn6Ydf0L9KPF98xFHcwt8jrotPoIX8WKusFNIR27KVZ6tcLGyY87Qy9Z5mykcaifpD29m4gm9oLN1n7ax8_fiVOek9gGTivFz_CntCiTQq7BXrVqpdz2s1cSb7WdeUQNZ-411uOLfrM9Bk';
const _noticesEventImageUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuDkmW20f9rTZrHOuu7ObTips3uRMBnVQPCCNmagXZxn0n3ku8HbWnWmXuOwAF8Y_LhThFupg86DxIu0i-bpgwqeGrmvsU-U8_cQLVm8FFqi0FCcWHp22zgRb6gurG3qqVPTrFfc73xUUOfBnBD7bg38b4dam-35LIYLWqwkHSH2TZTn_Erwce7_FRIvkwaCZgUtcS9RrYf7Weps72sFqzQwIZ86taaWhbApvWXJC-k5IgOqr8zLBVHYNHyTQpG40ssJWoqPel6lh0wg';
const _noticesThumbImageUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCT84Dnqvr_05ufLKIEan25BSCHd0RlyUjmdnEESu2sMLINldbznBfhhEfbydwEQe-nH3OsMX3HFyr6_aLPhypPQYTb_LHLUKT1p3RX-z8pqFi-ceajA06k5JEO_vCPjxnmsPLazeZisAyTzry5IFExOkO7FUrdjdKjnd6VGeJMF4CX3IxjecTXOA-N-pv3plwQ5F-yGZPs6Z_EEgFRqTWy_vnkqnd23piPX6xDIzG_TjNVmLX5xu4LDTkY7CLfOnplnVQwQKp3Vl75';

final _residentNavItems = [
  const AvenueNavItem(
    label: 'HOME',
    icon: Icons.home_rounded,
    page: AppPage.home,
  ),
  const AvenueNavItem(
    label: 'AMENITIES',
    icon: Icons.pool_rounded,
    page: AppPage.amenities,
  ),
  const AvenueNavItem(
    label: 'NOTICES',
    icon: Icons.campaign_outlined,
    page: AppPage.notices,
  ),
  const AvenueNavItem(
    label: 'COMPLAINTS',
    icon: Icons.report_problem_outlined,
    page: AppPage.complaints,
  ),
];

final _visitorNavItems = [
  const AvenueNavItem(
    label: 'HOME',
    icon: Icons.home_rounded,
    page: AppPage.home,
  ),
  const AvenueNavItem(
    label: 'VISITORS',
    icon: Icons.group_outlined,
    page: AppPage.visitor,
  ),
  const AvenueNavItem(
    label: 'SERVICES',
    icon: Icons.grid_view_rounded,
    page: AppPage.amenities,
  ),
  const AvenueNavItem(
    label: 'PROFILE',
    icon: Icons.person_outline_rounded,
    page: AppPage.profile,
  ),
];

final _billingNavItems = [
  const AvenueNavItem(
    label: 'HOME',
    icon: Icons.home_rounded,
    page: AppPage.home,
  ),
  const AvenueNavItem(
    label: 'BILLS',
    icon: Icons.receipt_long_outlined,
    page: AppPage.bills,
  ),
  const AvenueNavItem(
    label: 'NOTICES',
    icon: Icons.campaign_outlined,
    page: AppPage.notices,
  ),
  const AvenueNavItem(
    label: 'PROFILE',
    icon: Icons.person_outline_rounded,
    page: AppPage.profile,
  ),
];

String _relativeTimeLabel(dynamic value) {
  if (value == null) {
    return 'Now';
  }

  final parsed = DateTime.tryParse(value.toString());
  if (parsed == null) {
    return value.toString();
  }

  final difference = DateTime.now().difference(parsed.toLocal());
  if (difference.inMinutes < 60) {
    return '${difference.inMinutes.clamp(1, 59)} mins ago';
  }
  if (difference.inHours < 24) {
    return '${difference.inHours} hrs ago';
  }
  if (difference.inDays == 1) {
    return 'Yesterday';
  }

  return '${difference.inDays} days ago';
}

String _calendarDateLabel(dynamic value) {
  if (value == null) {
    return '15 Jun 2025';
  }

  final parsed = DateTime.tryParse(value.toString());
  if (parsed == null) {
    return value.toString();
  }

  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${parsed.day.toString().padLeft(2, '0')} ${months[parsed.month - 1]} ${parsed.year}';
}

String _monthLabel(dynamic value) {
  final parsed = DateTime.tryParse(value?.toString() ?? '');
  if (parsed == null) {
    return 'OCT';
  }

  const months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];

  return months[parsed.month - 1];
}

String _dayOfMonthLabel(dynamic value) {
  final parsed = DateTime.tryParse(value?.toString() ?? '');
  if (parsed == null) {
    return '24';
  }

  return parsed.day.toString().padLeft(2, '0');
}

String _dateTimeLabel(dynamic value) {
  if (value == null) {
    return '-';
  }

  final parsed = DateTime.tryParse(value.toString());
  if (parsed == null) {
    return value.toString();
  }

  final local = parsed.toLocal();
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
  final minute = local.minute.toString().padLeft(2, '0');
  final meridiem = local.hour >= 12 ? 'PM' : 'AM';
  return '${local.day.toString().padLeft(2, '0')} ${months[local.month - 1]} ${local.year}, $hour:$minute $meridiem';
}

String _currencyLabel(dynamic amount, {bool signed = false}) {
  if (amount == null) {
    return signed ? '₹0' : '₹0';
  }

  final number = amount is num
      ? amount.toDouble()
      : double.tryParse(amount.toString()) ?? 0;
  final absolute = number.abs();
  final isWhole = absolute == absolute.roundToDouble();
  final value = isWhole
      ? absolute.toStringAsFixed(0)
      : absolute.toStringAsFixed(2);
  final prefix = signed && number < 0 ? '-₹' : '₹';
  return '$prefix$value';
}

IconData _amenityIconForCategory(String? category) {
  switch (category?.toLowerCase()) {
    case 'wellness':
      return Icons.fitness_center_rounded;
    case 'entertainment':
      return Icons.deck_rounded;
    default:
      return Icons.pool_rounded;
  }
}

Color _amenityStatusBackground(String? status) {
  switch (status?.toUpperCase()) {
    case 'BUSY':
      return const Color(0xFFFFC43B);
    case 'BOOKING REQUIRED':
      return const Color(0x22000000);
    default:
      return const Color(0x22000000);
  }
}

Color _amenityStatusForeground(String? status) {
  switch (status?.toUpperCase()) {
    case 'BUSY':
      return const Color(0xFF6B4B00);
    default:
      return Colors.white;
  }
}

AppPage _amenityTargetPage(String? code) {
  switch (code) {
    case 'modern-gym':
      return AppPage.amenityDetailsGym;
    default:
      return AppPage.amenityBooking;
  }
}

IconData _noticeIconForKind(String? kind) {
  switch (kind) {
    case 'urgent':
      return Icons.warning_amber_rounded;
    case 'facility':
      return Icons.eco_rounded;
    case 'event':
      return Icons.celebration_rounded;
    default:
      return Icons.campaign_rounded;
  }
}

Color _noticeIconColor(String? kind) {
  switch (kind) {
    case 'urgent':
      return const Color(0xFFD33B2C);
    case 'facility':
      return const Color(0xFF846000);
    default:
      return AvenueColors.primary;
  }
}

IconData _billIconForCategory(String? category) {
  switch (category) {
    case 'mobile':
      return Icons.smartphone_rounded;
    case 'electricity':
      return Icons.bolt_rounded;
    case 'dth':
      return Icons.tv_rounded;
    case 'water':
      return Icons.water_drop_rounded;
    default:
      return Icons.receipt_long_rounded;
  }
}

Color _billBadgeColor(String? state) {
  switch (state) {
    case 'paid':
      return const Color(0xFFE5F6E9);
    case 'expiring':
      return const Color(0xFFFFF1CF);
    default:
      return const Color(0xFFFFE1DE);
  }
}

Color _billBadgeTextColor(String? state) {
  switch (state) {
    case 'paid':
      return const Color(0xFF2E9A53);
    case 'expiring':
      return const Color(0xFF8B6500);
    default:
      return const Color(0xFFD33B2C);
  }
}

Color _billAmountColor(String? state) {
  switch (state) {
    case 'paid':
      return AvenueColors.onSurface;
    case 'expiring':
      return const Color(0xFF8B6500);
    default:
      return const Color(0xFFD33B2C);
  }
}

String _billMetaLabel(String? state) {
  return state == 'paid' ? 'LAST PAID' : 'AMOUNT DUE';
}

IconData _activityIconForCategory(String? category) {
  switch (category?.toLowerCase()) {
    case 'electricity':
      return Icons.bolt_rounded;
    case 'internet':
      return Icons.wifi_tethering_rounded;
    case 'water':
      return Icons.water_drop_rounded;
    default:
      return Icons.receipt_long_rounded;
  }
}

String _complaintStatusLabel(String? state) {
  switch (state) {
    case 'in_progress':
      return 'In Progress';
    case 'resolved':
      return 'Resolved';
    default:
      return 'Pending';
  }
}

Color _complaintStatusColor(String? state) {
  switch (state) {
    case 'in_progress':
      return const Color(0xFFE29B00);
    case 'resolved':
      return const Color(0xFF2E9A53);
    default:
      return AvenueColors.onSurfaceVariant;
  }
}

IconData _complaintIcon(String? iconName) {
  switch (iconName) {
    case 'water_drop':
      return Icons.water_drop_rounded;
    case 'electrical_services':
      return Icons.electrical_services_rounded;
    case 'plumbing':
      return Icons.plumbing_rounded;
    default:
      return Icons.build_circle_outlined;
  }
}

IconData _complaintMetaIcon(String? state) {
  switch (state) {
    case 'in_progress':
      return Icons.engineering_outlined;
    case 'resolved':
      return Icons.verified_rounded;
    default:
      return Icons.hourglass_empty_rounded;
  }
}

String _visitorKindLabel(String? kind) {
  switch (kind) {
    case 'delivery':
      return 'Delivery';
    case 'service':
      return 'Service';
    default:
      return 'Guest';
  }
}

String _visitorKindValue(String label) {
  switch (label.toLowerCase()) {
    case 'delivery':
      return 'delivery';
    case 'service':
      return 'service';
    default:
      return 'guest';
  }
}

String _complaintTypeIcon(String label) {
  switch (label) {
    case 'Water Leak':
      return 'water_drop';
    case 'Plumbing':
      return 'plumbing';
    default:
      return 'electrical_services';
  }
}

String _complaintTypeAccent(String label) {
  switch (label) {
    case 'Water Leak':
      return '#FFB018';
    case 'Plumbing':
      return '#D8E2FF';
    default:
      return '#E2E3E8';
  }
}

class _ResidentHomeData {
  const _ResidentHomeData({required this.bills, required this.notices});

  final List<Map<String, dynamic>> bills;
  final List<Map<String, dynamic>> notices;

  static Future<_ResidentHomeData> load(AvenueRepository repository) async {
    final results = await Future.wait([
      repository.fetchCurrentUserBills(),
      repository.fetchNotices(limit: 2),
    ]);

    return _ResidentHomeData(
      bills: List<Map<String, dynamic>>.from(results[0] as List),
      notices: List<Map<String, dynamic>>.from(results[1] as List),
    );
  }
}

class _ResidentProfileData {
  const _ResidentProfileData({
    required this.profile,
    required this.familyMembers,
    required this.vehicles,
  });

  final dynamic profile;
  final List<Map<String, dynamic>> familyMembers;
  final List<Map<String, dynamic>> vehicles;

  static Future<_ResidentProfileData> load(AvenueRepository repository) async {
    final results = await Future.wait([
      repository.fetchCurrentUserProfile(),
      repository.fetchHouseholdMembers(),
      repository.fetchVehicles(),
    ]);

    return _ResidentProfileData(
      profile: results[0],
      familyMembers: List<Map<String, dynamic>>.from(results[1] as List),
      vehicles: List<Map<String, dynamic>>.from(results[2] as List),
    );
  }
}

class _AmenitiesData {
  const _AmenitiesData({
    required this.amenities,
    required this.bookings,
    required this.poolAmenity,
    required this.gymAmenity,
  });

  final List<Map<String, dynamic>> amenities;
  final List<Map<String, dynamic>> bookings;
  final Map<String, dynamic>? poolAmenity;
  final Map<String, dynamic>? gymAmenity;

  static Future<_AmenitiesData> load(AvenueRepository repository) async {
    final results = await Future.wait([
      repository.fetchAmenities(),
      repository.fetchCurrentUserAmenityBookings(),
      repository.fetchAmenityByCode('infinity-pool'),
      repository.fetchAmenityByCode('modern-gym'),
    ]);

    return _AmenitiesData(
      amenities: List<Map<String, dynamic>>.from(results[0] as List),
      bookings: List<Map<String, dynamic>>.from(results[1] as List),
      poolAmenity: results[2] as Map<String, dynamic>?,
      gymAmenity: results[3] as Map<String, dynamic>?,
    );
  }
}

class _BillsData {
  const _BillsData({
    required this.bills,
    required this.paymentMethods,
    required this.paymentActivity,
  });

  final List<Map<String, dynamic>> bills;
  final List<Map<String, dynamic>> paymentMethods;
  final List<Map<String, dynamic>> paymentActivity;

  static Future<_BillsData> load(AvenueRepository repository) async {
    final results = await Future.wait([
      repository.fetchCurrentUserBills(),
      repository.fetchCurrentUserPaymentMethods(),
      repository.fetchCurrentUserPaymentActivity(),
    ]);

    return _BillsData(
      bills: List<Map<String, dynamic>>.from(results[0] as List),
      paymentMethods: List<Map<String, dynamic>>.from(results[1] as List),
      paymentActivity: List<Map<String, dynamic>>.from(results[2] as List),
    );
  }
}

class _ComplaintsData {
  const _ComplaintsData(this.rows);

  final List<Map<String, dynamic>> rows;

  static Future<_ComplaintsData> load(AvenueRepository repository) async {
    final rows = await repository.fetchCurrentUserComplaints();
    return _ComplaintsData(rows);
  }
}

class _VisitorData {
  const _VisitorData(this.rows);

  final List<Map<String, dynamic>> rows;

  static Future<_VisitorData> load(AvenueRepository repository) async {
    final rows = await repository.fetchCurrentUserVisitorPasses();
    return _VisitorData(rows);
  }
}

InputDecoration _sheetInputDecoration(
  BuildContext context, {
  required String hintText,
}) {
  return InputDecoration(
    filled: true,
    fillColor: AvenueColors.surfaceHigh,
    hintText: hintText,
    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: AvenueColors.outline.withValues(alpha: 0.72),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  );
}

class ResidentDrawerScreen extends StatelessWidget {
  const ResidentDrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      backgroundColor: const Color(0xFFB8B8B8),
      body: SafeArea(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 310,
            height: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(34),
                bottomRight: Radius.circular(34),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AvenueNetworkAvatar(
                      imageUrl: _drawerAvatarUrl,
                      size: 64,
                      fallbackLabel: 'AS',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Aditya Sharma',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Flat B-204',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AvenueColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                const AvenuePill(
                  label: 'ACTIVE MEMBER',
                  backgroundColor: Color(0x1AFFBA43),
                  foregroundColor: Color(0xFFE29B00),
                ),
                const SizedBox(height: 28),
                _DrawerItem(
                  label: 'Dashboard',
                  icon: Icons.dashboard_customize_rounded,
                  selected: true,
                  onTap: () => goToPage(context, AppPage.home, replace: true),
                ),
                const SizedBox(height: 8),
                _DrawerItem(
                  label: 'Payments',
                  icon: Icons.payments_outlined,
                  onTap: () => goToPage(context, AppPage.bills, replace: true),
                ),
                const SizedBox(height: 8),
                _DrawerItem(
                  label: 'My Complaints',
                  icon: Icons.info_outline_rounded,
                  onTap: () =>
                      goToPage(context, AppPage.complaints, replace: true),
                ),
                const SizedBox(height: 8),
                _DrawerItem(
                  label: 'Notice Board',
                  icon: Icons.campaign_outlined,
                  onTap: () =>
                      goToPage(context, AppPage.notices, replace: true),
                ),
                const SizedBox(height: 8),
                _DrawerItem(
                  label: 'Amenities',
                  icon: Icons.pool_rounded,
                  onTap: () =>
                      goToPage(context, AppPage.amenities, replace: true),
                ),
                const SizedBox(height: 8),
                const _DrawerItem(label: 'Support', icon: Icons.help_outline),
                const SizedBox(height: 8),
                const _DrawerItem(label: 'Settings', icon: Icons.settings),
                const Spacer(),
                TextButton.icon(
                  onPressed: () =>
                      goToPage(context, AppPage.login, replace: true),
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: Color(0xFFD32F2F),
                  ),
                  label: Text(
                    'Logout',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFD32F2F),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = AppSession.instance.currentUser;
    final repository = AvenueRepository();

    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Avenue360',
        centerTitle: false,
        leading: AvenueIconButton(
          icon: Icons.menu_rounded,
          onPressed: () => goToPage(context, AppPage.drawer),
        ),
        titleWidget: Row(
          children: [
            const Icon(
              Icons.apartment_rounded,
              color: AvenueColors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Avenue360',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        actions: [
          const _ResidentNotificationBellButton(),
          Padding(
            padding: const EdgeInsets.only(right: 18, left: 6),
            child: GestureDetector(
              onTap: () => goToPage(context, AppPage.profile),
              child: AvenueNetworkAvatar(
                imageUrl: currentUser?.avatarUrl ?? _residentAvatarUrl,
                size: 36,
                fallbackLabel: currentUser?.initials ?? 'A',
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<_ResidentHomeData>(
        future: _ResidentHomeData.load(repository),
        builder: (context, snapshot) {
          final data = snapshot.data;
          final bills = data?.bills ?? const <Map<String, dynamic>>[];
          final notices = data?.notices ?? const <Map<String, dynamic>>[];
          final maintenanceBill = bills
              .cast<Map<String, dynamic>?>()
              .firstWhere(
                (bill) =>
                    bill?['category'] == 'maintenance' ||
                    bill?['title'] == 'Quarterly Maintenance',
                orElse: () => bills.isNotEmpty ? bills.first : null,
              );

          return _ResidentScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MaintenanceCard(
                  onPayTap: () => goToPage(context, AppPage.bills),
                  amount: maintenanceBill?['amount_due']?.toString() ?? '2200',
                  dueDate: maintenanceBill?['due_date']?.toString(),
                ),
                const SizedBox(height: 20),
                AvenueSectionHeader(
                  title: 'Bills & recharges',
                  actionLabel: 'Manage',
                  onActionTap: () => goToPage(context, AppPage.bills),
                ),
                const SizedBox(height: 16),
                const _QuickBillsRow(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _FeatureActionCard(
                        icon: Icons.group_add_rounded,
                        iconBackground: const Color(0xFFE8EFFF),
                        iconColor: AvenueColors.primary,
                        title: 'Pre-Approve\nVisitor',
                        onTap: () => goToPage(context, AppPage.visitor),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _FeatureActionCard(
                        icon: Icons.campaign_rounded,
                        iconBackground: const Color(0xFFFFE8E6),
                        iconColor: const Color(0xFFE04A3F),
                        title: 'Raise\nComplaint',
                        onTap: () => goToPage(context, AppPage.complaints),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                AvenueSectionHeader(
                  title: 'Essential Notifications',
                  actionLabel: 'View All',
                  onActionTap: () => goToPage(context, AppPage.notifications),
                ),
                const SizedBox(height: 14),
                if (snapshot.connectionState != ConnectionState.done)
                  const _DataPlaceholderCard(label: 'Loading home data...')
                else if (notices.isEmpty)
                  const _DataPlaceholderCard(
                    label: 'No notifications available right now.',
                  )
                else
                  ...notices.map(
                    (notice) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _NotificationPreviewTile(
                        icon: (notice['kind'] == 'urgent')
                            ? Icons.receipt_long_rounded
                            : Icons.water_drop_rounded,
                        iconColor: (notice['kind'] == 'urgent')
                            ? const Color(0xFFC7483D)
                            : AvenueColors.onSurface,
                        iconBackground: (notice['kind'] == 'urgent')
                            ? const Color(0xFFFFE7E5)
                            : const Color(0xFFE9EEFF),
                        title: notice['title'] as String? ?? 'Notice',
                        subtitle: notice['body'] as String? ?? '',
                        timeLabel: _relativeTimeLabel(notice['posted_at']),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigation: AvenueBottomNavigationBar(
        items: _residentNavItems,
        currentPage: AppPage.home,
      ),
    );
  }
}

class _ResidentNotificationBellButton extends StatelessWidget {
  const _ResidentNotificationBellButton();

  @override
  Widget build(BuildContext context) {
    final controller = ResidentNotificationsController.instance;

    return ValueListenableBuilder<int>(
      valueListenable: controller.unreadCountNotifier,
      builder: (context, unreadCount, _) {
        final badgeLabel = unreadCount > 9 ? '9+' : unreadCount.toString();

        return Stack(
          clipBehavior: Clip.none,
          children: [
            AvenueIconButton(
              icon: Icons.notifications_none_rounded,
              onPressed: () => goToPage(context, AppPage.notifications),
            ),
            if (unreadCount > 0)
              Positioned(
                top: 7,
                right: 4,
                child: IgnorePointer(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6453A),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      badgeLabel,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class AmenitiesScreen extends StatelessWidget {
  const AmenitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();

    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Avenue360',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
      ),
      body: FutureBuilder<_AmenitiesData>(
        future: _AmenitiesData.load(repository),
        builder: (context, snapshot) {
          final amenities =
              snapshot.data?.amenities ?? const <Map<String, dynamic>>[];

          return _ResidentScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Amenities',
                  style: Theme.of(
                    context,
                  ).textTheme.displayMedium?.copyWith(fontSize: 22),
                ),
                const SizedBox(height: 4),
                Text(
                  'Discover and book resident facilities',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AvenueColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                const AvenueSearchField(
                  hintText: 'Search for pools, gyms, lounges...',
                ),
                const SizedBox(height: 22),
                Text(
                  'Categories',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Expanded(
                      child: _CategoryBubble(
                        icon: Icons.star_rounded,
                        label: 'Popular',
                        backgroundColor: Color(0xFFE8EEFF),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _CategoryBubble(
                        icon: Icons.spa_outlined,
                        label: 'Wellness',
                        backgroundColor: Color(0xFFFFF0E7),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _CategoryBubble(
                        icon: Icons.sports_esports_rounded,
                        label: 'Entertainment',
                        backgroundColor: Color(0xFFFFF2DB),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                AvenueSectionHeader(
                  title: 'Featured Spaces',
                  actionLabel: 'View All',
                  onActionTap: () {},
                ),
                const SizedBox(height: 14),
                if (snapshot.connectionState != ConnectionState.done &&
                    amenities.isEmpty)
                  const _DataPlaceholderCard(label: 'Loading amenities...')
                else
                  ...amenities.map(
                    (amenity) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _AmenityCard(
                        imageUrl:
                            amenity['image_url'] as String? ??
                            (amenity['code'] == 'modern-gym'
                                ? _gymImageUrl
                                : amenity['code'] == 'rooftop-lounge'
                                ? _loungeImageUrl
                                : _poolImageUrl),
                        status:
                            amenity['status_label'] as String? ?? 'AVAILABLE',
                        statusBackground: _amenityStatusBackground(
                          amenity['status_label'] as String?,
                        ),
                        statusForeground: _amenityStatusForeground(
                          amenity['status_label'] as String?,
                        ),
                        title: amenity['name'] as String? ?? 'Amenity',
                        subtitle:
                            amenity['occupancy_note'] as String? ??
                            amenity['availability_text'] as String? ??
                            '',
                        icon: _amenityIconForCategory(
                          amenity['category'] as String?,
                        ),
                        primaryActionLabel:
                            amenity['cta_label'] as String? ?? 'View Details',
                        outlinedButton: amenity['cta_label'] == 'View Details',
                        onTap: () => goToPage(
                          context,
                          _amenityTargetPage(amenity['code'] as String?),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigation: AvenueBottomNavigationBar(
        items: _residentNavItems,
        currentPage: AppPage.amenities,
      ),
    );
  }
}

class AmenityBookingScreen extends StatelessWidget {
  const AmenityBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();

    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'AmenityBooking',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: AvenueNetworkAvatar(
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuB1YXMzmKZSPkhaEw73PawWxa3olLvM1izNAiYnNfpQeM5ZfE5lkz5i2dDIKtlX_YImkpolNHFuk5sRi2rInVSUpF5ctoJPzdkQz0UGE7VS5S2XM11HbfzZXVyM8k6NrenPifXFp0XcVSVueOpZo0vLywTrOmKupKiHU_ETdxsy1qDjaC4IklvXjJ_BklTdB9mZQ9ZPyuexoAotp7vzvSFH-cGTNSm2Hirs3a5armdGnnl_ZGG6SVAs-Q44-D5n5rjZngQ0rqL6O0A',
              size: 34,
              fallbackLabel: 'A',
            ),
          ),
        ],
      ),
      body: FutureBuilder<_AmenitiesData>(
        future: _AmenitiesData.load(repository),
        builder: (context, snapshot) {
          final amenity = snapshot.data?.poolAmenity;
          final booking = snapshot.data?.bookings.isNotEmpty == true
              ? snapshot.data!.bookings.first
              : null;
          final bookingFee = booking?['booking_fee'];
          final guestCount = booking?['guest_count']?.toString() ?? '02';

          return _ResidentScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroImageCard(
                  imageUrl:
                      amenity?['image_url'] as String? ?? _bookingPoolImageUrl,
                  height: 206,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AvenuePill(
                          label: 'EXCLUSIVE ACCESS',
                          backgroundColor: Color(0x22000000),
                          foregroundColor: Colors.white,
                        ),
                        const Spacer(),
                        Text(
                          '${amenity?['name'] as String? ?? 'Infinity Pool'} at Avenue360',
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(color: Colors.white, fontSize: 20),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          amenity?['location_label'] as String? ??
                              'Rooftop Terrace, North Tower',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.88),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Text(
                      'Select Date',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _calendarDateLabel(booking?['booking_date']),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AvenueColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _DateChip(
                        dayLabel: 'BOOK',
                        dateLabel: _dayOfMonthLabel(booking?['booking_date']),
                        selected: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: _DateChip(dayLabel: 'TUE', dateLabel: '21'),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: _DateChip(dayLabel: 'WED', dateLabel: '22'),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: _DateChip(dayLabel: 'THU', dateLabel: '23'),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: _DateChip(dayLabel: 'FRI', dateLabel: '24'),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Text(
                  'Select Time Slot',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    const _TimeChip(label: '06:00 - 08:00'),
                    _TimeChip(
                      label:
                          booking?['time_slot'] as String? ?? '10:00 - 12:00',
                      selected: true,
                    ),
                    const _TimeChip(label: '14:00 - 16:00'),
                    const _TimeChip(label: '16:00 - 18:00'),
                    const _TimeChip(label: '20:00 - 22:00'),
                  ],
                ),
                const SizedBox(height: 18),
                AvenueCard(
                  padding: const EdgeInsets.all(18),
                  radius: 26,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Number of\nGuests',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Max 4 guests per residence',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const _CounterButton(icon: Icons.remove_rounded),
                      Container(
                        width: 54,
                        alignment: Alignment.center,
                        child: Text(
                          guestCount.padLeft(2, '0'),
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      const _CounterButton(
                        icon: Icons.add_rounded,
                        filled: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                AvenueCard(
                  padding: const EdgeInsets.all(18),
                  radius: 26,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.info_rounded,
                            color: AvenueColors.primary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Booking Guidelines',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const _BulletLine(
                        text:
                            'Residents must carry their digital ID for verification at the entrance.',
                      ),
                      const SizedBox(height: 10),
                      const _BulletLine(
                        text:
                            'No glassware or breakable containers allowed in the pool area.',
                      ),
                      const SizedBox(height: 10),
                      const _BulletLine(
                        text:
                            'Personal towels are mandatory; pool-side service is currently unavailable.',
                      ),
                      const SizedBox(height: 10),
                      const _BulletLine(
                        text:
                            'Shower is mandatory before entering the pool water.',
                      ),
                      const SizedBox(height: 10),
                      const _BulletLine(
                        text:
                            'Cancellations must be made at least 2 hours in advance.',
                      ),
                      const SizedBox(height: 18),
                      const Divider(height: 1),
                      const SizedBox(height: 14),
                      _BookingSummaryRow(
                        label: 'Booking Fee',
                        value: bookingFee == null
                            ? 'Complimentary'
                            : _currencyLabel(bookingFee),
                      ),
                      const SizedBox(height: 6),
                      _BookingSummaryRow(
                        label: 'Guest Charges',
                        value: _currencyLabel(0),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'TOTAL ESTIMATE',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bookingFee == null
                            ? _currencyLabel(0)
                            : _currencyLabel(bookingFee),
                        style: Theme.of(
                          context,
                        ).textTheme.displayMedium?.copyWith(fontSize: 26),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                AvenuePrimaryButton(
                  label: 'Confirm Booking',
                  icon: Icons.check_circle_rounded,
                  onPressed: () {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AmenityDetailsGymScreen extends StatelessWidget {
  const AmenityDetailsGymScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();

    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'AmenityDetails',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
        actions: [
          AvenueIconButton(icon: Icons.share_outlined, onPressed: () {}),
          const SizedBox(width: 12),
        ],
      ),
      body: FutureBuilder<_AmenitiesData>(
        future: _AmenitiesData.load(repository),
        builder: (context, snapshot) {
          final gym = snapshot.data?.gymAmenity;

          return _ResidentScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              children: [
                _HeroImageCard(
                  imageUrl: gym?['image_url'] as String? ?? _gymDetailImageUrl,
                  height: 260,
                  borderRadius: 32,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AvenuePill(
                              label: gym?['status_label'] as String? ?? 'BUSY',
                              backgroundColor: _amenityStatusBackground(
                                gym?['status_label'] as String?,
                              ),
                              foregroundColor: _amenityStatusForeground(
                                gym?['status_label'] as String?,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const AvenuePill(
                              label: 'LVL 4',
                              backgroundColor: Color(0x33000000),
                              foregroundColor: Colors.white,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          gym?['name'] as String? ?? 'Modern Gym',
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(color: Colors.white, fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -22),
                  child: AvenueCard(
                    radius: 32,
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gym?['description'] as String? ??
                              'Elevate your wellness journey in our state-of-the-art fitness center.',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: AvenueColors.onSurfaceVariant,
                                height: 1.55,
                              ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Text(
                              'Live Occupancy',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const Spacer(),
                            Text(
                              gym?['occupancy_note'] as String? ?? '80% Full',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AvenueColors.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: 0.8,
                            minHeight: 8,
                            backgroundColor: AvenueColors.surfaceHigh,
                            valueColor: const AlwaysStoppedAnimation(
                              AvenueColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          gym?['availability_text'] as String? ??
                              'Peak hours expected until 8:00 PM',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 18),
                        const Row(
                          children: [
                            Expanded(
                              child: _InfoMiniCard(
                                icon: Icons.schedule_rounded,
                                title: 'Operating\nHours',
                                subtitle: 'Daily\n6:00 AM - 10:00 PM',
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _InfoMiniCard(
                                icon: Icons.flash_on_rounded,
                                title: 'Peak Time',
                                subtitle: 'Evenings\n5:00 PM - 8:00 PM',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Amenities & Equipment',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 14),
                        const Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _EquipmentChip(
                              icon: Icons.directions_run_rounded,
                              label: 'CARDIO',
                            ),
                            _EquipmentChip(
                              icon: Icons.fitness_center_rounded,
                              label: 'WEIGHTS',
                            ),
                            _EquipmentChip(
                              icon: Icons.self_improvement_rounded,
                              label: 'YOGA AREA',
                            ),
                            _EquipmentChip(
                              icon: Icons.lock_outline_rounded,
                              label: 'LOCKERS',
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Book a Slot',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        const AvenuePill(
                          label: 'AVAILABLE NOW',
                          backgroundColor: Color(0x1A8FA8FF),
                          foregroundColor: Color(0xFF6E82FF),
                        ),
                        const SizedBox(height: 14),
                        AvenuePrimaryButton(
                          label: 'Reserve 60 Minute Session',
                          onPressed: () =>
                              goToPage(context, AppPage.amenityBooking),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class NoticesScreen extends StatefulWidget {
  const NoticesScreen({super.key});

  @override
  State<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen> {
  final AvenueRepository _repository = AvenueRepository();
  late Future<List<Map<String, dynamic>>> _noticesFuture;

  @override
  void initState() {
    super.initState();
    _noticesFuture = _repository.fetchNotices();
  }

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'NoticeBoard',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
        actions: [
          AvenueIconButton(
            icon: Icons.refresh_rounded,
            onPressed: () {
              setState(() {
                _noticesFuture = _repository.fetchNotices();
              });
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _noticesFuture,
        builder: (context, snapshot) {
          final notices = snapshot.data ?? const <Map<String, dynamic>>[];
          final urgent = notices
              .where((row) => row['kind'] == 'urgent')
              .toList();
          final events = notices
              .where((row) => row['kind'] == 'event')
              .toList();
          final standard = notices
              .where((row) => row['kind'] != 'urgent' && row['kind'] != 'event')
              .toList();

          return _ResidentScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(label: 'All', selected: true),
                      SizedBox(width: 10),
                      _FilterChip(label: 'Urgent'),
                      SizedBox(width: 10),
                      _FilterChip(label: 'General'),
                      SizedBox(width: 10),
                      _FilterChip(label: 'Events'),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                if (snapshot.connectionState != ConnectionState.done &&
                    notices.isEmpty)
                  const _DataPlaceholderCard(label: 'Loading notices...')
                else ...[
                  if (urgent.isNotEmpty) ...[
                    _UrgentNoticeCard(
                      title:
                          urgent.first['title'] as String? ?? 'Urgent notice',
                      dateText: _relativeTimeLabel(urgent.first['posted_at']),
                      body: urgent.first['body'] as String? ?? '',
                      actionLabel:
                          urgent.first['action_label'] as String? ??
                          'TAKE ACTION',
                    ),
                    const SizedBox(height: 16),
                  ],
                  ...events.map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _EventNoticeCard(
                        imageUrl:
                            row['image_url'] as String? ??
                            _noticesEventImageUrl,
                        title: row['title'] as String? ?? 'Event',
                        monthLabel: _monthLabel(row['event_date']),
                        dayLabel: _dayOfMonthLabel(row['event_date']),
                        category: (row['kind'] as String? ?? 'event')
                            .toUpperCase(),
                        buttonLabel: row['action_label'] as String? ?? 'RSVP',
                        onTap: () {},
                      ),
                    ),
                  ),
                  ...standard.map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _StandardNoticeCard(
                        title: row['title'] as String? ?? 'Notice',
                        category: (row['kind'] as String? ?? 'general')
                            .toUpperCase(),
                        dateText: _relativeTimeLabel(row['posted_at']),
                        body: row['body'] as String? ?? '',
                        icon: _noticeIconForKind(row['kind'] as String?),
                        iconColor: _noticeIconColor(row['kind'] as String?),
                        cta: row['action_label'] as String?,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
      bottomNavigation: AvenueBottomNavigationBar(
        items: _residentNavItems,
        currentPage: AppPage.notices,
      ),
    );
  }
}

class BillsScreen extends StatelessWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();

    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Manage Bills',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
        actions: [
          AvenueIconButton(icon: Icons.history_rounded, onPressed: () {}),
          const SizedBox(width: 12),
        ],
      ),
      body: FutureBuilder<_BillsData>(
        future: _BillsData.load(repository),
        builder: (context, snapshot) {
          final bills = snapshot.data?.bills ?? const <Map<String, dynamic>>[];
          final methods =
              snapshot.data?.paymentMethods ?? const <Map<String, dynamic>>[];
          final activity =
              snapshot.data?.paymentActivity ?? const <Map<String, dynamic>>[];

          return _ResidentScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Accounts',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 14),
                if (snapshot.connectionState != ConnectionState.done &&
                    bills.isEmpty)
                  const _DataPlaceholderCard(label: 'Loading bills...')
                else
                  ...bills.map(
                    (bill) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _BillAccountCard(
                        icon: _billIconForCategory(bill['category'] as String?),
                        title: bill['title'] as String? ?? 'Bill',
                        subtitle: bill['provider'] as String? ?? '',
                        badgeText: bill['badge_text'] as String? ?? '',
                        badgeColor: _billBadgeColor(bill['state'] as String?),
                        badgeTextColor: _billBadgeTextColor(
                          bill['state'] as String?,
                        ),
                        metaLabel: _billMetaLabel(bill['state'] as String?),
                        amount: _currencyLabel(
                          bill['amount_due'] ?? bill['amount_paid'],
                        ),
                        amountColor: _billAmountColor(bill['state'] as String?),
                        buttonLabel: bill['action_label'] as String?,
                      ),
                    ),
                  ),
                const SizedBox(height: 14),
                AvenueCard(
                  radius: 0,
                  padding: const EdgeInsets.symmetric(vertical: 26),
                  border: Border.all(
                    color: AvenueColors.outlineVariant.withValues(alpha: 0.65),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: const BoxDecoration(
                          color: AvenueColors.surfaceLow,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: AvenueColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Add New Bill',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Link a new utility account',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Quick Pay',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 14),
                if (methods.isEmpty)
                  const _DataPlaceholderCard(label: 'No saved payment methods.')
                else
                  Row(
                    children: methods.take(2).map((method) {
                      final isPrimary = method['is_primary'] == true;
                      final icon = method['method_type'] == 'card'
                          ? Icons.credit_card_rounded
                          : Icons.account_balance_rounded;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: method == methods.first && methods.length > 1
                                ? 12
                                : 0,
                          ),
                          child: _QuickPayCard(
                            dark: isPrimary,
                            title: method['method_name'] as String? ?? 'Method',
                            subtitle:
                                method['masked_value'] as String? ?? 'Saved',
                            trailing: icon,
                            note: method['note'] as String? ?? '',
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 20),
                const AvenueSectionHeader(
                  title: 'Recent Activity',
                  actionLabel: 'View All',
                ),
                const SizedBox(height: 12),
                if (activity.isEmpty)
                  const _DataPlaceholderCard(label: 'No payment activity yet.')
                else
                  ...activity.map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _PaymentActivityTile(
                        icon: _activityIconForCategory(
                          row['activity_category'] as String?,
                        ),
                        title: row['activity_title'] as String? ?? 'Activity',
                        date: _dateTimeLabel(row['activity_at']),
                        amount: _currencyLabel(row['amount'], signed: true),
                        status: row['status'] as String? ?? '',
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigation: AvenueBottomNavigationBar(
        items: _billingNavItems,
        currentPage: AppPage.bills,
      ),
    );
  }
}

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  final AvenueRepository _repository = AvenueRepository();
  bool _showActive = true;
  late Future<_ComplaintsData> _complaintsFuture;

  @override
  void initState() {
    super.initState();
    _complaintsFuture = _ComplaintsData.load(_repository);
  }

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'My Complaints',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: AvenueNetworkAvatar(
              imageUrl: _residentAvatarUrl,
              size: 34,
              fallbackLabel: 'A',
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AvenueColors.primary,
        onPressed: _showCreateComplaintSheet,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
      ),
      body: FutureBuilder<_ComplaintsData>(
        future: _complaintsFuture,
        builder: (context, snapshot) {
          final complaints =
              snapshot.data?.rows ?? const <Map<String, dynamic>>[];
          final active = complaints
              .where((row) => row['state'] != 'resolved')
              .toList();
          final history = complaints
              .where((row) => row['state'] == 'resolved')
              .toList();
          final visible = _showActive ? active : history;

          return _ResidentScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AvenueColors.surfaceLow,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _TabToggle(
                          label: 'Active',
                          count: '${active.length}',
                          selected: _showActive,
                          onTap: () => setState(() => _showActive = true),
                        ),
                      ),
                      Expanded(
                        child: _TabToggle(
                          label: 'History',
                          count: '${history.length}',
                          selected: !_showActive,
                          onTap: () => setState(() => _showActive = false),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                if (snapshot.connectionState != ConnectionState.done &&
                    complaints.isEmpty)
                  const _DataPlaceholderCard(label: 'Loading complaints...')
                else if (visible.isEmpty)
                  const _DataPlaceholderCard(
                    label: 'No complaints in this tab.',
                  )
                else
                  ...visible.map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _ComplaintCard(
                        accentColor: Color(
                          int.parse(
                            (row['accent_hex'] as String? ?? '#E2E3E8')
                                .replaceFirst('#', '0xFF'),
                          ),
                        ),
                        complaintId: '#${row['code'] as String? ?? ''}',
                        timestamp: _relativeTimeLabel(
                          row['resolved_at'] ?? row['created_at'],
                        ),
                        status: _complaintStatusLabel(row['state'] as String?),
                        statusColor: _complaintStatusColor(
                          row['state'] as String?,
                        ),
                        title: row['title'] as String? ?? 'Complaint',
                        description: row['description'] as String? ?? '',
                        icon: _complaintIcon(row['icon_name'] as String?),
                        metaLabel: row['meta_label'] as String? ?? 'STATUS',
                        metaValue: row['meta_value'] as String? ?? '-',
                        metaIcon: _complaintMetaIcon(row['state'] as String?),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigation: AvenueBottomNavigationBar(
        items: _residentNavItems,
        currentPage: AppPage.complaints,
      ),
    );
  }

  Future<void> _showCreateComplaintSheet() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedType = 'Electrical';
    bool isSubmitting = false;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 32,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: AvenueCard(
                radius: 28,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Raise Complaint',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      decoration: _sheetInputDecoration(
                        context,
                        hintText: 'Complaint title',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: _sheetInputDecoration(
                        context,
                        hintText: 'Describe the issue',
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['Electrical', 'Water Leak', 'Plumbing']
                          .map(
                            (type) => ChoiceChip(
                              label: Text(type),
                              selected: selectedType == type,
                              onSelected: (_) {
                                setModalState(() {
                                  selectedType = type;
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 18),
                    AvenuePrimaryButton(
                      label: isSubmitting ? 'Submitting...' : 'Submit',
                      onPressed: () async {
                        if (isSubmitting) {
                          return;
                        }

                        final title = titleController.text.trim();
                        final description = descriptionController.text.trim();
                        if (title.isEmpty || description.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Enter both title and description.',
                              ),
                            ),
                          );
                          return;
                        }

                        setModalState(() {
                          isSubmitting = true;
                        });

                        Map<String, dynamic>? result;
                        try {
                          result = await _repository.createComplaint(
                            title: title,
                            description: description,
                            iconName: _complaintTypeIcon(selectedType),
                            accentHex: _complaintTypeAccent(selectedType),
                          );
                        } catch (_) {
                          result = null;
                        }

                        if (!mounted || !sheetContext.mounted) {
                          return;
                        }

                        Navigator.of(sheetContext).pop();
                        if (result != null) {
                          setState(() {
                            _showActive = true;
                            _complaintsFuture = _ComplaintsData.load(
                              _repository,
                            );
                          });
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Complaint ${result['code']} created.',
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(
                              content: Text('Could not create complaint.'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();

    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'My Profile',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
      ),
      body: FutureBuilder<_ResidentProfileData>(
        future: _ResidentProfileData.load(repository),
        builder: (context, snapshot) {
          final data = snapshot.data;
          final profile = data?.profile;
          final family = data?.familyMembers ?? const <Map<String, dynamic>>[];
          final vehicles = data?.vehicles ?? const <Map<String, dynamic>>[];

          return _ResidentScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvenueCard(
                  radius: 24,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 26,
                  ),
                  color: const Color(0xFFEAF0FF),
                  child: Center(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            AvenueNetworkAvatar(
                              imageUrl:
                                  profile?.avatarUrl ??
                                  AppSession.instance.currentUser?.avatarUrl ??
                                  _profileAvatarUrl,
                              size: 96,
                              borderWidth: 4,
                              fallbackLabel:
                                  profile?.initials ??
                                  AppSession.instance.currentUser?.initials ??
                                  'AS',
                            ),
                            Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AvenueColors.primaryGradient,
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          profile?.fullName ??
                              AppSession.instance.currentUser?.fullName ??
                              'Resident',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile?.subtitle ??
                              AppSession.instance.currentUser?.subtitle ??
                              '-',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: AvenueColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                AvenueCard(
                  radius: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal Info',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _ProfileFieldRow(
                        label: 'FULL NAME',
                        value: profile?.fullName ?? 'Not available',
                      ),
                      const SizedBox(height: 18),
                      _ProfileFieldRow(
                        label: 'EMAIL ADDRESS',
                        value: profile?.email ?? 'Not available',
                      ),
                      const SizedBox(height: 18),
                      _ProfileFieldRow(
                        label: 'PHONE NUMBER',
                        value: profile?.phone ?? 'Not available',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                AvenueCard(
                  radius: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Family Members',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (snapshot.connectionState != ConnectionState.done &&
                          family.isEmpty)
                        const _DataPlaceholderCard(label: 'Loading family...')
                      else
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            ...family.map(
                              (member) => SizedBox(
                                width: 132,
                                child: _FamilyMemberChip(
                                  imageUrl:
                                      member['avatar_url'] as String? ??
                                      _priyaAvatarUrl,
                                  name:
                                      member['full_name'] as String? ??
                                      'Member',
                                  relation: member['relation'] as String? ?? '',
                                ),
                              ),
                            ),
                            Container(
                              width: 132,
                              height: 62,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: AvenueColors.outlineVariant,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '+  Add Member',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: AvenueColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                AvenueCard(
                  radius: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Vehicles',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.add_rounded,
                            color: AvenueColors.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (snapshot.connectionState != ConnectionState.done &&
                          vehicles.isEmpty)
                        const _DataPlaceholderCard(label: 'Loading vehicle...')
                      else if (vehicles.isEmpty)
                        const _DataPlaceholderCard(
                          label: 'No vehicles added yet.',
                        )
                      else
                        ...vehicles.map(
                          (vehicle) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AvenueColors.surfaceLow,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: const Icon(
                                      Icons.directions_car_filled_outlined,
                                      color: AvenueColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          vehicle['registration_number']
                                                  as String? ??
                                              '-',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          vehicle['vehicle_name'] as String? ??
                                              '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: AvenueColors
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.copy_outlined,
                                    color: AvenueColors.outline,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      AppSession.instance.clear();
                      goToPage(context, AppPage.login, replace: true);
                    },
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Logout'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEB4B3D),
                      side: const BorderSide(color: Color(0xFFEB4B3D)),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      textStyle: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigation: AvenueBottomNavigationBar(
        items: _residentNavItems,
        currentPage: null,
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ResidentNotificationsController.instance;

    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Notifications',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
        actions: [
          ValueListenableBuilder<int>(
            valueListenable: controller.unreadCountNotifier,
            builder: (context, unreadCount, _) {
              return TextButton(
                onPressed: unreadCount == 0
                    ? null
                    : () => controller.markAllAsRead(),
                child: Text(
                  'Mark all as read',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: unreadCount == 0
                        ? AvenueColors.outline
                        : AvenueColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          controller.rowsNotifier,
          controller.isLoadingNotifier,
        ]),
        builder: (context, _) {
          final rows = controller.rowsNotifier.value;
          final isLoading = controller.isLoadingNotifier.value;
          final unread = rows.where((row) => row['is_unread'] == true).toList();
          final earlier = rows
              .where((row) => row['is_unread'] != true)
              .toList();

          return _ResidentScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NEW',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    color: AvenueColors.onSurfaceVariant,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                if (isLoading && rows.isEmpty)
                  const _DataPlaceholderCard(label: 'Loading notifications...')
                else if (unread.isEmpty)
                  const _DataPlaceholderCard(label: 'No unread notifications.')
                else
                  ...unread.map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _NotificationDetailCard(
                        icon: (row['kind'] == 'payment')
                            ? Icons.receipt_long_rounded
                            : Icons.notifications_active_rounded,
                        iconBackground: (row['kind'] == 'payment')
                            ? const Color(0xFFFFE7E5)
                            : const Color(0xFFFFF0CB),
                        iconColor: (row['kind'] == 'payment')
                            ? const Color(0xFFC7483D)
                            : const Color(0xFF7A5300),
                        title: row['title'] as String? ?? 'Notification',
                        body: row['body'] as String?,
                        time: _relativeTimeLabel(row['created_at']),
                        unread: true,
                        actionLabel: row['action_label'] as String?,
                        label: row['badge_label'] as String?,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                Text(
                  'EARLIER',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    color: AvenueColors.onSurfaceVariant,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                if (earlier.isEmpty)
                  const _DataPlaceholderCard(label: 'No older notifications.')
                else
                  ...earlier.map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _ReadNotificationCard(
                        title: row['title'] as String? ?? 'Notification',
                        time: _relativeTimeLabel(row['created_at']),
                        avatarUrl: row['kind'] == 'visitor'
                            ? row['image_url'] as String? ?? _guestAvatarUrl
                            : null,
                        icon: row['kind'] == 'event'
                            ? Icons.celebration_rounded
                            : Icons.notifications_none_rounded,
                        thumbnailUrl: row['kind'] == 'event'
                            ? row['image_url'] as String? ??
                                  _noticesThumbImageUrl
                            : null,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class VisitorScreen extends StatefulWidget {
  const VisitorScreen({super.key});

  @override
  State<VisitorScreen> createState() => _VisitorScreenState();
}

class _VisitorScreenState extends State<VisitorScreen> {
  final AvenueRepository _repository = AvenueRepository();
  final TextEditingController _visitorNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _arrivalController = TextEditingController();
  final TextEditingController _visitorTypeController = TextEditingController(
    text: 'Guest',
  );

  late Future<_VisitorData> _visitorFuture;
  DateTime? _expectedArrival;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _expectedArrival = DateTime.now().add(const Duration(hours: 1));
    _arrivalController.text = _dateTimeLabel(_expectedArrival);
    _visitorFuture = _VisitorData.load(_repository);
  }

  @override
  void dispose() {
    _visitorNameController.dispose();
    _phoneController.dispose();
    _arrivalController.dispose();
    _visitorTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'VisitorAccess',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
      ),
      body: FutureBuilder<_VisitorData>(
        future: _visitorFuture,
        builder: (context, snapshot) {
          final passes = snapshot.data?.rows ?? const <Map<String, dynamic>>[];
          final upcoming = passes.isNotEmpty ? passes.first : null;

          return _ResidentScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pre-Approve a Visitor',
                  style: Theme.of(
                    context,
                  ).textTheme.displayMedium?.copyWith(fontSize: 22),
                ),
                const SizedBox(height: 6),
                Text(
                  'Generate a temporary access pass for your guests to ensure a smooth entry at the security gate.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AvenueColors.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                AvenueCard(
                  color: const Color(0xFFF4F7FF),
                  radius: 18,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.qr_code_scanner_rounded,
                          color: AvenueColors.primary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Seamless Gate Access',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              upcoming == null
                                  ? 'Once generated, your visitor will receive an SMS with a unique QR code and numeric PIN. They simply present this at the gate for instant, verified entry.'
                                  : '${upcoming['visitor_name']} is already approved with PIN ${upcoming['pin_code']}. Expected arrival is ${_dateTimeLabel(upcoming['expected_arrival'])}.',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AvenueColors.onSurfaceVariant,
                                    height: 1.5,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (passes.isNotEmpty) ...[
                  Text(
                    'Active Passes',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...passes.map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AvenueCard(
                        radius: 18,
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                color: AvenueColors.surfaceLow,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.group_outlined,
                                color: AvenueColors.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    row['visitor_name'] as String? ?? 'Visitor',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${_visitorKindLabel(row['visitor_kind'] as String?)} • ${_relativeTimeLabel(row['expected_arrival'])}',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: AvenueColors.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            AvenuePill(
                              label: (row['status'] as String? ?? '')
                                  .toUpperCase(),
                              backgroundColor: const Color(0xFFE8EEFF),
                              foregroundColor: AvenueColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                AvenueCard(
                  radius: 28,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Visitor Details',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 18),
                      AvenueInputField(
                        label: 'Visitor Full Name',
                        hintText: 'e.g., Jane Doe',
                        icon: Icons.person_rounded,
                        controller: _visitorNameController,
                      ),
                      const SizedBox(height: 16),
                      AvenueInputField(
                        label: 'Phone Number',
                        hintText: '+1 (555) 000-0000',
                        icon: Icons.call_rounded,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'The access pass will be sent to this number.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),
                      AvenueInputField(
                        label: 'Expected Arrival',
                        hintText: 'mm/dd/yyyy, --:-- --',
                        icon: Icons.calendar_today_rounded,
                        controller: _arrivalController,
                        readOnly: true,
                        onTap: _pickExpectedArrival,
                        trailing: const Icon(
                          Icons.calendar_today_rounded,
                          size: 18,
                          color: AvenueColors.outline,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AvenueInputField(
                        label: 'Visitor Type',
                        hintText: 'Guest',
                        icon: Icons.category_rounded,
                        controller: _visitorTypeController,
                        readOnly: true,
                        onTap: _pickVisitorType,
                        trailing: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AvenueColors.outline,
                        ),
                      ),
                      const SizedBox(height: 22),
                      AvenuePrimaryButton(
                        label: _isSubmitting
                            ? 'Generating...'
                            : 'Generate Access Pass',
                        icon: Icons.send_rounded,
                        onPressed: _createVisitorPass,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigation: AvenueBottomNavigationBar(
        items: _visitorNavItems,
        currentPage: AppPage.visitor,
      ),
    );
  }

  Future<void> _pickExpectedArrival() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _expectedArrival ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (pickedDate == null || !mounted) {
      return;
    }

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_expectedArrival ?? now),
    );
    if (pickedTime == null) {
      return;
    }

    final value = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      _expectedArrival = value;
      _arrivalController.text = _dateTimeLabel(value);
    });
  }

  Future<void> _pickVisitorType() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Guest', 'Delivery', 'Service']
                .map(
                  (label) => ListTile(
                    title: Text(label),
                    onTap: () => Navigator.of(context).pop(label),
                  ),
                )
                .toList(),
          ),
        );
      },
    );

    if (selected == null) {
      return;
    }

    setState(() {
      _visitorTypeController.text = selected;
    });
  }

  Future<void> _createVisitorPass() async {
    final visitorName = _visitorNameController.text.trim();
    final phone = _phoneController.text.trim();

    if (visitorName.isEmpty || phone.isEmpty || _expectedArrival == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter name, phone, and expected arrival.'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    Map<String, dynamic>? result;
    try {
      result = await _repository.createVisitorPass(
        visitorName: visitorName,
        phone: phone,
        visitorKind: _visitorKindValue(_visitorTypeController.text),
        expectedArrival: _expectedArrival!,
      );
    } catch (_) {
      result = null;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
      _visitorFuture = _VisitorData.load(_repository);
    });

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not generate visitor pass.')),
      );
      return;
    }

    _visitorNameController.clear();
    _phoneController.clear();
    _expectedArrival = DateTime.now().add(const Duration(hours: 1));
    _arrivalController.text = _dateTimeLabel(_expectedArrival);
    _visitorTypeController.text = 'Guest';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pass created. PIN: ${result['pin_code']}')),
    );
  }
}

class _ResidentScrollView extends StatelessWidget {
  const _ResidentScrollView({
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(14, 18, 14, 24),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: padding,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.label,
    required this.icon,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AvenueColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : AvenueColors.onSurfaceVariant,
              size: 22,
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: selected ? Colors.white : AvenueColors.onSurfaceVariant,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MaintenanceCard extends StatelessWidget {
  const _MaintenanceCard({
    required this.onPayTap,
    this.amount = '2200',
    this.dueDate,
  });

  final VoidCallback onPayTap;
  final String amount;
  final String? dueDate;

  @override
  Widget build(BuildContext context) {
    final displayAmount = amount.startsWith('₹') ? amount : '₹$amount';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AvenueColors.primaryGradient,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MAINTENANCE DUE',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.76),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      displayAmount,
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(color: Colors.white, fontSize: 22),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.receipt_long_rounded,
                color: Colors.white.withValues(alpha: 0.72),
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Due Date',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.78),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _calendarDateLabel(dueDate),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: 126,
                child: ElevatedButton(
                  onPressed: onPayTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AvenueColors.primary,
                    elevation: 0,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  child: const Text('Pay Now'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DataPlaceholderCard extends StatelessWidget {
  const _DataPlaceholderCard({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 18,
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AvenueColors.onSurfaceVariant),
      ),
    );
  }
}

class _QuickBillsRow extends StatelessWidget {
  const _QuickBillsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _CircleShortcut(
            icon: Icons.smartphone_rounded,
            label: 'Mobile',
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _CircleShortcut(
            icon: Icons.bolt_rounded,
            label: 'Electricity',
            iconColor: Color(0xFFDB7A00),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _CircleShortcut(
            icon: Icons.chat_bubble_rounded,
            label: 'DTH',
            iconColor: Color(0xFFFFB018),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _CircleShortcut(
            icon: Icons.play_arrow_rounded,
            label: 'Google Play',
          ),
        ),
      ],
    );
  }
}

class _CircleShortcut extends StatelessWidget {
  const _CircleShortcut({
    required this.icon,
    required this.label,
    this.iconColor = AvenueColors.primary,
  });

  final IconData icon;
  final String label;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x10000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AvenueColors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _FeatureActionCard extends StatelessWidget {
  const _FeatureActionCard({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      radius: 18,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationPreviewTile extends StatelessWidget {
  const _NotificationPreviewTile({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.timeLabel,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final String timeLabel;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 18,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    Text(
                      timeLabel,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AvenueColors.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBubble extends StatelessWidget {
  const _CategoryBubble({
    required this.icon,
    required this.label,
    required this.backgroundColor,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      radius: 18,
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AvenueColors.onSurfaceVariant, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AvenueColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmenityCard extends StatelessWidget {
  const _AmenityCard({
    required this.imageUrl,
    required this.status,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.primaryActionLabel,
    required this.onTap,
    this.statusBackground = const Color(0x22000000),
    this.statusForeground = Colors.white,
    this.outlinedButton = false,
  });

  final String imageUrl;
  final String status;
  final String title;
  final String subtitle;
  final IconData icon;
  final String primaryActionLabel;
  final VoidCallback onTap;
  final Color statusBackground;
  final Color statusForeground;
  final bool outlinedButton;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 18,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeroImageCard(
            imageUrl: imageUrl,
            height: 156,
            borderRadius: 18,
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: AvenuePill(
                  label: status,
                  backgroundColor: statusBackground,
                  foregroundColor: statusForeground,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AvenueColors.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: AvenueColors.surfaceLow,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 16, color: AvenueColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (outlinedButton)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: onTap,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AvenueColors.primary,
                        shape: const StadiumBorder(),
                        side: BorderSide(
                          color: AvenueColors.outlineVariant.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                      child: Text(primaryActionLabel),
                    ),
                  )
                else
                  AvenuePrimaryButton(
                    label: primaryActionLabel,
                    onPressed: onTap,
                    height: 42,
                    fontSize: 14,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroImageCard extends StatelessWidget {
  const _HeroImageCard({
    required this.imageUrl,
    required this.height,
    required this.child,
    this.borderRadius = 28,
  });

  final String imageUrl;
  final double height;
  final Widget child;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(imageUrl, fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xA6000000), Color(0x1A000000)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.dayLabel,
    required this.dateLabel,
    this.selected = false,
  });

  final String dayLabel;
  final String dateLabel;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: selected ? AvenueColors.primaryFixed : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? AvenueColors.primary : AvenueColors.outlineVariant,
        ),
      ),
      child: Column(
        children: [
          Text(
            dayLabel,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: selected ? AvenueColors.primary : AvenueColors.outline,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            dateLabel,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: selected ? AvenueColors.primary : AvenueColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: selected ? AvenueColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? AvenueColors.primary : AvenueColors.outlineVariant,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wb_sunny_outlined,
            size: 15,
            color: selected ? Colors.white : AvenueColors.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: selected ? Colors.white : AvenueColors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({required this.icon, this.filled = false});

  final IconData icon;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? AvenueColors.primary : Colors.white,
        border: Border.all(color: AvenueColors.outlineVariant),
      ),
      child: Icon(
        icon,
        size: 18,
        color: filled ? Colors.white : AvenueColors.onSurfaceVariant,
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 7),
          decoration: const BoxDecoration(
            color: AvenueColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AvenueColors.onSurfaceVariant,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _BookingSummaryRow extends StatelessWidget {
  const _BookingSummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AvenueColors.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _InfoMiniCard extends StatelessWidget {
  const _InfoMiniCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AvenueColors.surfaceLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AvenueColors.primary, size: 18),
          const SizedBox(height: 10),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AvenueColors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _EquipmentChip extends StatelessWidget {
  const _EquipmentChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: Color(0xFFE8EEFF),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AvenueColors.primary, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? AvenueColors.primary : AvenueColors.surfaceLow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: selected ? Colors.white : AvenueColors.onSurfaceVariant,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _UrgentNoticeCard extends StatelessWidget {
  const _UrgentNoticeCard({
    required this.title,
    required this.dateText,
    required this.body,
    required this.actionLabel,
  });

  final String title;
  final String dateText;
  final String body;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 18,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AvenuePill(
                label: 'URGENT',
                backgroundColor: Color(0xFFFFE2E0),
                foregroundColor: Color(0xFFD33B2C),
              ),
              const Spacer(),
              Text(dateText, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AvenueColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '$actionLabel →',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFFD33B2C),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _EventNoticeCard extends StatelessWidget {
  const _EventNoticeCard({
    required this.imageUrl,
    required this.title,
    required this.monthLabel,
    required this.dayLabel,
    required this.category,
    required this.buttonLabel,
    required this.onTap,
  });

  final String imageUrl;
  final String title;
  final String monthLabel;
  final String dayLabel;
  final String category;
  final String buttonLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 18,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _HeroImageCard(
            imageUrl: imageUrl,
            height: 188,
            borderRadius: 18,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 50,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(
                            monthLabel,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            dayLabel,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AvenuePill(
                          label: category,
                          backgroundColor: Color(0x22000000),
                          foregroundColor: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          title,
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Row(
              children: [
                const Expanded(child: _EventAttendees()),
                const SizedBox(width: 12),
                SizedBox(
                  width: 94,
                  child: AvenuePrimaryButton(
                    label: buttonLabel,
                    onPressed: onTap,
                    height: 40,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventAttendees extends StatelessWidget {
  const _EventAttendees();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            shape: BoxShape.circle,
            image: const DecorationImage(
              image: NetworkImage(_priyaAvatarUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(-8, 0),
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              shape: BoxShape.circle,
              image: const DecorationImage(
                image: NetworkImage(_arjunAvatarUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(-16, 0),
          child: Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AvenueColors.surfaceHigh,
              border: Border.all(color: Colors.white, width: 2),
              shape: BoxShape.circle,
            ),
            child: Text(
              '+42',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}

class _StandardNoticeCard extends StatelessWidget {
  const _StandardNoticeCard({
    required this.title,
    required this.category,
    required this.dateText,
    required this.body,
    required this.icon,
    required this.iconColor,
    this.cta,
  });

  final String title;
  final String category;
  final String dateText;
  final String body;
  final IconData icon;
  final Color iconColor;
  final String? cta;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 18,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: AvenueColors.surfaceLow,
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AvenuePill(
                      label: category,
                      backgroundColor: AvenueColors.surfaceHigh,
                      foregroundColor: AvenueColors.onSurfaceVariant,
                    ),
                    const Spacer(),
                    Text(
                      dateText,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AvenueColors.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                if (cta != null) ...[
                  const SizedBox(height: 14),
                  Text(
                    cta!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AvenueColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BillAccountCard extends StatelessWidget {
  const _BillAccountCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.metaLabel,
    required this.amount,
    this.buttonLabel,
    this.amountColor = AvenueColors.onSurface,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String badgeText;
  final Color badgeColor;
  final Color badgeTextColor;
  final String metaLabel;
  final String amount;
  final String? buttonLabel;
  final Color amountColor;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 20,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AvenueColors.surfaceLow,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AvenueColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badgeText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: badgeTextColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    metaLabel,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    amount,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: amountColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (buttonLabel != null) ...[
            const SizedBox(height: 16),
            AvenuePrimaryButton(
              label: buttonLabel!,
              onPressed: () {},
              height: 42,
              fontSize: 14,
            ),
          ],
        ],
      ),
    );
  }
}

class _QuickPayCard extends StatelessWidget {
  const _QuickPayCard({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.note,
    this.dark = false,
  });

  final String title;
  final String subtitle;
  final IconData trailing;
  final String note;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: dark ? const Color(0xFF22272B) : Colors.white,
        border: dark
            ? null
            : Border.all(
                color: AvenueColors.outlineVariant.withValues(alpha: 0.3),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: dark
                      ? Colors.white.withValues(alpha: 0.8)
                      : AvenueColors.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Icon(
                trailing,
                color: dark ? Colors.white : AvenueColors.primary,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: dark ? Colors.white : AvenueColors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            note,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: dark
                  ? Colors.white.withValues(alpha: 0.7)
                  : AvenueColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentActivityTile extends StatelessWidget {
  const _PaymentActivityTile({
    required this.icon,
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
  });

  final IconData icon;
  final String title;
  final String date;
  final String amount;
  final String status;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 18,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: AvenueColors.surfaceLow,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AvenueColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(date, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 2),
              Text(
                status,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF2E9A53),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TabToggle extends StatelessWidget {
  const _TabToggle({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x10000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: selected
                    ? AvenueColors.primary
                    : AvenueColors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: selected
                    ? AvenueColors.primary
                    : AvenueColors.surfaceHigh,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                count,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: selected
                      ? Colors.white
                      : AvenueColors.onSurfaceVariant,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComplaintCard extends StatelessWidget {
  const _ComplaintCard({
    required this.accentColor,
    required this.complaintId,
    required this.timestamp,
    required this.status,
    required this.statusColor,
    required this.title,
    required this.description,
    required this.icon,
    required this.metaLabel,
    required this.metaValue,
    required this.metaIcon,
  });

  final Color accentColor;
  final String complaintId;
  final String timestamp;
  final String status;
  final Color statusColor;
  final String title;
  final String description;
  final IconData icon;
  final String metaLabel;
  final String metaValue;
  final IconData metaIcon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AvenueCard(
          radius: 18,
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '$complaintId  •  $timestamp',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  AvenuePill(
                    label: status,
                    backgroundColor: statusColor.withValues(alpha: 0.1),
                    foregroundColor: statusColor,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: AvenueColors.onSurfaceVariant, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AvenueColors.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 14),
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: AvenueColors.surfaceLow,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      metaIcon,
                      size: 18,
                      color: AvenueColors.outline,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          metaLabel,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          metaValue,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'View Details',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AvenueColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          child: Container(
            width: 4,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileFieldRow extends StatelessWidget {
  const _ProfileFieldRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const Icon(Icons.edit_rounded, color: AvenueColors.outline, size: 18),
      ],
    );
  }
}

class _FamilyMemberChip extends StatelessWidget {
  const _FamilyMemberChip({
    required this.imageUrl,
    required this.name,
    required this.relation,
  });

  final String imageUrl;
  final String name;
  final String relation;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AvenueColors.surfaceLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          AvenueNetworkAvatar(
            imageUrl: imageUrl,
            size: 34,
            fallbackLabel: name[0],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(relation, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationDetailCard extends StatelessWidget {
  const _NotificationDetailCard({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    required this.time,
    this.body,
    this.unread = false,
    this.actionLabel,
    this.label,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String? body;
  final String time;
  final bool unread;
  final String? actionLabel;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 0,
      padding: const EdgeInsets.all(18),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (label != null) ...[
                      AvenuePill(
                        label: label!,
                        backgroundColor: const Color(0xFFFFE2E0),
                        foregroundColor: const Color(0xFFD33B2C),
                      ),
                      const SizedBox(height: 10),
                    ],
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (body != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        body!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AvenueColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Text(time, style: Theme.of(context).textTheme.bodySmall),
                    if (actionLabel != null) ...[
                      const SizedBox(height: 14),
                      SizedBox(
                        width: 120,
                        child: AvenuePrimaryButton(
                          label: actionLabel!,
                          onPressed: () {},
                          height: 38,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (unread)
            const Positioned(
              top: 2,
              right: 2,
              child: CircleAvatar(
                radius: 4,
                backgroundColor: AvenueColors.primary,
              ),
            ),
        ],
      ),
    );
  }
}

class _ReadNotificationCard extends StatelessWidget {
  const _ReadNotificationCard({
    required this.title,
    required this.time,
    this.avatarUrl,
    this.icon,
    this.thumbnailUrl,
  });

  final String title;
  final String time;
  final String? avatarUrl;
  final IconData? icon;
  final String? thumbnailUrl;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 0,
      padding: const EdgeInsets.all(18),
      child: Opacity(
        opacity: 0.84,
        child: Row(
          children: [
            if (avatarUrl != null)
              AvenueNetworkAvatar(
                imageUrl: avatarUrl!,
                size: 46,
                fallbackLabel: 'J',
              )
            else
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5E8DE),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFFC37F4E)),
              ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(time, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            if (thumbnailUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  thumbnailUrl!,
                  width: 62,
                  height: 62,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
