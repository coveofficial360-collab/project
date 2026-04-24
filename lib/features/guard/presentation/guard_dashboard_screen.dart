part of 'guard_screen.dart';

class GuardHomeScreen extends StatefulWidget {
  const GuardHomeScreen({super.key});

  @override
  State<GuardHomeScreen> createState() => _GuardHomeScreenState();
}

class _GuardHomeScreenState extends State<GuardHomeScreen> {
  final AvenueRepository _repository = AvenueRepository();

  final TextEditingController _visitorNameController = TextEditingController();
  final TextEditingController _flatNumberController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();

  late Future<_GuardDashboardData> _dashboardFuture;

  String _selectedTab = 'entry';
  String _visitPurpose = 'Delivery / Courier';

  @override
  void initState() {
    super.initState();
    _dashboardFuture = _loadDashboard();
  }

  @override
  void dispose() {
    _visitorNameController.dispose();
    _flatNumberController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = AppSession.instance.currentUser;

    return Scaffold(
      backgroundColor: _GuardPalette.background,
      appBar: _GuardTopBar(
        currentUser: currentUser,
        onSearch: () => _showInfo(
          'Visitor lookup search can be connected to live resident records next.',
        ),
        onNotifications: () => _showInfo(
          'Guard notifications can be connected once the alert center is added.',
        ),
        onLogout: () {
          AppSession.instance.clear();
          goToPage(context, AppPage.login, replace: true);
        },
      ),
      body: SafeArea(
        top: false,
        child: FutureBuilder<_GuardDashboardData>(
          future: _dashboardFuture,
          builder: (context, snapshot) {
            final data = snapshot.data;
            final isLoading = snapshot.connectionState != ConnectionState.done;
            final hasError = snapshot.hasError;

            final entriesToday = data?.logs.length ?? 0;
            final currentlyInside =
                data?.upcomingVisitors
                    .where(
                      (row) =>
                          _normalize(row['status']) == 'approved' ||
                          _normalize(row['status']) == 'expected',
                    )
                    .length ??
                0;

            return RefreshIndicator(
              onRefresh: _refreshDashboard,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gate Desk Overview',
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                color: _GuardPalette.ink,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.8,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Monitor approvals, log walk-in visitors, and keep the gate history synced in one place.',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: _GuardPalette.muted,
                                height: 1.45,
                              ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _GuardStatCard(
                                label: 'Total Entries Today',
                                value: isLoading ? '...' : '$entriesToday',
                                icon: Icons.group_rounded,
                                iconTint: AvenueColors.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _GuardStatCard(
                                label: 'Currently Inside',
                                value: isLoading ? '...' : '$currentlyInside',
                                icon: Icons.meeting_room_rounded,
                                iconTint: _GuardPalette.secondary,
                                highlighted: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _GuardTabBar(
                          selectedTab: _selectedTab,
                          onSelect: (value) => setState(() {
                            _selectedTab = value;
                          }),
                        ),
                        const SizedBox(height: 18),
                        if (_selectedTab == 'entry')
                          _GuardEntryTab(
                            visitorNameController: _visitorNameController,
                            flatNumberController: _flatNumberController,
                            contactNumberController: _contactNumberController,
                            selectedPurpose: _visitPurpose,
                            onPurposeChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                _visitPurpose = value;
                              });
                            },
                            onApprove: _handleApproveEntry,
                            onDeny: _handleDenyEntry,
                            onScanQr: () => _showInfo(
                              'QR entry scanning can be connected next.',
                            ),
                            onOpenCamera: () => _showInfo(
                              'Camera capture UI is ready for native integration.',
                            ),
                            onPanicAlert: () => _showInfo(
                              'Emergency escalation action can be connected next.',
                            ),
                            onCallManager: () => _showInfo(
                              'Manager dial action can be connected next.',
                            ),
                          )
                        else if (_selectedTab == 'preapproved')
                          _GuardPreApprovedTab(
                            isLoading: isLoading,
                            hasError: hasError,
                            visitors: data?.upcomingVisitors ?? const [],
                          )
                        else
                          _GuardHistoryTab(
                            isLoading: isLoading,
                            hasError: hasError,
                            logs: data?.logs ?? const [],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _GuardBottomNavigationBar(
        selectedTab: _selectedTab,
        onSelect: (value) => setState(() {
          _selectedTab = value;
        }),
        onProfileTap: () => _showInfo(
          'Guard profile details can be connected when the profile module is added.',
        ),
      ),
    );
  }

  Future<_GuardDashboardData> _loadDashboard() {
    return _GuardDashboardData.load(_repository);
  }

  Future<void> _refreshDashboard() async {
    final future = _loadDashboard();
    setState(() {
      _dashboardFuture = future;
    });
    await future;
  }

  void _handleApproveEntry() {
    final visitorName = _visitorNameController.text.trim();
    final flatNumber = _flatNumberController.text.trim();

    if (visitorName.isEmpty || flatNumber.isEmpty) {
      _showInfo('Enter visitor name and flat number before approving entry.');
      return;
    }

    _showInfo(
      'Manual guard entry workflow UI is ready. Backend action can be connected next.',
    );
  }

  void _handleDenyEntry() {
    _showInfo('Deny entry action can be connected to a guard workflow next.');
  }

  void _showInfo(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _GuardTopBar extends StatelessWidget implements PreferredSizeWidget {
  const _GuardTopBar({
    required this.currentUser,
    required this.onSearch,
    required this.onNotifications,
    required this.onLogout,
  });

  final dynamic currentUser;
  final VoidCallback onSearch;
  final VoidCallback onNotifications;
  final VoidCallback onLogout;

  @override
  Size get preferredSize => const Size.fromHeight(78);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 78,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white.withValues(alpha: 0.84),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  border: Border.all(color: AvenueColors.primary, width: 2),
                  shape: BoxShape.circle,
                ),
                child: Image.network(_guardPortraitUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'COVE',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF0E2A4E),
                    ),
                  ),
                  Text(
                    currentUser?.subtitle ?? 'Gate 1 - North Wing',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AvenueColors.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onSearch,
              icon: const Icon(Icons.search_rounded),
              color: _GuardPalette.muted,
            ),
            IconButton(
              onPressed: onNotifications,
              icon: const Icon(Icons.notifications_none_rounded),
              color: AvenueColors.primary,
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  onLogout();
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem<String>(value: 'logout', child: Text('Logout')),
              ],
              icon: const Icon(Icons.more_vert_rounded),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: _GuardPalette.outline.withValues(alpha: 0.2),
        ),
      ),
    );
  }
}

