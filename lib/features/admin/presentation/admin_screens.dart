import 'package:flutter/material.dart';

import '../../../app/app_page.dart';
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

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Avenue360',
        leading: AvenueIconButton(icon: Icons.menu_rounded, onPressed: () {}),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: AvenueNetworkAvatar(
              imageUrl: _adminAvatarUrl,
              size: 36,
              fallbackLabel: 'M',
            ),
          ),
        ],
      ),
      body: _AdminScrollView(
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
              'Welcome back, Marcus. Here is what is happening across Avenue360 today.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AvenueColors.onSurfaceVariant,
                height: 1.5,
              ),
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
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
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
            const _TransactionTile(
              icon: Icons.receipt_long_rounded,
              iconBackground: Color(0xFFFFE9C2),
              iconColor: Color(0xFF8F6500),
              title: 'Maintenance -\nUnit 402',
              subtitle: 'Today, 10:45 AM',
              amount: '+\$450.00',
              status: 'SUCCESS',
              statusColor: Color(0xFF2E9A53),
            ),
            const SizedBox(height: 12),
            const _TransactionTile(
              icon: Icons.flash_on_rounded,
              iconBackground: Color(0xFFE7F0FF),
              iconColor: AvenueColors.primary,
              title: 'Utility -\nCommon Area',
              subtitle: 'Yesterday',
              amount: '-\$2,120.50',
              status: 'AUTO-PAID',
              statusColor: AvenueColors.onSurfaceVariant,
            ),
          ],
        ),
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

class AnnouncementsManagementScreen extends StatelessWidget {
  const AnnouncementsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Announcements',
        leading: AvenueIconButton(icon: Icons.menu_rounded, onPressed: () {}),
        actions: const [
          Padding(
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
        onPressed: () {},
        backgroundColor: AvenueColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
      ),
      body: _AdminScrollView(
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
            const _AnnouncementHistoryCard(
              category: 'URGENT',
              categoryColor: AvenueColors.primary,
              timestamp: '2 hours ago',
              title: 'Water Supply Interruption - Block B',
              body:
                  'Emergency repairs are being carried out on the main line. Water supply will be unavailable from 2:00 PM to 5:00 PM today...',
              metaOne: '412 Reads',
              metaTwo: 'Residents, Owners',
            ),
            const SizedBox(height: 14),
            const _AnnouncementHistoryCard(
              category: 'GENERAL',
              categoryColor: AvenueColors.onSurfaceVariant,
              timestamp: 'Yesterday, 10:15 AM',
              title: 'New Waste Disposal Guidelines',
              body:
                  'To improve our community recycling efforts, we have updated the disposal schedule for different types of household waste...',
              metaOne: '385 Reads',
              metaTwo: 'All Residents',
            ),
            const SizedBox(height: 14),
            const _AnnouncementHistoryCard(
              category: 'EVENT',
              categoryColor: Color(0xFFAA7A00),
              timestamp: 'Oct 24, 2024',
              title: 'Annual Garden Tea Party',
              body:
                  'Join us for an afternoon of community bonding at the North Pavilion. Refreshments will be served and kids\' activities planned...',
              metaOne: '290 Reads',
              metaTwo: 'All Residents',
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
      ),
      bottomNavigation: AvenueBottomNavigationBar(
        items: _adminNavItems,
        currentPage: AppPage.announcementsManagement,
      ),
    );
  }
}

