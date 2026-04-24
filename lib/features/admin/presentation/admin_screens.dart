import 'package:flutter/material.dart';

import '../../../app/app_page.dart';
import '../../../core/session/app_session.dart';
import '../../../core/supabase/avenue_repository.dart';
import '../../../theme/avenue_theme.dart';
import '../../common/presentation/avenue_ui.dart';

const _adminAvatarUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAZdFL4zMKpNZY3_fSbha5C3gXuInFJaXecNCbr8iBFFz3_w2bT1u7sKXRKA_mGeEYUQRsvR6eYozhpVULtvbYT9UoajJMm5eOURoEbprw28WXIA5zbhb5Ox0YHGWo9VHVwLVgRHuFVLggQJLb9hR6m_XYNdwFDr9tpKVicHa-zB3dRt8pemssN2VpGkDJUE_Wkh91T9sEPQPUAyMjsHT_EyPel3i6My0wSuuSYWr8hb2rsuudulKvCjbBKLoNIPvgf9YXQ-CcHEEQ';
const _adminPoolImageUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBHlXE471JI_rxZOvC-VmnlfysBPnbXMlcwpL3qlC33A7y6t2-Z17iCgzu9XS4e_ButnElRXH_7ymGivr_qrHoAX-jEo5VQXwUoEFYcKDrZZGHcXQ5jGz0E2MolSAyKmb53nkJGrgXDpWicN698nKfOrplGHwdmknl-lcJ8S-NPwY8x7ETFqRSu7knUjqeZr5uiil_8mJ_A_egnSnGrK0wy3fLo8lyNxZFuNKNgnNQwpIqNjIIgEU4roRdghHGvhbCF33VUIBoTM0U';
const _adminGymImageUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBPGVX3nOn0x2e0r2yIycLDNQbb5onHNIbrf5aIn0G0Gl_HeczTENjKauCTB5z5IjvHgPwpVzBB99LxOu1FUNBn_XhTXMmemtWX5tCh5m_Zfj0IAyjlKImoHMqn5qCxwmjUEyHbLEakkQ1SEKAVbTM7RH9ESMTnR7ykayoGJGGPmWmgiGFXyAZkgmsPiygzZYih661UnuQbFYgA9WbTz-UNVIopAyMucFDLZ0KPQKDCkwf-Jh_iVVzCjFrcwqGcmKgS1fkJApO-a4Q';
const _directoryAlexanderUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuC32Kqzc8hRfEl30abJX8cYdzhotEi9MmUJpFNRfh95XicxdQKc65kyv7gtwjGRV_qoCzJkMDLsJ0n5yaDEJJFOZRIigb8ghLEmzdzV-TH7b-ih7qkJHPsk2Pc58vSBg3RsNIBENYD9_NvrLjRTu1xKz7Hz7o8-3NWuVhBBooJKrKEOrJ22auh1kWg2Irl4Bhuhc2UOPTTkB3ifRkGCJgeC4BlKG4Zf-uMWwRWzW2z-9ZM5fqUtHkCWxbjqUek-xK5--3hWARc-kvE';
const _directoryElenaUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuA22ac2iJWFcfipaGs-c_Rh30BWOTzg9N9cBDeQU0pwEq3wCxZQKBhpwz08kbzesBHABsDFYdg1zKvI4HKwUTEDpqcude1pLlyppDQbZqqzRH6nf4BzMC9lnqgFSYnl1cFtX3bNyLVw66iNU5pf0wtiqs80ZL8CsrcAVZetJ39TAoWGzoXl4neGMTh-TRgidTL0F-WabmXN7alGEWcmTcx_5LECQWI3EWdJo7MalI76xHTM_R9s78y_Z6OMAaz3GTbg0hCk9gdl8H0';
const _directoryJamesonUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuDhQGZkrWHLcYz22-wvqHsQysY6YWsLEvmsTYrZ-g0tXR5xLwRHapYKISw-LJEhUuvaSlvK658_qUXUkbuwp7_UAHiqssa_JZtCVzkaL1BTvqWcyRW2Jiafwtw-ttIlgFiEuGUqOCR1nQ33EDJTWI3khAPanZtT2Py-pHw6sJrdMQpA1DhotH37AbP9lrgbcV3lfMnfMFmxexpJ_DpWHDGJ5Dor2zaGPFyRUJfK10xrgpIG1opaunVb39f2BWv6ypDJ5QF8NSzUdxI';
const _directorySarahUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAa9Fcyhcd6jceLaLL5PsHjvHDigIiKR46attnbZW4Cx7tpYziXKIJUmrePKwm0eVqUW4n7wgUl28pwTIDKrwH9usdM4C_FUAGnwmVcb4T7f0XO5fg0FsB7Sa2hBElLEYyt1CrZ4YBP6pfKRrCEOfbb_clPt5S2VvSD5MwTNs7Fb2ksNkXUi6I_tc1JXlQxULaY6tPmruzpP_oswQ0M6gAMJAUmHIg9alhUcskNQgPNhmFFa6jIXoqXKKWW47nT7JM-W0tQbjtIpvE';

final _adminNavItems = [
  const AvenueNavItem(
    label: 'HOME',
    icon: Icons.home_rounded,
    page: AppPage.adminDrawer,
  ),
  const AvenueNavItem(
    label: 'RESIDENTS',
    icon: Icons.group_outlined,
    page: AppPage.residentDirectory,
  ),
  const AvenueNavItem(
    label: 'NOTIFY',
    icon: Icons.campaign_outlined,
    page: AppPage.announcementsManagement,
  ),
  const AvenueNavItem(
    label: 'REPORTS',
    icon: Icons.summarize_outlined,
    page: AppPage.generateReports,
  ),
];

class _AdminPalette {
  static const background = Color(0xFFF3FAFF);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceLow = Color(0xFFEAF5FC);
  static const ink = Color(0xFF121D22);
  static const muted = Color(0xFF5D6872);
  static const outline = Color(0xFFC8D6DE);
  static const shadow = Color(0x14005EA3);
  static const success = Color(0xFF1E8E5A);
  static const warning = Color(0xFF946200);
  static const danger = Color(0xFFD6453A);
}

String _initialsFromName(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();

  if (parts.isEmpty) {
    return 'A';
  }
  if (parts.length == 1) {
    return parts.first.substring(0, 1).toUpperCase();
  }

  return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
      .toUpperCase();
}

String? _directoryImageForName(String name) {
  switch (name) {
    case 'Alexander Sterling':
      return _directoryAlexanderUrl;
    case 'Elena Rodriguez':
      return _directoryElenaUrl;
    case 'Jameson Chen':
      return _directoryJamesonUrl;
    case 'Sarah Jenkins':
      return _directorySarahUrl;
    default:
      return null;
  }
}

String _normalize(String value) => value.trim().toLowerCase();