class _GuardStatCard extends StatelessWidget {
  const _GuardStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconTint,
    this.highlighted = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconTint;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final accentColor = highlighted
        ? _GuardPalette.secondary
        : AvenueColors.primary;
    final foreground = highlighted ? _GuardPalette.secondary : accentColor;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _GuardPalette.surface.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _GuardPalette.outline.withValues(alpha: 0.18),
        ),
        boxShadow: const [
          BoxShadow(
            color: _GuardPalette.shadow,
            blurRadius: 26,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (highlighted)
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _GuardPalette.secondary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          label,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: _GuardPalette.muted,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _GuardPalette.muted,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                const SizedBox(height: 10),
                Text(
                  value,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: foreground,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: highlighted
                  ? const Color(0x1A006686)
                  : const Color(0x12005BBF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 32, color: iconTint),
          ),
        ],
      ),
    );
  }
}

class _GuardTabBar extends StatelessWidget {
  const _GuardTabBar({required this.selectedTab, required this.onSelect});

  final String selectedTab;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _GuardPalette.surfaceMid,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          _GuardTabButton(
            label: 'Log Entry',
            selected: selectedTab == 'entry',
            onTap: () => onSelect('entry'),
          ),
          _GuardTabButton(
            label: 'Pre-Approved',
            selected: selectedTab == 'preapproved',
            onTap: () => onSelect('preapproved'),
          ),
          _GuardTabButton(
            label: 'History',
            selected: selectedTab == 'history',
            onTap: () => onSelect('history'),
          ),
        ],
      ),
    );
  }
}

class _GuardTabButton extends StatelessWidget {
  const _GuardTabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0x10005EA3),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: selected ? AvenueColors.primary : _GuardPalette.muted,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _GuardBottomNavigationBar extends StatelessWidget {
  const _GuardBottomNavigationBar({
    required this.selectedTab,
    required this.onSelect,
    required this.onProfileTap,
  });

  final String selectedTab;
  final ValueChanged<String> onSelect;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.94),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: const [
            BoxShadow(
              color: _GuardPalette.shadow,
              blurRadius: 20,
              offset: Offset(0, -6),
            ),
          ],
        ),
        child: Row(
          children: [
            _GuardBottomNavItem(
              label: 'Home',
              icon: Icons.home_rounded,
              selected: selectedTab == 'entry',
              onTap: () => onSelect('entry'),
            ),
            _GuardBottomNavItem(
              label: 'Visitors',
              icon: Icons.person_search_rounded,
              selected: selectedTab == 'preapproved',
              onTap: () => onSelect('preapproved'),
            ),
            _GuardBottomNavItem(
              label: 'Incidents',
              icon: Icons.history_rounded,
              selected: selectedTab == 'history',
              onTap: () => onSelect('history'),
            ),
            _GuardBottomNavItem(
              label: 'Profile',
              icon: Icons.account_circle_outlined,
              selected: false,
              onTap: onProfileTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _GuardBottomNavItem extends StatelessWidget {
  const _GuardBottomNavItem({
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
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? const Color(0x14005BBF) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: selected ? AvenueColors.primary : _GuardPalette.muted,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: selected ? AvenueColors.primary : _GuardPalette.muted,
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