class AddResidentScreen extends StatelessWidget {
  const AddResidentScreen({super.key});

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
                  const AvenueInputField(
                    label: 'FULL NAME',
                    hintText: 'e.g. Jonathan Doe',
                    icon: Icons.person_rounded,
                  ),
                  const SizedBox(height: 14),
                  const AvenueInputField(
                    label: 'EMAIL ADDRESS',
                    hintText: 'j.doe@example.com',
                    icon: Icons.mail_outline_rounded,
                  ),
                  const SizedBox(height: 14),
                  const AvenueInputField(
                    label: 'PHONE NUMBER',
                    hintText: '+1 (555) 000-0000',
                    icon: Icons.call_rounded,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'LEASE & UNIT',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const AvenueInputField(
                    label: 'UNIT NUMBER',
                    hintText: 'e.g. B-204',
                    icon: Icons.apartment_rounded,
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
                    child: const Row(
                      children: [
                        Expanded(
                          child: _ResidentTypeChip(
                            label: 'Owner',
                            selected: true,
                          ),
                        ),
                        Expanded(child: _ResidentTypeChip(label: 'Tenant')),
                        Expanded(child: _ResidentTypeChip(label: 'Family')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  const AvenueInputField(
                    label: 'MOVE-IN DATE',
                    hintText: 'Select Date',
                    icon: Icons.calendar_today_rounded,
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
                          label: 'Add Resident',
                          onPressed: () {},
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
}

class ResidentDirectoryScreen extends StatelessWidget {
  const ResidentDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'ResidentDirectory',
        leading: AvenueIconButton(icon: Icons.menu_rounded, onPressed: () {}),
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
      body: _AdminScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AvenueSearchField(hintText: 'Search by name or unit...'),
            const SizedBox(height: 16),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _DirectoryFilterChip(label: 'All Residents', selected: true),
                  SizedBox(width: 10),
                  _DirectoryFilterChip(label: 'Owners'),
                  SizedBox(width: 10),
                  _DirectoryFilterChip(label: 'Tenants'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const _DirectorySectionHeader(
              title: 'PROPERTY OWNERS',
              count: '248 Total',
              accent: AvenueColors.primary,
            ),
            const SizedBox(height: 14),
            const _ResidentDirectoryCard(
              imageUrl: _directoryAlexanderUrl,
              fallbackLabel: 'AS',
              name: 'Alexander Sterling',
              unit: 'UNIT 1402 • TOWER A',
              status: 'ACTIVE',
              statusColor: Color(0xFF2E9A53),
              actionLabel: 'View Profile',
              actionIcon: Icons.mail_rounded,
            ),
            const SizedBox(height: 14),
            const _ResidentDirectoryCard(
              imageUrl: _directoryElenaUrl,
              fallbackLabel: 'ER',
              name: 'Elena Rodriguez',
              unit: 'UNIT 0805 • TOWER B',
              status: 'PENDING',
              statusColor: Color(0xFFE29B00),
              actionLabel: 'View Profile',
              actionIcon: Icons.priority_high_rounded,
            ),
            const SizedBox(height: 14),
            const _ResidentDirectoryCard(
              fallbackLabel: 'MW',
              name: 'Marcus Wainwright',
              unit: 'UNIT 2201 • PH',
              status: 'ACTIVE',
              statusColor: Color(0xFF2E9A53),
              actionLabel: 'View Profile',
              actionIcon: Icons.verified_rounded,
              initialBubble: true,
            ),
            const SizedBox(height: 24),
            const _DirectorySectionHeader(
              title: 'REGISTERED TENANTS',
              count: '112 Total',
              accent: Color(0xFF8B6500),
            ),
            const SizedBox(height: 14),
            const _ResidentDirectoryCard(
              imageUrl: _directoryJamesonUrl,
              fallbackLabel: 'JC',
              name: 'Jameson Chen',
              unit: 'UNIT 0411 • TOWER A',
              status: 'ACTIVE',
              statusColor: Color(0xFF2E9A53),
              actionLabel: 'View Lease',
              actionIcon: Icons.description_outlined,
            ),
            const SizedBox(height: 14),
            const _ResidentDirectoryCard(
              imageUrl: _directorySarahUrl,
              fallbackLabel: 'SJ',
              name: 'Sarah Jenkins',
              unit: 'UNIT 1109 • TOWER C',
              status: 'EXPIRED',
              statusColor: Color(0xFFFF7C74),
              actionLabel: 'Renew Notice',
              actionIcon: Icons.priority_high_rounded,
              actionColor: Color(0xFFFF7C74),
            ),
          ],
        ),
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
  const _ResidentTypeChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
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