Color _residentStatusColor(String? status) {
  switch (_normalize(status ?? '')) {
    case 'active':
      return _AdminPalette.success;
    case 'pending':
      return _AdminPalette.warning;
    case 'expired':
      return _AdminPalette.danger;
    default:
      return _AdminPalette.muted;
  }
}

String _announcementKindLabel(String? kind) {
  switch (_normalize(kind ?? '')) {
    case 'urgent':
      return 'Urgent';
    case 'event':
      return 'Event';
    case 'facility':
      return 'Facility';
    default:
      return 'General';
  }
}

Color _announcementKindColor(String? kind) {
  switch (_normalize(kind ?? '')) {
    case 'urgent':
      return AvenueColors.primary;
    case 'event':
      return const Color(0xFF946200);
    case 'facility':
      return const Color(0xFF0D7A92);
    default:
      return _AdminPalette.muted;
  }
}

String _timeAgoLabel(dynamic value) {
  if (value == null) {
    return '-';
  }

  final parsed = DateTime.tryParse(value.toString());
  if (parsed == null) {
    return value.toString();
  }

  final difference = DateTime.now().difference(parsed.toLocal());
  if (difference.inMinutes < 60) {
    final minutes = difference.inMinutes.clamp(1, 59);
    return '$minutes min ago';
  }
  if (difference.inHours < 24) {
    return '${difference.inHours}h ago';
  }
  if (difference.inDays == 1) {
    return 'Yesterday';
  }

  return '${difference.inDays}d ago';
}

String _formatCurrency(dynamic value) {
  final amount = double.tryParse(value?.toString() ?? '') ?? 0;
  final prefix = amount >= 0 ? '+' : '-';
  final absolute = amount.abs().toStringAsFixed(0);
  return '$prefix₹$absolute';
}

String _formatMetricValue(dynamic value) {
  if (value == null) {
    return '--';
  }

  if (value is num) {
    if (value >= 1000) {
      return value.toStringAsFixed(0);
    }
    return value.toString();
  }

  return value.toString();
}

void _openAdminMenu(BuildContext context, AppPage currentPage) {
  Navigator.of(
    context,
  ).pushNamed(AppPage.adminMenu.routeName, arguments: currentPage);
}

void _goBackOrAdminHome(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
    return;
  }

  goToPage(context, AppPage.adminDrawer, replace: true);
}

class _AdminDashboardData {
  const _AdminDashboardData({
    required this.metrics,
    required this.transactions,
  });

  final Map<String, dynamic>? metrics;
  final List<Map<String, dynamic>> transactions;

  static Future<_AdminDashboardData> load(AvenueRepository repository) async {
    final results = await Future.wait([
      repository.fetchAdminMetrics(),
      repository.fetchAdminTransactions(),
    ]);

    return _AdminDashboardData(
      metrics: results[0] as Map<String, dynamic>?,
      transactions: results[1] as List<Map<String, dynamic>>,
    );
  }
}

class _AnnouncementsData {
  const _AnnouncementsData(this.rows);

  final List<Map<String, dynamic>> rows;

  static Future<_AnnouncementsData> load(AvenueRepository repository) async {
    final rows = await repository.fetchAnnouncements();
    return _AnnouncementsData(rows);
  }
}

class AdminDrawerScreen extends StatelessWidget {
  const AdminDrawerScreen({super.key, this.currentPage = AppPage.adminDrawer});

  final AppPage currentPage;

