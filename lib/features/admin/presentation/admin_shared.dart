part of 'admin_screens.dart';

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
                color: title == 'COVE'
                    ? AvenueColors.primary
                    : _AdminPalette.ink,
              ),
            ),
          ),
          if (trailing != null) ...[trailing!, const SizedBox(width: 8)],
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
  const _AdminGlassCard({required this.child, this.radius = 24});

  final Widget child;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _AdminPalette.surface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: _AdminPalette.outline.withValues(alpha: 0.22),
        ),
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

class _AdminMiniInfo extends StatelessWidget {
  const _AdminMiniInfo({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
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
                  color: selected
                      ? AvenueColors.primary
                      : _AdminPalette.surfaceLow,
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
                const Icon(
                  Icons.check_circle_rounded,
                  color: AvenueColors.primary,
                ),
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
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
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
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
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
  const _AdminSearchBar({required this.controller, required this.hintText});

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _AdminPalette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _AdminPalette.outline.withValues(alpha: 0.22),
        ),
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
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: _AdminPalette.muted,
          ),
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
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w900),
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
  const _ResidentAvatar({required this.imageUrl, required this.initials});

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
              Icon(icon, color: selected ? Colors.white : _AdminPalette.muted),
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
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: _AdminPalette.muted),
          ),
        ),
      ),
    );
  }
}
