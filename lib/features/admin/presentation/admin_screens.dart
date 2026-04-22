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
    label: 'NOTIFY',
    icon: Icons.campaign_outlined,
    page: AppPage.announcementsManagement,
  ),
  const AvenueNavItem(
    label: 'RESIDENTS',
    icon: Icons.group_outlined,
    page: AppPage.residentDirectory,
  ),
  const AvenueNavItem(
    label: 'REPORTS',
    icon: Icons.analytics_outlined,
    page: AppPage.generateReports,
  ),
];

String _initialsFromName(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();
  if (parts.isEmpty) {
    return 'R';
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

Color _statusColor(String? status) {
  switch (status) {
    case 'active':
      return const Color(0xFF2E9A53);
    case 'pending':
      return const Color(0xFF8B6500);
    case 'expired':
      return const Color(0xFFD6453A);
    default:
      return AvenueColors.onSurfaceVariant;
  }
}

Color _announcementKindColor(String? kind) {
  switch (kind) {
    case 'urgent':
      return AvenueColors.primary;
    case 'event':
      return const Color(0xFFAA7A00);
    default:
      return AvenueColors.onSurfaceVariant;
  }
}

String _announcementTimestampLabel(dynamic value) {
  if (value == null) {
    return '-';
  }

  final parsed = DateTime.tryParse(value.toString());
  if (parsed == null) {
    return value.toString();
  }

  final difference = DateTime.now().difference(parsed.toLocal());
  if (difference.inMinutes < 60) {
    return '${difference.inMinutes.clamp(1, 59)} minutes ago';
  }
  if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  }
  if (difference.inDays == 1) {
    return 'Yesterday';
  }

  return '${difference.inDays} days ago';
}

InputDecoration _adminSheetInputDecoration(
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
                AvenueNetworkAvatar(
                  imageUrl: currentUser?.avatarUrl ?? _adminAvatarUrl,
                  size: 64,
                  fallbackLabel: currentUser?.initials ?? 'M',
                ),
                const SizedBox(height: 20),
                Text(
                  currentUser?.fullName ?? 'Marcus Sterling',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentUser?.subtitle ?? 'Estate Manager',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AvenueColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                const AvenuePill(
                  label: 'ADMIN ACCESS',
                  backgroundColor: Color(0x1A155EEF),
                  foregroundColor: AvenueColors.primary,
                ),
                const SizedBox(height: 28),
                _AdminDrawerItem(
                  label: 'Dashboard',
                  icon: Icons.dashboard_customize_rounded,
                  selected: currentPage == AppPage.adminDrawer,
                  onTap: () =>
                      goToPage(context, AppPage.adminDrawer, replace: true),
                ),
                const SizedBox(height: 8),
                _AdminDrawerItem(
                  label: 'Announcements',
                  icon: Icons.campaign_outlined,
                  selected: currentPage == AppPage.announcementsManagement,
                  onTap: () => goToPage(
                    context,
                    AppPage.announcementsManagement,
                    replace: true,
                  ),
                ),
                const SizedBox(height: 8),
                _AdminDrawerItem(
                  label: 'Residents',
                  icon: Icons.group_outlined,
                  selected: currentPage == AppPage.residentDirectory,
                  onTap: () => goToPage(
                    context,
                    AppPage.residentDirectory,
                    replace: true,
                  ),
                ),
                const SizedBox(height: 8),
                _AdminDrawerItem(
                  label: 'Reports',
                  icon: Icons.analytics_outlined,
                  selected: currentPage == AppPage.generateReports,
                  onTap: () =>
                      goToPage(context, AppPage.generateReports, replace: true),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    AppSession.instance.clear();
                    goToPage(context, AppPage.login, replace: true);
                  },
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

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = AppSession.instance.currentUser;
    final repository = AvenueRepository();

    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Avenue360',
        leading: AvenueIconButton(
          icon: Icons.menu_rounded,
          onPressed: () => Navigator.of(context).pushNamed(
            AppPage.adminMenu.routeName,
            arguments: AppPage.adminDrawer,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: AvenueNetworkAvatar(
              imageUrl: currentUser?.avatarUrl ?? _adminAvatarUrl,
              size: 36,
              fallbackLabel: currentUser?.initials ?? 'M',
            ),
          ),
        ],
      ),
      body: FutureBuilder<_AdminDashboardData>(
        future: _AdminDashboardData.load(repository),
        builder: (context, snapshot) {
          final metrics = snapshot.data?.metrics;
          final transactions =
              snapshot.data?.transactions ?? const <Map<String, dynamic>>[];

          return _AdminScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Portfolio Overview',
                  style: Theme.of(
                    context,
                  ).textTheme.displayMedium?.copyWith(fontSize: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  'Welcome back, ${currentUser?.fullName.split(' ').first ?? 'Admin'}. Here is what is happening across Avenue360 today.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AvenueColors.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _AdminStatCard(
                        label: 'Residents',
                        value:
                            metrics?['active_residents']?.toString() ??
                            (snapshot.connectionState != ConnectionState.done
                                ? '...'
                                : '0'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _AdminStatCard(
                        label: 'Visitors',
                        value:
                            metrics?['active_visitor_passes']?.toString() ??
                            (snapshot.connectionState != ConnectionState.done
                                ? '...'
                                : '0'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _AdminStatCard(
                        label: 'Open Complaints',
                        value:
                            metrics?['open_complaints']?.toString() ??
                            (snapshot.connectionState != ConnectionState.done
                                ? '...'
                                : '0'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                AvenueSecondaryButton(
                  label: 'Generate Report',
                  onPressed: () => goToPage(context, AppPage.generateReports),
                ),
                const SizedBox(height: 14),
                AvenuePrimaryButton(
                  label: 'New Announcement',
                  onPressed: () =>
                      goToPage(context, AppPage.announcementsManagement),
                ),
                const SizedBox(height: 18),
                _DashboardFeatureCard(
                  imageUrl: _adminPoolImageUrl,
                  title: 'The Sky Pool',
                  status: 'OPEN',
                  onTap: () {},
                ),
                const SizedBox(height: 14),
                _DashboardFeatureCard(
                  imageUrl: _adminGymImageUrl,
                  title: 'Zenith Gym',
                  status: 'ACTIVE',
                  onTap: () {},
                ),
                const SizedBox(height: 14),
                AvenueCard(
                  radius: 22,
                  color: const Color(0xFFF2F3F5),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () {},
                    child: Column(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFE0E2E8),
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            color: AvenueColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Manage Amenities',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Update schedules & bookings',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                AvenueSectionHeader(
                  title: 'Recent Transactions',
                  actionLabel: 'View All',
                  onActionTap: () {},
                ),
                const SizedBox(height: 14),
                if (transactions.isEmpty &&
                    snapshot.connectionState != ConnectionState.done)
                  const _AdminDataPlaceholder(label: 'Loading transactions...')
                else
                  ...transactions
                      .take(4)
                      .map(
                        (row) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _TransactionTile(
                            icon: row['icon_name'] == 'flash_on'
                                ? Icons.flash_on_rounded
                                : Icons.receipt_long_rounded,
                            iconBackground: row['icon_bg_hex'] == '#E8F0FF'
                                ? const Color(0xFFE7F0FF)
                                : const Color(0xFFFFE9C2),
                            iconColor: row['icon_name'] == 'flash_on'
                                ? AvenueColors.primary
                                : const Color(0xFF8F6500),
                            title: row['title'] as String? ?? 'Transaction',
                            subtitle: row['subtitle'] as String? ?? '',
                            amount: row['amount']?.toString() ?? '0',
                            status: row['status'] as String? ?? '',
                            statusColor: (row['status'] == 'SUCCESS')
                                ? const Color(0xFF2E9A53)
                                : AvenueColors.onSurfaceVariant,
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
      bottomNavigation: AvenueBottomNavigationBar(
        items: _adminNavItems,
        currentPage: AppPage.adminDrawer,
      ),
    );
  }
}

class GenerateReportsScreen extends StatelessWidget {
  const GenerateReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'GenerateReports',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: AvenueNetworkAvatar(
              imageUrl: _adminAvatarUrl,
              size: 34,
              fallbackLabel: 'M',
            ),
          ),
        ],
      ),
      body: _AdminScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configure Your\nIntelligence',
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(fontSize: 22, height: 1.05),
            ),
            const SizedBox(height: 10),
            Text(
              'Select the specific parameters to distill estate data into professional, actionable documents.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AvenueColors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '1. SELECT REPORT TYPE',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            const _ReportTypeCard(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Financial Summary',
              subtitle:
                  'Profit/loss, dues status, and expense allocation overview.',
              selected: true,
            ),
            const SizedBox(height: 10),
            const _ReportTypeCard(
              icon: Icons.person_pin_circle_outlined,
              title: 'Resident Directory',
              subtitle:
                  'Full list of residents, occupancy status, and contact verified status.',
            ),
            const SizedBox(height: 10),
            const _ReportTypeCard(
              icon: Icons.stadium_outlined,
              title: 'Amenity Usage',
              subtitle:
                  'Booking trends for pool, gym, and clubhouse facilities.',
            ),
            const SizedBox(height: 10),
            const _ReportTypeCard(
              icon: Icons.engineering_outlined,
              title: 'Maintenance Logs',
              subtitle:
                  'History of repairs, vendor performance, and pending tickets.',
            ),
            const SizedBox(height: 24),
            Text(
              '2. DATE RANGE',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _DateRangeChip(label: 'Today', selected: true),
                  SizedBox(width: 8),
                  _DateRangeChip(label: 'This Month'),
                  SizedBox(width: 8),
                  _DateRangeChip(label: 'Last Quarter'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const AvenueInputField(
              label: '',
              hintText: 'Oct 01, 2023 - Oct 31, 2023',
              icon: Icons.calendar_today_rounded,
            ),
            const SizedBox(height: 24),
            Text(
              '3. OUTPUT FORMAT',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            const AvenueCard(
              radius: 22,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _FormatOption(
                    icon: Icons.picture_as_pdf_rounded,
                    title: 'PDF Document',
                    iconColor: Color(0xFFE34A3A),
                    selected: true,
                  ),
                  Divider(height: 1),
                  _FormatOption(
                    icon: Icons.table_chart_rounded,
                    title: 'Excel Spreadsheet',
                    iconColor: Color(0xFF2E9A53),
                  ),
                  Divider(height: 1),
                  _FormatOption(
                    icon: Icons.description_outlined,
                    title: 'CSV File',
                    iconColor: AvenueColors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            AvenueCard(
              radius: 22,
              color: const Color(0xFFF4F7FF),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_rounded,
                    color: AvenueColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REPORT INTELLIGENCE',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AvenueColors.primary,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Generating this report will compile data from over 2,400 entry points across the community database.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AvenueColors.onSurfaceVariant,
                                height: 1.45,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            AvenuePrimaryButton(
              label: 'Generate Report',
              icon: Icons.auto_awesome_rounded,
              onPressed: () {},
            ),
          ],
        ),
      ),
      bottomNavigation: AvenueBottomNavigationBar(
        items: _adminNavItems,
        currentPage: AppPage.generateReports,
      ),
    );
  }
}

class AnnouncementsManagementScreen extends StatefulWidget {
  const AnnouncementsManagementScreen({super.key});

  @override
  State<AnnouncementsManagementScreen> createState() =>
      _AnnouncementsManagementScreenState();
}

class _AnnouncementsManagementScreenState
    extends State<AnnouncementsManagementScreen> {
  final AvenueRepository _repository = AvenueRepository();
  late Future<_AnnouncementsData> _announcementsFuture;

  @override
  void initState() {
    super.initState();
    _announcementsFuture = _AnnouncementsData.load(_repository);
  }

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Announcements',
        leading: AvenueIconButton(
          icon: Icons.menu_rounded,
          onPressed: () => Navigator.of(context).pushNamed(
            AppPage.adminMenu.routeName,
            arguments: AppPage.announcementsManagement,
          ),
        ),
        actions: [
          AvenueIconButton(
            icon: Icons.refresh_rounded,
            onPressed: () {
              setState(() {
                _announcementsFuture = _AnnouncementsData.load(_repository);
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.only(right: 18),
            child: AvenueNetworkAvatar(
              imageUrl: _adminAvatarUrl,
              size: 36,
              fallbackLabel: 'M',
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateAnnouncementSheet,
        backgroundColor: AvenueColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
      ),
      body: FutureBuilder<_AnnouncementsData>(
        future: _announcementsFuture,
        builder: (context, snapshot) {
          final announcements =
              snapshot.data?.rows ?? const <Map<String, dynamic>>[];

          return _AdminScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Expanded(
                      child: _AnnouncementTab(
                        label: 'Sent Notices',
                        selected: true,
                      ),
                    ),
                    Expanded(child: _AnnouncementTab(label: 'Scheduled')),
                    Expanded(child: _AnnouncementTab(label: 'Drafts')),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'RECENT HISTORY',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Showing last 30 days',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (snapshot.connectionState != ConnectionState.done &&
                    announcements.isEmpty)
                  const _AdminDataPlaceholder(
                    label: 'Loading announcement history...',
                  )
                else
                  ...announcements.map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _AnnouncementHistoryCard(
                        category: (row['kind'] as String? ?? 'general')
                            .toUpperCase(),
                        categoryColor: _announcementKindColor(
                          row['kind'] as String?,
                        ),
                        timestamp: _announcementTimestampLabel(
                          row['created_at'],
                        ),
                        title: row['title'] as String? ?? 'Announcement',
                        body: row['body'] as String? ?? '',
                        metaOne:
                            '${row['reads_count']?.toString() ?? '0'} Reads',
                        metaTwo:
                            row['target_audience'] as String? ?? 'Residents',
                      ),
                    ),
                  ),
                const SizedBox(height: 22),
                Center(
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: Text(
                      'Load More History',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AvenueColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    label: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AvenueColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigation: AvenueBottomNavigationBar(
        items: _adminNavItems,
        currentPage: AppPage.announcementsManagement,
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
                      'New Announcement',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      decoration: _adminSheetInputDecoration(
                        context,
                        hintText: 'Announcement title',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: bodyController,
                      maxLines: 4,
                      decoration: _adminSheetInputDecoration(
                        context,
                        hintText: 'Announcement body',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: audienceController,
                      decoration: _adminSheetInputDecoration(
                        context,
                        hintText: 'Target audience',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _AdminKindChip(
                          label: 'General',
                          selected: selectedKind == 'general',
                          onTap: () {
                            setModalState(() {
                              selectedKind = 'general';
                            });
                          },
                        ),
                        _AdminKindChip(
                          label: 'Urgent',
                          selected: selectedKind == 'urgent',
                          onTap: () {
                            setModalState(() {
                              selectedKind = 'urgent';
                            });
                          },
                        ),
                        _AdminKindChip(
                          label: 'Event',
                          selected: selectedKind == 'event',
                          onTap: () {
                            setModalState(() {
                              selectedKind = 'event';
                            });
                          },
                        ),
                        _AdminKindChip(
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
                          result = null;
                          errorMessage = error.toString();
                        }

                        if (!mounted || !sheetContext.mounted) {
                          return;
                        }

                        Navigator.of(sheetContext).pop();
                        if (result != null) {
                          final announcementId = result['announcement_id']
                              ?.toString();
                          var successMessage = 'Announcement published.';

                          if (announcementId != null &&
                              announcementId.isNotEmpty) {
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
                          });
                          messenger.showSnackBar(
                            SnackBar(content: Text(successMessage)),
                          );
                        } else {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                errorMessage ??
                                    'Could not publish announcement.',
                              ),
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
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'AddResident',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: AvenueNetworkAvatar(
              imageUrl: _adminAvatarUrl,
              size: 34,
              fallbackLabel: 'M',
            ),
          ),
        ],
      ),
      body: _AdminScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AvenuePill(
              label: 'ONBOARDING MODULE',
              backgroundColor: Color(0x1A8FA8FF),
              foregroundColor: AvenueColors.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'Resident Registration',
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter the official details to welcome a new member to the community.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AvenueColors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            AvenueCard(
              radius: 28,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CONTACT DETAILS',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  AvenueInputField(
                    label: 'FULL NAME',
                    hintText: 'e.g. Jonathan Doe',
                    icon: Icons.person_rounded,
                    controller: _fullNameController,
                  ),
                  const SizedBox(height: 14),
                  AvenueInputField(
                    label: 'EMAIL ADDRESS',
                    hintText: 'j.doe@example.com',
                    icon: Icons.mail_outline_rounded,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),
                  AvenueInputField(
                    label: 'PHONE NUMBER',
                    hintText: '+1 (555) 000-0000',
                    icon: Icons.call_rounded,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'LEASE & UNIT',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  AvenueInputField(
                    label: 'UNIT NUMBER',
                    hintText: 'e.g. B-204',
                    icon: Icons.apartment_rounded,
                    controller: _unitController,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'RESIDENT TYPE',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AvenueColors.surfaceHigh,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _ResidentTypeChip(
                            label: 'Owner',
                            selected: _residentKind == 'owner',
                            onTap: () =>
                                setState(() => _residentKind = 'owner'),
                          ),
                        ),
                        Expanded(
                          child: _ResidentTypeChip(
                            label: 'Tenant',
                            selected: _residentKind == 'tenant',
                            onTap: () =>
                                setState(() => _residentKind = 'tenant'),
                          ),
                        ),
                        Expanded(
                          child: _ResidentTypeChip(
                            label: 'Family',
                            selected: _residentKind == 'family',
                            onTap: () =>
                                setState(() => _residentKind = 'family'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  AvenueInputField(
                    label: 'MOVE-IN DATE',
                    hintText: 'Select Date',
                    icon: Icons.calendar_today_rounded,
                    controller: _moveInDateController,
                    readOnly: true,
                    onTap: _pickMoveInDate,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'RESIDENT ID / PORTRAIT',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: AvenueColors.surfaceHigh,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.add_a_photo_outlined,
                          color: AvenueColors.outline,
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
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Recommended for security verification. Max file size 5MB.',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => goBackOrHome(context),
                          child: Text(
                            'Cancel',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AvenueColors.primary,
                                  fontWeight: FontWeight.w700,
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
            const _ResidentSummaryCard(
              icon: Icons.verified_user_rounded,
              title: 'SECURITY',
              body: 'Profile will be verified automatically',
              tint: Color(0xFFEAF1FF),
              iconColor: AvenueColors.primary,
            ),
            const SizedBox(height: 12),
            const _ResidentSummaryCard(
              icon: Icons.mail_rounded,
              title: 'WELCOME',
              body: 'Onboarding email sent upon creation',
              tint: Color(0xFFF9F1E8),
              iconColor: Color(0xFF8B6500),
            ),
            const SizedBox(height: 12),
            const _ResidentSummaryCard(
              icon: Icons.key_rounded,
              title: 'ACCESS',
              body: 'Digital keys generated in 24 hours',
              tint: Color(0xFFF8F0F0),
              iconColor: Color(0xFF8C5B5B),
            ),
          ],
        ),
      ),
      bottomNavigation: AvenueBottomNavigationBar(
        items: _adminNavItems,
        currentPage: null,
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

class ResidentDirectoryScreen extends StatelessWidget {
  const ResidentDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();

    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'ResidentDirectory',
        leading: AvenueIconButton(
          icon: Icons.menu_rounded,
          onPressed: () => Navigator.of(context).pushNamed(
            AppPage.adminMenu.routeName,
            arguments: AppPage.residentDirectory,
          ),
        ),
        actions: [
          AvenueIconButton(
            icon: Icons.person_add_alt_1_rounded,
            onPressed: () => goToPage(context, AppPage.addResident),
          ),
          const SizedBox(width: 12),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToPage(context, AppPage.addResident),
        backgroundColor: AvenueColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: repository.fetchResidentDirectory(),
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          final owners = rows
              .where((row) => row['resident_kind'] == 'owner')
              .toList();
          final tenants = rows
              .where((row) => row['resident_kind'] == 'tenant')
              .toList();

          return _AdminScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AvenueSearchField(hintText: 'Search by name or unit...'),
                const SizedBox(height: 16),
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _DirectoryFilterChip(
                        label: 'All Residents',
                        selected: true,
                      ),
                      SizedBox(width: 10),
                      _DirectoryFilterChip(label: 'Owners'),
                      SizedBox(width: 10),
                      _DirectoryFilterChip(label: 'Tenants'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _DirectorySectionHeader(
                  title: 'PROPERTY OWNERS',
                  count: '${owners.length} Total',
                  accent: AvenueColors.primary,
                ),
                const SizedBox(height: 14),
                if (rows.isEmpty &&
                    snapshot.connectionState != ConnectionState.done)
                  const _AdminDataPlaceholder(label: 'Loading residents...')
                else
                  ...owners.map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _ResidentDirectoryCard(
                        imageUrl:
                            row['avatar_url'] as String? ??
                            _directoryImageForName(
                              row['full_name'] as String? ?? '',
                            ),
                        fallbackLabel: _initialsFromName(
                          row['full_name'] as String? ?? '',
                        ),
                        name: row['full_name'] as String? ?? 'Resident',
                        unit:
                            'UNIT ${row['unit_number'] ?? '-'} • ${row['tower'] ?? '-'}',
                        status: (row['status'] as String? ?? '').toUpperCase(),
                        statusColor: _statusColor(row['status'] as String?),
                        actionLabel: 'View Profile',
                        actionIcon: Icons.mail_rounded,
                        initialBubble: row['avatar_url'] == null,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                _DirectorySectionHeader(
                  title: 'REGISTERED TENANTS',
                  count: '${tenants.length} Total',
                  accent: const Color(0xFF8B6500),
                ),
                const SizedBox(height: 14),
                ...tenants.map(
                  (row) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _ResidentDirectoryCard(
                      imageUrl:
                          row['avatar_url'] as String? ??
                          _directoryImageForName(
                            row['full_name'] as String? ?? '',
                          ),
                      fallbackLabel: _initialsFromName(
                        row['full_name'] as String? ?? '',
                      ),
                      name: row['full_name'] as String? ?? 'Resident',
                      unit:
                          'UNIT ${row['unit_number'] ?? '-'} • ${row['tower'] ?? '-'}',
                      status: (row['status'] as String? ?? '').toUpperCase(),
                      statusColor: _statusColor(row['status'] as String?),
                      actionLabel: row['status'] == 'expired'
                          ? 'Renew Notice'
                          : 'View Lease',
                      actionIcon: row['status'] == 'expired'
                          ? Icons.priority_high_rounded
                          : Icons.description_outlined,
                      actionColor: row['status'] == 'expired'
                          ? const Color(0xFFFF7C74)
                          : AvenueColors.primary,
                      initialBubble: row['avatar_url'] == null,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigation: AvenueBottomNavigationBar(
        items: _adminNavItems,
        currentPage: AppPage.residentDirectory,
      ),
    );
  }
}

class _AdminScrollView extends StatelessWidget {
  const _AdminScrollView({
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(16, 18, 16, 24),
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

class _AdminStatCard extends StatelessWidget {
  const _AdminStatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 22,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AvenueColors.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardFeatureCard extends StatelessWidget {
  const _DashboardFeatureCard({
    required this.imageUrl,
    required this.title,
    required this.status,
    required this.onTap,
  });

  final String imageUrl;
  final String title;
  final String status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          height: 154,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(imageUrl, fit: BoxFit.cover),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xA6000000), Color(0x12000000)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AvenuePill(
                      label: status,
                      backgroundColor: const Color(0xFF53D89F),
                      foregroundColor: const Color(0xFF0E4E32),
                    ),
                    const Spacer(),
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
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.status,
    required this.statusColor,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String amount;
  final String status;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 24,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
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
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
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
              const SizedBox(height: 4),
              Text(
                status,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: statusColor,
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

class _ReportTypeCard extends StatelessWidget {
  const _ReportTypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.selected = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 20,
      border: Border.all(
        color: selected
            ? AvenueColors.primary
            : AvenueColors.outlineVariant.withValues(alpha: 0.25),
        width: selected ? 1.4 : 1,
      ),
      color: selected ? const Color(0xFFF4F7FF) : Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFFE8EEFF),
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
            child: Icon(icon, color: AvenueColors.primary),
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
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(height: 1.45),
                ),
              ],
            ),
          ),
          if (selected)
            const Padding(
              padding: EdgeInsets.only(left: 12, top: 4),
              child: Icon(
                Icons.radio_button_checked_rounded,
                color: AvenueColors.primary,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }
}

class _DateRangeChip extends StatelessWidget {
  const _DateRangeChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? AvenueColors.primary : AvenueColors.surfaceHigh,
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

class _FormatOption extends StatelessWidget {
  const _FormatOption({
    required this.icon,
    required this.title,
    required this.iconColor,
    this.selected = false,
  });

  final IconData icon;
  final String title;
  final Color iconColor;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Icon(
            selected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_off_rounded,
            color: selected
                ? AvenueColors.primary
                : AvenueColors.outlineVariant,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _AnnouncementTab extends StatelessWidget {
  const _AnnouncementTab({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: selected
                  ? AvenueColors.primary
                  : AvenueColors.onSurfaceVariant,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
        Container(
          height: 2,
          color: selected ? AvenueColors.primary : Colors.transparent,
        ),
      ],
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
    required this.metaOne,
    required this.metaTwo,
  });

  final String category;
  final Color categoryColor;
  final String timestamp;
  final String title;
  final String body;
  final String metaOne;
  final String metaTwo;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AvenuePill(
                label: category,
                backgroundColor: categoryColor.withValues(alpha: 0.12),
                foregroundColor: categoryColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '• $timestamp',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
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
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.visibility_outlined,
                size: 16,
                color: AvenueColors.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(metaOne, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(width: 16),
              Icon(
                Icons.send_rounded,
                size: 16,
                color: AvenueColors.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  metaTwo,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResidentTypeChip extends StatelessWidget {
  const _ResidentTypeChip({
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: selected
                ? AvenueColors.primary
                : AvenueColors.onSurfaceVariant,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _AdminKindChip extends StatelessWidget {
  const _AdminKindChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AvenueColors.primary : AvenueColors.surfaceHigh,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: selected ? Colors.white : AvenueColors.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _AdminDrawerItem extends StatelessWidget {
  const _AdminDrawerItem({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AvenueColors.primary : AvenueColors.surfaceHigh,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : AvenueColors.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: selected ? Colors.white : AvenueColors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResidentSummaryCard extends StatelessWidget {
  const _ResidentSummaryCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.tint,
    required this.iconColor,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color tint;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 24,
      color: tint,
      child: Column(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(height: 10),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AvenueColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _DirectoryFilterChip extends StatelessWidget {
  const _DirectoryFilterChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? AvenueColors.primary : AvenueColors.surfaceHigh,
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

class _DirectorySectionHeader extends StatelessWidget {
  const _DirectorySectionHeader({
    required this.title,
    required this.count,
    required this.accent,
  });

  final String title;
  final String count;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Text(count, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _AdminDataPlaceholder extends StatelessWidget {
  const _AdminDataPlaceholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 22,
      color: const Color(0xFFF5F6F8),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AvenueColors.onSurfaceVariant),
      ),
    );
  }
}

class _ResidentDirectoryCard extends StatelessWidget {
  const _ResidentDirectoryCard({
    required this.name,
    required this.unit,
    required this.status,
    required this.statusColor,
    required this.actionLabel,
    required this.actionIcon,
    this.imageUrl,
    this.fallbackLabel,
    this.actionColor = AvenueColors.primary,
    this.initialBubble = false,
  });

  final String name;
  final String unit;
  final String status;
  final Color statusColor;
  final String actionLabel;
  final IconData actionIcon;
  final String? imageUrl;
  final String? fallbackLabel;
  final Color actionColor;
  final bool initialBubble;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 26,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (initialBubble)
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCE5FF),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    fallbackLabel ?? '',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AvenueColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                )
              else
                AvenueNetworkAvatar(
                  imageUrl: imageUrl ?? '',
                  size: 42,
                  fallbackLabel: fallbackLabel,
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      unit,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              AvenuePill(
                label: status,
                backgroundColor: statusColor.withValues(alpha: 0.12),
                foregroundColor: statusColor,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: actionColor.withValues(
                      alpha: actionColor == AvenueColors.primary ? 0.08 : 0.14,
                    ),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    actionLabel,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: actionColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AvenueColors.outlineVariant.withValues(alpha: 0.35),
                  ),
                ),
                child: Icon(actionIcon, color: actionColor, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