  @override
  Widget build(BuildContext context) {
    final currentUser = AppSession.instance.currentUser;
    final avatarUrl = currentUser?.avatarUrl ?? _adminAvatarUrl;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.black.withValues(alpha: 0.32)),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: SafeArea(
              child: Container(
                width: 320,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: _AdminPalette.surface,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x26000000),
                      blurRadius: 36,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 18, 18),
                      child: Row(
                        children: [
                          Text(
                            'Avenue360',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: AvenueColors.primary,
                                ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close_rounded),
                            color: _AdminPalette.muted,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _AdminPalette.surfaceLow,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: _AdminPalette.outline.withValues(alpha: 0.45),
                          ),
                        ),
                        child: Row(
                          children: [
                            AvenueNetworkAvatar(
                              imageUrl: avatarUrl,
                              size: 56,
                              borderWidth: 2,
                              fallbackLabel: currentUser?.initials ?? 'M',
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentUser?.fullName ?? 'Marcus Sterling',
                                    style: Theme.of(context).textTheme.titleLarge
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    currentUser?.subtitle ?? 'Estate Manager',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: _AdminPalette.muted,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  const _AdminTag(
                                    label: 'ADMIN ACCESS',
                                    background: Color(0x1A005BBF),
                                    foreground: AvenueColors.primary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        children: [
                          _AdminDrawerNavItem(
                            label: 'Dashboard',
                            icon: Icons.dashboard_rounded,
                            selected: currentPage == AppPage.adminDrawer,
                            onTap: () => goToPage(
                              context,
                              AppPage.adminDrawer,
                              replace: true,
                            ),
                          ),
                          _AdminDrawerNavItem(
                            label: 'Resident Directory',
                            icon: Icons.group_rounded,
                            selected: currentPage == AppPage.residentDirectory,
                            onTap: () => goToPage(
                              context,
                              AppPage.residentDirectory,
                              replace: true,
                            ),
                          ),
                          _AdminDrawerNavItem(
                            label: 'Announcements',
                            icon: Icons.campaign_rounded,
                            selected:
                                currentPage ==
                                AppPage.announcementsManagement,
                            onTap: () => goToPage(
                              context,
                              AppPage.announcementsManagement,
                              replace: true,
                            ),
                          ),
                          _AdminDrawerNavItem(
                            label: 'Generate Reports',
                            icon: Icons.summarize_rounded,
                            selected: currentPage == AppPage.generateReports,
                            onTap: () => goToPage(
                              context,
                              AppPage.generateReports,
                              replace: true,
                            ),
                          ),
                          _AdminDrawerNavItem(
                            label: 'Add Resident',
                            icon: Icons.person_add_alt_1_rounded,
                            selected: false,
                            onTap: () => goToPage(context, AppPage.addResident),
                          ),
                          const SizedBox(height: 20),
                          const _AdminSupportCard(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
                      child: TextButton.icon(
                        onPressed: () {
                          AppSession.instance.clear();
                          goToPage(context, AppPage.login, replace: true);
                        },
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: _AdminPalette.danger,
                        ),
                        label: Text(
                          'Logout',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: _AdminPalette.danger,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        style: TextButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();
    final currentUser = AppSession.instance.currentUser;

    return _AdminScaffold(
      currentPage: AppPage.adminDrawer,
      topBar: _AdminTopBar(
        title: 'COVE',
        leadingIcon: Icons.menu_rounded,
        onLeadingTap: () => _openAdminMenu(context, AppPage.adminDrawer),
      ),
      child: FutureBuilder<_AdminDashboardData>(
        future: _AdminDashboardData.load(repository),
        builder: (context, snapshot) {
          final metrics = snapshot.data?.metrics;
          final transactions =
              snapshot.data?.transactions ?? const <Map<String, dynamic>>[];

          final activityRows = <_AdminActivityModel>[
            if (transactions.isNotEmpty)
              ...transactions.take(2).map(
                (row) => _AdminActivityModel(
                  icon: row['icon_name'] == 'flash_on'
                      ? Icons.bolt_rounded
                      : Icons.receipt_long_rounded,
                  tint: row['icon_name'] == 'flash_on'
                      ? const Color(0xFFE4F2FF)
                      : const Color(0xFFFFF1C8),
                  title: row['title'] as String? ?? 'Transaction',
                  subtitle: row['subtitle'] as String? ?? '',
                  trailing: _formatCurrency(row['amount']),
                ),
              ),
            _AdminActivityModel(
              icon: Icons.person_add_alt_1_rounded,
              tint: const Color(0xFFE7F6EE),
              title: 'Residents onboarded',
              subtitle:
                  '${_formatMetricValue(metrics?['active_residents'])} active residents in the community',
              trailing: 'Live',
            ),
            _AdminActivityModel(
              icon: Icons.report_problem_rounded,
              tint: const Color(0xFFFFE9E6),
              title: 'Open complaints',
              subtitle:
                  '${_formatMetricValue(metrics?['open_complaints'])} pending issue${_formatMetricValue(metrics?['open_complaints']) == '1' ? '' : 's'} awaiting resolution',
              trailing: 'Today',
            ),
          ];

          return _AdminBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning,',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _AdminPalette.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Overview',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.2,
                    color: _AdminPalette.ink,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Welcome back, ${currentUser?.fullName.split(' ').first ?? 'Marcus'}. Here is what is happening across Avenue360 today.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _AdminPalette.muted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.1,
                  children: [
                    _AdminMetricTile(
                      icon: Icons.group_rounded,
                      label: 'Total Residents',
                      value: snapshot.connectionState != ConnectionState.done
                          ? '...'
                          : _formatMetricValue(metrics?['active_residents']),
                    ),
                    _AdminMetricTile(
                      icon: Icons.payments_rounded,
                      label: 'Revenue',
                      value: snapshot.connectionState != ConnectionState.done
                          ? '...'
                          : _formatCurrency(metrics?['total_collected']),
                      highlighted: true,
                    ),
                    _AdminMetricTile(
                      icon: Icons.report_problem_rounded,
                      label: 'Pending Complaints',
                      value: snapshot.connectionState != ConnectionState.done
                          ? '...'
                          : _formatMetricValue(metrics?['open_complaints']),
                    ),
                    _AdminMetricTile(
                      icon: Icons.event_available_rounded,
                      label: 'Active Visitors',
                      value: snapshot.connectionState != ConnectionState.done
                          ? '...'
                          : _formatMetricValue(
                              metrics?['active_visitor_passes'],
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                _AdminSectionHeading(title: 'Quick Actions'),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _AdminQuickActionButton(
                        icon: Icons.person_add_alt_1_rounded,
                        label: 'Add Resident',
                        emphasized: true,
                        onTap: () => goToPage(context, AppPage.addResident),
                      ),
                      const SizedBox(width: 10),
                      _AdminQuickActionButton(
                        icon: Icons.campaign_rounded,
                        label: 'Post Notice',
                        onTap: () => Navigator.of(context).pushNamed(
                          AppPage.announcementsManagement.routeName,
                          arguments: {'openComposer': true},
                        ),
                      ),
                      const SizedBox(width: 10),
                      _AdminQuickActionButton(
                        icon: Icons.summarize_rounded,
                        label: 'Generate Report',
                        onTap: () => goToPage(context, AppPage.generateReports),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                _AdminSectionHeading(title: 'Featured Spaces'),
                const SizedBox(height: 12),
                _AdminFeatureCard(
                  imageUrl: _adminPoolImageUrl,
                  title: 'The Sky Pool',
                  badge: 'OPEN',
                ),
                const SizedBox(height: 14),
                _AdminFeatureCard(
                  imageUrl: _adminGymImageUrl,
                  title: 'Zenith Gym',
                  badge: 'ACTIVE',
                ),
                const SizedBox(height: 14),
                _AdminGlassCard(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => goToPage(context, AppPage.residentDirectory),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: _AdminPalette.surfaceLow,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.group_add_rounded,
                              color: AvenueColors.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Manage Residents',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Open the directory, review verification status, and onboard new residents.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: _AdminPalette.muted,
                                  height: 1.5,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                _AdminSectionHeading(
                  title: 'Recent Activity',
                  actionLabel: 'View All',
                  onActionTap: () => goToPage(
                    context,
                    AppPage.announcementsManagement,
                  ),
                ),
                const SizedBox(height: 12),
                if (snapshot.connectionState != ConnectionState.done &&
                    transactions.isEmpty)
                  const _AdminEmptyState(
                    label: 'Loading current admin activity...',
                  )
                else
                  ...activityRows.take(4).map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _AdminActivityTile(model: row),
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

class GenerateReportsScreen extends StatefulWidget {
  const GenerateReportsScreen({super.key});

  @override
  State<GenerateReportsScreen> createState() => _GenerateReportsScreenState();
}

class _GenerateReportsScreenState extends State<GenerateReportsScreen> {
  String _reportType = 'financial';
  String _dateRange = 'today';
  String _format = 'pdf';

  @override
  Widget build(BuildContext context) {
    return _AdminScaffold(
      currentPage: AppPage.generateReports,
      topBar: _AdminTopBar(
        title: 'Generate Reports',
        leadingIcon: Icons.arrow_back_rounded,
        onLeadingTap: () => _goBackOrAdminHome(context),
      ),
      child: _AdminBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _AdminTag(
              label: 'INTELLIGENCE SUITE',
              background: Color(0x1A005BBF),
              foreground: AvenueColors.primary,
            ),
            const SizedBox(height: 14),
            Text(
              'Configure Your Intelligence',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: 32,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select the parameters that shape a polished document for finance, occupancy, amenities, or maintenance.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: _AdminPalette.muted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const _AdminSectionLabel(text: '1. SELECT REPORT TYPE'),
            const SizedBox(height: 12),
            _ReportOptionCard(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Financial Summary',
              subtitle:
                  'Revenue, dues collection, and expense allocation for the selected period.',
              selected: _reportType == 'financial',
              onTap: () => setState(() => _reportType = 'financial'),
            ),
            const SizedBox(height: 10),
            _ReportOptionCard(
              icon: Icons.group_outlined,
              title: 'Resident Directory',
              subtitle:
                  'Occupancy, contact verification, and ownership distribution across the community.',
              selected: _reportType == 'residents',
              onTap: () => setState(() => _reportType = 'residents'),
            ),
            const SizedBox(height: 10),
            _ReportOptionCard(
              icon: Icons.pool_outlined,
              title: 'Amenity Usage',
              subtitle:
                  'Space bookings, demand peaks, and utilization patterns for premium facilities.',
              selected: _reportType == 'amenities',
              onTap: () => setState(() => _reportType = 'amenities'),
            ),
            const SizedBox(height: 10),
            _ReportOptionCard(
              icon: Icons.build_circle_outlined,
              title: 'Maintenance Logs',
              subtitle:
                  'Complaint lifecycle, pending issue count, and resolution timelines.',
              selected: _reportType == 'maintenance',
              onTap: () => setState(() => _reportType = 'maintenance'),
            ),
            const SizedBox(height: 24),
            const _AdminSectionLabel(text: '2. DATE RANGE'),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _ReportDateChip(
                    label: 'Today',
                    selected: _dateRange == 'today',
                    onTap: () => setState(() => _dateRange = 'today'),
                  ),
                  const SizedBox(width: 8),
                  _ReportDateChip(
                    label: 'This Month',
                    selected: _dateRange == 'month',
                    onTap: () => setState(() => _dateRange = 'month'),
                  ),
                  const SizedBox(width: 8),
                  _ReportDateChip(
                    label: 'Last Quarter',
                    selected: _dateRange == 'quarter',
                    onTap: () => setState(() => _dateRange = 'quarter'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const _AdminFormField(
              label: 'CUSTOM RANGE',
              hintText: '01 Oct 2023 - 31 Oct 2023',
              icon: Icons.calendar_today_rounded,
            ),
            const SizedBox(height: 24),
            const _AdminSectionLabel(text: '3. OUTPUT FORMAT'),
            const SizedBox(height: 12),
            _AdminGlassCard(
              child: Column(
                children: [
                  _ReportFormatRow(
                    icon: Icons.picture_as_pdf_rounded,
                    title: 'PDF Document',
                    iconColor: const Color(0xFFE04C3B),
                    selected: _format == 'pdf',
                    onTap: () => setState(() => _format = 'pdf'),
                  ),
                  const Divider(height: 1),
                  _ReportFormatRow(
                    icon: Icons.table_chart_rounded,
                    title: 'Excel Spreadsheet',
                    iconColor: const Color(0xFF1E8E5A),
                    selected: _format == 'xlsx',
                    onTap: () => setState(() => _format = 'xlsx'),
                  ),
                  const Divider(height: 1),
                  _ReportFormatRow(
                    icon: Icons.description_outlined,
                    title: 'CSV File',
                    iconColor: AvenueColors.primary,
                    selected: _format == 'csv',
                    onTap: () => setState(() => _format = 'csv'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const _AdminInfoBanner(
              icon: Icons.auto_awesome_rounded,
              title: 'REPORT INTELLIGENCE',
              body:
                  'Generating this document compiles live estate records into a presentation-ready export for management review.',
            ),
            const SizedBox(height: 24),
            AvenuePrimaryButton(
              label: 'Generate Report',
              icon: Icons.auto_awesome_rounded,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Report generation UI is ready. Export logic can be connected next.',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AnnouncementsManagementScreen extends StatefulWidget {
  const AnnouncementsManagementScreen({
    super.key,
    this.openComposerOnStart = false,
  });

  final bool openComposerOnStart;

  @override
  State<AnnouncementsManagementScreen> createState() =>
      _AnnouncementsManagementScreenState();
}

class _AnnouncementsManagementScreenState
    extends State<AnnouncementsManagementScreen> {
  final AvenueRepository _repository = AvenueRepository();
  late Future<_AnnouncementsData> _announcementsFuture;

  String _selectedState = 'sent';
  int _visibleRows = 6;
  bool _composerShown = false;

  @override
  void initState() {
    super.initState();
    _announcementsFuture = _AnnouncementsData.load(_repository);

    if (widget.openComposerOnStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_composerShown) {
          _composerShown = true;
          _showCreateAnnouncementSheet();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _AdminScaffold(
      currentPage: AppPage.announcementsManagement,
      topBar: _AdminTopBar(
        title: 'Announcements',
        leadingIcon: Icons.menu_rounded,
        onLeadingTap: () => _openAdminMenu(
          context,
          AppPage.announcementsManagement,
        ),
        trailing: IconButton(
          onPressed: () {
            setState(() {
              _announcementsFuture = _AnnouncementsData.load(_repository);
            });
          },
          icon: const Icon(Icons.refresh_rounded),
          color: _AdminPalette.muted,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateAnnouncementSheet,
        backgroundColor: AvenueColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
      ),
      child: FutureBuilder<_AnnouncementsData>(
        future: _announcementsFuture,
        builder: (context, snapshot) {
          final rows = snapshot.data?.rows ?? const <Map<String, dynamic>>[];
          final filteredRows = rows.where((row) {
            final state = _normalize(row['state']?.toString() ?? '');
            return state == _selectedState;
          }).toList();
          final visibleRows = filteredRows.take(_visibleRows).toList();

          return _AdminBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _AnnouncementStateTab(
                        label: 'Sent Notices',
                        selected: _selectedState == 'sent',
                        onTap: () => setState(() {
                          _selectedState = 'sent';
                          _visibleRows = 6;
                        }),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _AnnouncementStateTab(
                        label: 'Scheduled',
                        selected: _selectedState == 'scheduled',
                        onTap: () => setState(() {
                          _selectedState = 'scheduled';
                          _visibleRows = 6;
                        }),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _AnnouncementStateTab(
                        label: 'Drafts',
                        selected: _selectedState == 'draft',
                        onTap: () => setState(() {
                          _selectedState = 'draft';
                          _visibleRows = 6;
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Text(
                      'Recent History',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Showing last 30 days',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _AdminPalette.muted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (snapshot.connectionState != ConnectionState.done &&
                    filteredRows.isEmpty)
                  const _AdminEmptyState(
                    label: 'Loading announcement history...',
                  )
                else if (filteredRows.isEmpty)
                  _AdminEmptyState(
                    label: _selectedState == 'sent'
                        ? 'No sent announcements yet.'
                        : _selectedState == 'scheduled'
                        ? 'No scheduled announcements yet.'
                        : 'No saved drafts yet.',
                  )
                else
                  ...visibleRows.map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _AnnouncementHistoryCard(
                        category: _announcementKindLabel(
                          row['kind'] as String?,
                        ),
                        categoryColor: _announcementKindColor(
                          row['kind'] as String?,
                        ),
                        timestamp: _timeAgoLabel(row['created_at']),
                        title: row['title'] as String? ?? 'Announcement',
                        body: row['body'] as String? ?? '',
                        reads:
                            '${row['reads_count']?.toString() ?? '0'} Reads',
                        audience:
                            row['target_audience'] as String? ?? 'Residents',
                      ),
                    ),
                  ),
                if (filteredRows.length > _visibleRows) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _visibleRows += 6;
                        });
                      },
                      icon: Text(
                        'Load More History',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AvenueColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      label: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AvenueColors.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showCreateAnnouncementSheet() async {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    final audienceController = TextEditingController(text: 'All Residents');
    String selectedKind = 'general';
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
                top: 30,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: _AdminGlassCard(
                radius: 30,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'New Announcement',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Compose a notice that appears in the resident notice board and triggers live updates.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _AdminPalette.muted,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _AdminComposerField(
                      label: 'Title',
                      hintText: 'Water supply update',
                      controller: titleController,
                    ),
                    const SizedBox(height: 12),
                    _AdminComposerField(
                      label: 'Body',
                      hintText: 'Emergency repairs are underway...',
                      controller: bodyController,
                      minLines: 4,
                      maxLines: 6,
                    ),
                    const SizedBox(height: 12),
                    _AdminComposerField(
                      label: 'Audience',
                      hintText: 'All Residents',
                      controller: audienceController,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Announcement Type',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: _AdminPalette.muted,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _AdminSelectChip(
                          label: 'General',
                          selected: selectedKind == 'general',
                          onTap: () {
                            setModalState(() {
                              selectedKind = 'general';
                            });
                          },
                        ),
                        _AdminSelectChip(
                          label: 'Urgent',
                          selected: selectedKind == 'urgent',
                          onTap: () {
                            setModalState(() {
                              selectedKind = 'urgent';
                            });
                          },
                        ),
                        _AdminSelectChip(
                          label: 'Event',
                          selected: selectedKind == 'event',
                          onTap: () {
                            setModalState(() {
                              selectedKind = 'event';
                            });
                          },
                        ),
                        _AdminSelectChip(
                          label: 'Facility',
                          selected: selectedKind == 'facility',
                          onTap: () {
                            setModalState(() {
                              selectedKind = 'facility';
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    AvenuePrimaryButton(
                      label: isSubmitting ? 'Publishing...' : 'Publish',
                      onPressed: () async {
                        if (isSubmitting) {
                          return;
                        }

                        final title = titleController.text.trim();
                        final body = bodyController.text.trim();
                        final audience = audienceController.text.trim();
                        if (title.isEmpty || body.isEmpty || audience.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Enter title, body, and target audience.',
                              ),
                            ),
                          );
                          return;
                        }

                        setModalState(() {
                          isSubmitting = true;
                        });

                        final messenger = ScaffoldMessenger.of(this.context);
                        Map<String, dynamic>? result;
                        String? errorMessage;
                        try {
                          result = await _repository.createAnnouncement(
                            kind: selectedKind,
                            title: title,
                            body: body,
                            targetAudience: audience,
                          );
                        } catch (error) {
                          errorMessage = error.toString();
                        }

                        if (!mounted || !sheetContext.mounted) {
                          return;
                        }

                        Navigator.of(sheetContext).pop();

                        if (result == null) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                errorMessage ??
                                    'Could not publish announcement.',
                              ),
                            ),
                          );
                          return;
                        }

                        final announcementId =
                            result['announcement_id']?.toString() ?? '';
                        var successMessage = 'Announcement published.';

                        if (announcementId.isNotEmpty) {
                          try {
                            await _repository.sendAnnouncementPush(
                              announcementId: announcementId,
                            );
                          } catch (_) {
                            successMessage =
                                'Announcement published. Push delivery is not configured yet.';
                          }
                        }

                        setState(() {
                          _announcementsFuture = _AnnouncementsData.load(
                            _repository,
                          );
                          _selectedState = 'sent';
                          _visibleRows = 6;
                        });

                        messenger.showSnackBar(
                          SnackBar(content: Text(successMessage)),
                        );
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

class AddResidentScreen extends StatefulWidget {
  const AddResidentScreen({super.key});

  @override
  State<AddResidentScreen> createState() => _AddResidentScreenState();
}

class _AddResidentScreenState extends State<AddResidentScreen> {
  static const String _temporaryPassword = 'welcome123';

  final AvenueRepository _repository = AvenueRepository();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _moveInDateController = TextEditingController();

  String _residentKind = 'owner';
  DateTime? _moveInDate;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _unitController.dispose();
    _moveInDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AdminScaffold(
      currentPage: AppPage.residentDirectory,
      topBar: _AdminTopBar(
        title: 'Add Resident',
        leadingIcon: Icons.arrow_back_rounded,
        onLeadingTap: () => _goBackOrAdminHome(context),
      ),
      child: _AdminBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _AdminTag(
              label: 'ONBOARDING MODULE',
              background: Color(0x1A005BBF),
              foreground: AvenueColors.primary,
            ),
            const SizedBox(height: 14),
            Text(
              'Resident Registration',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: 32,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter the official details to welcome a new member to the community.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: _AdminPalette.muted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            _AdminGlassCard(
              radius: 28,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _AdminSectionLabel(text: 'CONTACT DETAILS'),
                  const SizedBox(height: 12),
                  _AdminFormField(
                    label: 'FULL NAME',
                    hintText: 'e.g. Jonathan Doe',
                    icon: Icons.person_rounded,
                    controller: _fullNameController,
                  ),
                  const SizedBox(height: 12),
                  _AdminFormField(
                    label: 'EMAIL ADDRESS',
                    hintText: 'j.doe@example.com',
                    icon: Icons.mail_outline_rounded,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  _AdminFormField(
                    label: 'PHONE NUMBER',
                    hintText: '+1 (555) 000-0000',
                    icon: Icons.call_rounded,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  const _AdminSectionLabel(text: 'LEASE & UNIT'),
                  const SizedBox(height: 12),
                  _AdminFormField(
                    label: 'UNIT NUMBER',
                    hintText: 'e.g. B-204',
                    icon: Icons.apartment_rounded,
                    controller: _unitController,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'RESIDENT TYPE',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _AdminPalette.muted,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _AdminSelectChip(
                        label: 'Owner',
                        selected: _residentKind == 'owner',
                        onTap: () => setState(() => _residentKind = 'owner'),
                      ),
                      _AdminSelectChip(
                        label: 'Tenant',
                        selected: _residentKind == 'tenant',
                        onTap: () => setState(() => _residentKind = 'tenant'),
                      ),
                      _AdminSelectChip(
                        label: 'Family',
                        selected: _residentKind == 'family',
                        onTap: () => setState(() => _residentKind = 'family'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _AdminFormField(
                    label: 'MOVE-IN DATE',
                    hintText: 'Select date',
                    icon: Icons.calendar_today_rounded,
                    controller: _moveInDateController,
                    readOnly: true,
                    onTap: _pickMoveInDate,
                  ),
                  const SizedBox(height: 20),
                  const _AdminSectionLabel(text: 'RESIDENT ID / PORTRAIT'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                          color: _AdminPalette.surfaceLow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.add_a_photo_outlined,
                          color: _AdminPalette.muted,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upload a profile picture',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Recommended for verification and quicker gate approval. Max file size 5MB.',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: _AdminPalette.muted,
                                    height: 1.45,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _goBackOrAdminHome(context),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                            side: BorderSide(
                              color: AvenueColors.primary.withValues(
                                alpha: 0.25,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AvenueColors.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: AvenuePrimaryButton(
                          label: _isSubmitting
                              ? 'Adding Resident...'
                              : 'Add Resident',
                          onPressed: _createResident,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const _AdminInfoBanner(
              icon: Icons.verified_user_rounded,
              title: 'SECURITY',
              body: 'The resident profile is created as an active access record ready for verification.',
            ),
            const SizedBox(height: 12),
            const _AdminInfoBanner(
              icon: Icons.mail_rounded,
              title: 'WELCOME',
              body:
                  'A temporary password is generated so the resident can sign in immediately.',
            ),
            const SizedBox(height: 12),
            const _AdminInfoBanner(
              icon: Icons.key_rounded,
              title: 'ACCESS',
              body:
                  'Once onboarded, the resident appears in the directory and admin oversight views.',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickMoveInDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _moveInDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _moveInDate = pickedDate;
      _moveInDateController.text =
          '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
    });
  }

  Future<void> _createResident() async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final unitNumber = _unitController.text.trim();

    if (fullName.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        unitNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter name, email, phone, and unit number.'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    Map<String, dynamic>? result;
    try {
      result = await _repository.createResident(
        email: email,
        fullName: fullName,
        phone: phone,
        unitNumber: unitNumber,
        residentKind: _residentKind,
        tempPassword: _temporaryPassword,
      );
    } catch (_) {
      result = null;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
    });

    if (result == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not add resident.')));
      return;
    }

    final createdEmail = result['email'] as String? ?? email;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Resident Added'),
          content: Text(
            'Temporary password for $createdEmail: $_temporaryPassword',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );

    if (!mounted) {
      return;
    }

    goToPage(context, AppPage.residentDirectory, replace: true);
  }
}

class ResidentDirectoryScreen extends StatefulWidget {
  const ResidentDirectoryScreen({super.key});

  @override
  State<ResidentDirectoryScreen> createState() => _ResidentDirectoryScreenState();
}

class _ResidentDirectoryScreenState extends State<ResidentDirectoryScreen> {
  final AvenueRepository _repository = AvenueRepository();
  late Future<List<Map<String, dynamic>>> _directoryFuture;
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _directoryFuture = _repository.fetchResidentDirectory();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AdminScaffold(
      currentPage: AppPage.residentDirectory,
      topBar: _AdminTopBar(
        title: 'Resident Directory',
        leadingIcon: Icons.menu_rounded,
        onLeadingTap: () => _openAdminMenu(context, AppPage.residentDirectory),
        trailing: IconButton(
          onPressed: () => goToPage(context, AppPage.addResident),
          icon: const Icon(Icons.person_add_alt_1_rounded),
          color: AvenueColors.primary,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToPage(context, AppPage.addResident),
        backgroundColor: AvenueColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _directoryFuture,
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          final filtered = rows.where(_matchesResidentFilter).toList();
          final activeCount = rows
              .where((row) => _normalize(row['status']?.toString() ?? '') == 'active')
              .length;
          final pendingCount = rows
              .where((row) => _normalize(row['status']?.toString() ?? '') == 'pending')
              .length;

          return _AdminBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AdminSearchBar(
                  controller: _searchController,
                  hintText: 'Search residents by name, unit, or phone number...',
                ),
                const SizedBox(height: 14),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _ResidentFilterChip(
                        label: 'All',
                        selected: _selectedFilter == 'all',
                        onTap: () => setState(() => _selectedFilter = 'all'),
                      ),
                      const SizedBox(width: 8),
                      _ResidentFilterChip(
                        label: 'Owners',
                        selected: _selectedFilter == 'owner',
                        onTap: () => setState(() => _selectedFilter = 'owner'),
                      ),
                      const SizedBox(width: 8),
                      _ResidentFilterChip(
                        label: 'Tenants',
                        selected: _selectedFilter == 'tenant',
                        onTap: () => setState(() => _selectedFilter = 'tenant'),
                      ),
                      const SizedBox(width: 8),
                      _ResidentFilterChip(
                        label: 'Awaiting Verification',
                        selected: _selectedFilter == 'pending',
                        onTap: () => setState(() => _selectedFilter = 'pending'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _ResidentInsightTile(
                        label: 'Active Residents',
                        value: activeCount.toString(),
                        icon: Icons.verified_rounded,
                        tint: const Color(0xFFE7F6EE),
                        iconColor: _AdminPalette.success,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ResidentInsightTile(
                        label: 'Pending Review',
                        value: pendingCount.toString(),
                        icon: Icons.hourglass_top_rounded,
                        tint: const Color(0xFFFFF3D7),
                        iconColor: _AdminPalette.warning,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Resident Directory',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${filtered.length} profile${filtered.length == 1 ? '' : 's'} visible',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _AdminPalette.muted,
                  ),
                ),
                const SizedBox(height: 14),
                if (snapshot.connectionState != ConnectionState.done &&
                    rows.isEmpty)
                  const _AdminEmptyState(label: 'Loading residents...')
                else if (filtered.isEmpty)
                  const _AdminEmptyState(
                    label: 'No residents match the current search or filter.',
                  )
                else
                  ...filtered.map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ResidentDirectoryCard(
                        imageUrl:
                            row['avatar_url'] as String? ??
                            _directoryImageForName(
                              row['full_name'] as String? ?? '',
                            ),
                        initials: _initialsFromName(
                          row['full_name'] as String? ?? 'R',
                        ),
                        name: row['full_name'] as String? ?? 'Resident',
                        unitLine:
                            'Unit ${row['unit_number'] ?? '-'} • ${row['tower'] ?? '-'}',
                        status: row['status']?.toString() ?? '',
                        statusColor: _residentStatusColor(
                          row['status']?.toString(),
                        ),
                        actionLabel:
                            _normalize(row['status']?.toString() ?? '') ==
                                'expired'
                            ? 'Renew Notice'
                            : 'View Profile',
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

  bool _matchesResidentFilter(Map<String, dynamic> row) {
    final search = _normalize(_searchController.text);
    final fullName = _normalize(row['full_name']?.toString() ?? '');
    final unit = _normalize(row['unit_number']?.toString() ?? '');
    final phone = _normalize(row['phone']?.toString() ?? '');
    final residentKind = _normalize(row['resident_kind']?.toString() ?? '');
    final status = _normalize(row['status']?.toString() ?? '');

    final matchesSearch =
        search.isEmpty ||
        fullName.contains(search) ||
        unit.contains(search) ||
        phone.contains(search);

    final matchesFilter = switch (_selectedFilter) {
      'owner' => residentKind == 'owner',
      'tenant' => residentKind == 'tenant',
      'pending' => status == 'pending',
      _ => true,
    };

    return matchesSearch && matchesFilter;
  }
}

class _AdminScaffold extends StatelessWidget {
  const _AdminScaffold({
    required this.child,
    required this.currentPage,
    this.topBar,
    this.floatingActionButton,
  });

  final Widget child;
  final AppPage currentPage;
  final PreferredSizeWidget? topBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AdminPalette.background,
      appBar: topBar,
      body: child,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: AvenueBottomNavigationBar(
        items: _adminNavItems,
        currentPage: currentPage,
      ),
    );
  }
}

class _AdminTopBar extends StatelessWidget implements PreferredSizeWidget {
  const _AdminTopBar({
    required this.title,
    required this.leadingIcon,
    required this.onLeadingTap,
    this.trailing,
  });

  final String title;
  final IconData leadingIcon;
  final VoidCallback onLeadingTap;
  final Widget? trailing;

  @override
  Size get preferredSize => const Size.fromHeight(84);

  @override
  Widget build(BuildContext context) {
    final currentUser = AppSession.instance.currentUser;

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 84,
      scrolledUnderElevation: 0,
      backgroundColor: _AdminPalette.surface.withValues(alpha: 0.9),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 16,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: _AdminPalette.surface.withValues(alpha: 0.84),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10005EA3),
              blurRadius: 24,
              offset: Offset(0, 12),
            ),
          ],
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _AdminPalette.surfaceLow,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: onLeadingTap,
              icon: Icon(leadingIcon, color: AvenueColors.primary),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: title == 'COVE' ? AvenueColors.primary : _AdminPalette.ink,
              ),
            ),
          ),
          if (trailing != null) ...[
            trailing!,
            const SizedBox(width: 8),
          ],
          AvenueNetworkAvatar(
            imageUrl: currentUser?.avatarUrl ?? _adminAvatarUrl,
            size: 40,
            borderWidth: 2,
            fallbackLabel: currentUser?.initials ?? 'M',
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: _AdminPalette.outline.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

class _AdminBody extends StatelessWidget {
  const _AdminBody({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _AdminTag extends StatelessWidget {
  const _AdminTag({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: foreground,
          letterSpacing: 0.9,
        ),
      ),
    );
  }
}

class _AdminSectionHeading extends StatelessWidget {
  const _AdminSectionHeading({
    required this.title,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onActionTap,
            child: Text(
              actionLabel!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AvenueColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
      ],
    );
  }
}

class _AdminMetricTile extends StatelessWidget {
  const _AdminMetricTile({
    required this.icon,
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final foreground = highlighted ? Colors.white : _AdminPalette.ink;
    final subtitle = highlighted
        ? Colors.white.withValues(alpha: 0.78)
        : _AdminPalette.muted;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: highlighted ? AvenueColors.primaryGradient : null,
        color: highlighted ? null : _AdminPalette.surface,
        borderRadius: BorderRadius.circular(26),
        border: highlighted
            ? null
            : Border.all(color: _AdminPalette.outline.withValues(alpha: 0.24)),
        boxShadow: const [
          BoxShadow(
            color: _AdminPalette.shadow,
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: highlighted
                  ? Colors.white.withValues(alpha: 0.2)
                  : _AdminPalette.surfaceLow,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: foreground, size: 20),
          ),
          const Spacer(),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: subtitle,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminQuickActionButton extends StatelessWidget {
  const _AdminQuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.emphasized = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            gradient: emphasized ? AvenueColors.primaryGradient : null,
            color: emphasized ? null : _AdminPalette.surface,
            borderRadius: BorderRadius.circular(18),
            border: emphasized
                ? null
                : Border.all(
                    color: _AdminPalette.outline.withValues(alpha: 0.24),
                  ),
            boxShadow: const [
              BoxShadow(
                color: _AdminPalette.shadow,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: emphasized ? Colors.white : _AdminPalette.ink,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: emphasized ? Colors.white : _AdminPalette.ink,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminFeatureCard extends StatelessWidget {
  const _AdminFeatureCard({
    required this.imageUrl,
    required this.title,
    required this.badge,
  });

  final String imageUrl;
  final String title;
  final String badge;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: SizedBox(
        height: 188,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(imageUrl, fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xA6000000), Color(0x22000000)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AdminTag(
                    label: badge,
                    background: const Color(0xFF57DBA2),
                    foreground: const Color(0xFF124A31),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminGlassCard extends StatelessWidget {
  const _AdminGlassCard({
    required this.child,
    this.radius = 24,
  });

  final Widget child;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _AdminPalette.surface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: _AdminPalette.outline.withValues(alpha: 0.22)),
        boxShadow: const [
          BoxShadow(
            color: _AdminPalette.shadow,
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _AdminActivityModel {
  const _AdminActivityModel({
    required this.icon,
    required this.tint,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final IconData icon;
  final Color tint;
  final String title;
  final String subtitle;
  final String trailing;
}

class _AdminActivityTile extends StatelessWidget {
  const _AdminActivityTile({required this.model});

  final _AdminActivityModel model;

  @override
  Widget build(BuildContext context) {
    return _AdminGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: model.tint,
                shape: BoxShape.circle,
              ),
              child: Icon(model.icon, color: _AdminPalette.ink),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    model.subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _AdminPalette.muted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              model.trailing,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _AdminPalette.muted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminSectionLabel extends StatelessWidget {
  const _AdminSectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: _AdminPalette.muted,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.0,
      ),
    );
  }
}

class _ReportOptionCard extends StatelessWidget {
  const _ReportOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFEAF3FF) : _AdminPalette.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected
                  ? AvenueColors.primary.withValues(alpha: 0.32)
                  : _AdminPalette.outline.withValues(alpha: 0.24),
            ),
            boxShadow: const [
              BoxShadow(
                color: _AdminPalette.shadow,
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: selected ? AvenueColors.primary : _AdminPalette.surfaceLow,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: selected ? Colors.white : AvenueColors.primary,
                ),
              ),
              const SizedBox(width: 14),
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
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _AdminPalette.muted,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle_rounded, color: AvenueColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportDateChip extends StatelessWidget {
  const _ReportDateChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: selected ? Colors.white : _AdminPalette.ink,
        fontWeight: FontWeight.w800,
      ),
      selectedColor: AvenueColors.primary,
      backgroundColor: _AdminPalette.surface,
      side: BorderSide(
        color: selected
            ? AvenueColors.primary
            : _AdminPalette.outline.withValues(alpha: 0.24),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }
}

class _ReportFormatRow extends StatelessWidget {
  const _ReportFormatRow({
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Color iconColor;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_off_rounded,
        color: selected ? AvenueColors.primary : _AdminPalette.outline,
      ),
    );
  }
}

class _AdminFormField extends StatelessWidget {
  const _AdminFormField({
    required this.label,
    required this.hintText,
    required this.icon,
    this.controller,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
  });

  final String label;
  final String hintText;
  final IconData icon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: _AdminPalette.muted,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: _AdminPalette.surfaceLow,
            borderRadius: BorderRadius.circular(18),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            onTap: onTap,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _AdminPalette.muted.withValues(alpha: 0.7),
              ),
              prefixIcon: Icon(icon, color: _AdminPalette.muted),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _AdminComposerField extends StatelessWidget {
  const _AdminComposerField({
    required this.label,
    required this.hintText,
    required this.controller,
    this.minLines = 1,
    this.maxLines = 1,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final int minLines;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: _AdminPalette.muted,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: _AdminPalette.surfaceLow,
            borderRadius: BorderRadius.circular(18),
          ),
          child: TextField(
            controller: controller,
            minLines: minLines,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _AdminPalette.muted.withValues(alpha: 0.72),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdminSelectChip extends StatelessWidget {
  const _AdminSelectChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: AvenueColors.primary,
      backgroundColor: _AdminPalette.surfaceLow,
      side: BorderSide(
        color: selected
            ? AvenueColors.primary
            : _AdminPalette.outline.withValues(alpha: 0.24),
      ),
      labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: selected ? Colors.white : _AdminPalette.ink,
        fontWeight: FontWeight.w800,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    );
  }
}

class _AdminInfoBanner extends StatelessWidget {
  const _AdminInfoBanner({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return _AdminGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _AdminPalette.surfaceLow,
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
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AvenueColors.primary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    body,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _AdminPalette.muted,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnnouncementStateTab extends StatelessWidget {
  const _AnnouncementStateTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? _AdminPalette.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? AvenueColors.primary.withValues(alpha: 0.24)
                : _AdminPalette.outline.withValues(alpha: 0.18),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: selected ? AvenueColors.primary : _AdminPalette.muted,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _AnnouncementHistoryCard extends StatelessWidget {
  const _AnnouncementHistoryCard({
    required this.category,
    required this.categoryColor,
    required this.timestamp,
    required this.title,
    required this.body,
    required this.reads,
    required this.audience,
  });

  final String category;
  final Color categoryColor;
  final String timestamp;
  final String title;
  final String body;
  final String reads;
  final String audience;

  @override
  Widget build(BuildContext context) {
    return _AdminGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _AdminTag(
                  label: category.toUpperCase(),
                  background: categoryColor.withValues(alpha: 0.12),
                  foreground: categoryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  timestamp,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _AdminPalette.muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              body,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _AdminPalette.muted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _AdminMetaPill(icon: Icons.visibility_rounded, label: reads),
                _AdminMetaPill(icon: Icons.send_rounded, label: audience),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminMetaPill extends StatelessWidget {
  const _AdminMetaPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: _AdminPalette.surfaceLow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: _AdminPalette.muted),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _AdminPalette.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminSearchBar extends StatelessWidget {
  const _AdminSearchBar({
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _AdminPalette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _AdminPalette.outline.withValues(alpha: 0.22)),
        boxShadow: const [
          BoxShadow(
            color: _AdminPalette.shadow,
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search_rounded, color: _AdminPalette.muted),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  onPressed: controller.clear,
                  icon: const Icon(Icons.close_rounded),
                  color: _AdminPalette.muted,
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: _AdminPalette.muted.withValues(alpha: 0.72),
          ),
        ),
      ),
    );
  }
}

class _ResidentFilterChip extends StatelessWidget {
  const _ResidentFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: AvenueColors.primary,
      backgroundColor: _AdminPalette.surface,
      side: BorderSide(
        color: selected
            ? AvenueColors.primary
            : _AdminPalette.outline.withValues(alpha: 0.22),
      ),
      labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: selected ? Colors.white : _AdminPalette.muted,
        fontWeight: FontWeight.w800,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    );
  }
}

class _ResidentInsightTile extends StatelessWidget {
  const _ResidentInsightTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.tint,
    required this.iconColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color tint;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return _AdminGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 14),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _AdminPalette.muted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResidentDirectoryCard extends StatelessWidget {
  const _ResidentDirectoryCard({
    required this.imageUrl,
    required this.initials,
    required this.name,
    required this.unitLine,
    required this.status,
    required this.statusColor,
    required this.actionLabel,
  });

  final String? imageUrl;
  final String initials;
  final String name;
  final String unitLine;
  final String status;
  final Color statusColor;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return _AdminGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ResidentAvatar(imageUrl: imageUrl, initials: initials),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        unitLine,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _AdminPalette.muted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                _AdminTag(
                  label: status.toUpperCase(),
                  background: statusColor.withValues(alpha: 0.12),
                  foreground: statusColor,
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: AvenuePrimaryButton(
                    label: actionLabel,
                    onPressed: () {},
                    height: 48,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AvenueColors.primary.withValues(alpha: 0.22),
                    ),
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: AvenueColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ResidentAvatar extends StatelessWidget {
  const _ResidentAvatar({
    required this.imageUrl,
    required this.initials,
  });

  final String? imageUrl;
  final String initials;

  @override
  Widget build(BuildContext context) {
    final child = imageUrl == null || imageUrl!.isEmpty
        ? Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFD4E3FF),
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: AvenueColors.primary,
              ),
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              imageUrl!,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4E3FF),
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AvenueColors.primary,
                  ),
                ),
              ),
            ),
          );

    return child;
  }
}

class _AdminSupportCard extends StatelessWidget {
  const _AdminSupportCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AvenueColors.primaryGradient,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33005BBF),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Support',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.78),
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Need help with the portal?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AvenueColors.primary,
                minimumSize: const Size.fromHeight(44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Contact Support'),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminDrawerNavItem extends StatelessWidget {
  const _AdminDrawerNavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: selected ? AvenueColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: selected ? Colors.white : _AdminPalette.muted,
              ),
              const SizedBox(width: 14),
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: selected ? Colors.white : _AdminPalette.ink,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminEmptyState extends StatelessWidget {
  const _AdminEmptyState({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return _AdminGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: _AdminPalette.muted,
            ),
          ),
        ),
      ),
    );
  }
}
