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
  String _visitorLogView = 'inside';
  String _visitPurpose = 'Delivery / Courier';
  bool _isSubmittingManualEntry = false;
  String? _activePassId;
  String? _activeCheckoutPassId;

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
                        if (_selectedTab != 'attendance') ...[
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
                        ],
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
                            isSubmitting: _isSubmittingManualEntry,
                            onScanQr: _handleScanQr,
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
                        else if (_selectedTab == 'visitor')
                          _GuardVisitorLogsTab(
                            isLoading: isLoading,
                            hasError: hasError,
                            selectedView: _visitorLogView,
                            onViewChanged: (value) => setState(() {
                              _visitorLogView = value;
                            }),
                            visitors: data?.visitorLogs ?? const [],
                            logs: data?.logs ?? const [],
                            activePassId: _activePassId,
                            activeCheckoutPassId: _activeCheckoutPassId,
                            onApproveVisitor: _handleApproveVisitorPass,
                            onDenyVisitor: _handleDenyVisitorPass,
                            onCheckoutVisitor: _handleCheckoutVisitorPass,
                            onFilterTap: () => _showInfo(
                              'Advanced visitor filters can be connected next.',
                            ),
                          )
                        else if (_selectedTab == 'logs')
                          _GuardDailyEntryAnalyticsTab(
                            isLoading: isLoading,
                            hasError: hasError,
                            visitors: data?.visitorLogs ?? const [],
                            logs: data?.logs ?? const [],
                          )
                        else
                          _GuardAttendanceTab(
                            repository: _repository,
                            onMarked: _refreshDashboard,
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

  Future<void> _handleApproveEntry() async {
    final visitorName = _visitorNameController.text.trim();
    final flatNumber = _flatNumberController.text.trim();
    final phone = _contactNumberController.text.trim();

    if (visitorName.isEmpty || flatNumber.isEmpty) {
      _showInfo('Enter visitor name and flat number before approving entry.');
      return;
    }

    setState(() {
      _isSubmittingManualEntry = true;
    });

    try {
      final result = await _repository.createGuardVisitorEntry(
        visitorName: visitorName,
        unitNumber: flatNumber,
        purpose: _visitPurpose,
        phone: phone.isEmpty ? null : phone,
        visitorKind: _visitorKindForPurpose(_visitPurpose),
        decision: 'approved',
      );

      if (result == null) {
        _showInfo('Could not create the visitor entry.');
        return;
      }

      _visitorNameController.clear();
      _flatNumberController.clear();
      _contactNumberController.clear();
      await _refreshDashboard();
      _showInfo(
        '${result['visitor_name']} checked in for unit ${result['unit_number']}. PIN ${result['pin_code']} created.',
      );
    } catch (error) {
      _showInfo(_friendlyGuardError(error));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmittingManualEntry = false;
        });
      }
    }
  }

  Future<void> _handleDenyEntry() async {
    final visitorName = _visitorNameController.text.trim();
    final flatNumber = _flatNumberController.text.trim();
    final phone = _contactNumberController.text.trim();

    if (visitorName.isEmpty || flatNumber.isEmpty) {
      _showInfo('Enter visitor name and flat number before denying entry.');
      return;
    }

    setState(() {
      _isSubmittingManualEntry = true;
    });

    try {
      final result = await _repository.createGuardVisitorEntry(
        visitorName: visitorName,
        unitNumber: flatNumber,
        purpose: _visitPurpose,
        phone: phone.isEmpty ? null : phone,
        visitorKind: _visitorKindForPurpose(_visitPurpose),
        decision: 'denied',
      );

      if (result == null) {
        _showInfo('Could not record the denied visitor attempt.');
        return;
      }

      _visitorNameController.clear();
      _flatNumberController.clear();
      _contactNumberController.clear();
      await _refreshDashboard();
      _showInfo(
        '${result['visitor_name']} was denied for unit ${result['unit_number']}.',
      );
    } catch (error) {
      _showInfo(_friendlyGuardError(error));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmittingManualEntry = false;
        });
      }
    }
  }

  Future<void> _handleApproveVisitorPass(
    String passId,
    String visitorName,
  ) async {
    await _processVisitorPass(
      passId: passId,
      visitorName: visitorName,
      decision: 'approved',
    );
  }

  Future<void> _handleDenyVisitorPass(String passId, String visitorName) async {
    await _processVisitorPass(
      passId: passId,
      visitorName: visitorName,
      decision: 'denied',
    );
  }

  Future<void> _handleCheckoutVisitorPass(
    String passId,
    String visitorName,
  ) async {
    setState(() {
      _activeCheckoutPassId = passId;
    });

    try {
      final result = await _repository.checkoutGuardVisitorPass(passId: passId);
      if (result == null) {
        _showInfo('Could not check out this visitor right now.');
        return;
      }

      await _refreshDashboard();
      _showInfo('$visitorName has been checked out.');
    } catch (error) {
      _showInfo(_friendlyGuardError(error));
    } finally {
      if (mounted) {
        setState(() {
          _activeCheckoutPassId = null;
        });
      }
    }
  }

  Future<void> _processVisitorPass({
    required String passId,
    required String visitorName,
    required String decision,
  }) async {
    setState(() {
      _activePassId = passId;
    });

    try {
      final result = await _repository.processGuardVisitorPass(
        passId: passId,
        decision: decision,
      );

      if (result == null) {
        _showInfo('Could not update the visitor pass.');
        return;
      }

      await _refreshDashboard();
      _showInfo(
        decision == 'approved'
            ? '$visitorName has been checked in.'
            : '$visitorName has been denied at the gate.',
      );
    } catch (error) {
      _showInfo(_friendlyGuardError(error));
    } finally {
      if (mounted) {
        setState(() {
          _activePassId = null;
        });
      }
    }
  }

  Future<void> _handleScanQr() async {
    final code = await _promptForQrCode();
    if (!mounted || code == null || code.trim().isEmpty) {
      return;
    }

    try {
      final result = await _repository.processGuardQrEntry(code: code);

      if (result == null) {
        _showInfo('Could not process that QR or PIN code.');
        return;
      }

      await _refreshDashboard();
      _showInfo('${result['visitor_name']} has been checked in from QR.');
    } catch (error) {
      _showInfo(_friendlyGuardError(error));
    }
  }

  Future<String?> _promptForQrCode() async {
    final controller = TextEditingController();
    try {
      return await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Process QR / PIN'),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'QR token or PIN code',
                hintText: 'e.g. QR-DEL-1034 or 4821',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () =>
                    Navigator.of(context).pop(controller.text.trim()),
                child: const Text('Process'),
              ),
            ],
          );
        },
      );
    } finally {
      controller.dispose();
    }
  }

  String _visitorKindForPurpose(String purpose) {
    final normalized = purpose.trim().toLowerCase();
    if (normalized.contains('delivery') || normalized.contains('courier')) {
      return 'delivery';
    }
    if (normalized.contains('service') || normalized.contains('maintenance')) {
      return 'service';
    }
    return 'guest';
  }

  String _friendlyGuardError(Object error) {
    final message = error.toString();
    if (message.contains('No resident was found for unit')) {
      return 'No resident record was found for that unit number.';
    }
    if (message.contains('No visitor pass matched')) {
      return 'No visitor pass matched that QR or PIN code.';
    }
    if (message.contains('Visitor pass is not pending')) {
      return 'That visitor pass has already been processed.';
    }
    return 'Guard action failed. Please try again.';
  }

  void _showInfo(String message) {
    if (!mounted) {
      return;
    }

    final lowerMessage = message.toLowerCase();
    final isError =
        lowerMessage.contains('could not') ||
        lowerMessage.contains('failed') ||
        lowerMessage.contains('enter ') ||
        lowerMessage.contains('no resident') ||
        lowerMessage.contains('no visitor') ||
        lowerMessage.contains('already been processed');
    showAvenueDialogMessage(
      context,
      message: message,
      type: isError ? AvenueMessageType.error : AvenueMessageType.info,
    );
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
  });

  final String selectedTab;
  final ValueChanged<String> onSelect;

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
              selected: selectedTab == 'visitor',
              onTap: () => onSelect('visitor'),
            ),
            _GuardBottomNavItem(
              label: 'Logs',
              icon: Icons.analytics_rounded,
              selected: selectedTab == 'logs',
              onTap: () => onSelect('logs'),
            ),
            _GuardBottomNavItem(
              label: 'Attendance',
              icon: Icons.fact_check_rounded,
              selected: selectedTab == 'attendance',
              onTap: () => onSelect('attendance'),
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
