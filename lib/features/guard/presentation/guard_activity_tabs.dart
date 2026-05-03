part of 'guard_screen.dart';

class _GuardVisitorLogsTab extends StatelessWidget {
  const _GuardVisitorLogsTab({
    required this.isLoading,
    required this.hasError,
    required this.selectedView,
    required this.onViewChanged,
    required this.visitors,
    required this.logs,
    required this.activePassId,
    required this.activeCheckoutPassId,
    required this.onApproveVisitor,
    required this.onDenyVisitor,
    required this.onCheckoutVisitor,
    required this.onFilterTap,
  });

  final bool isLoading;
  final bool hasError;
  final String selectedView;
  final ValueChanged<String> onViewChanged;
  final List<Map<String, dynamic>> visitors;
  final List<Map<String, dynamic>> logs;
  final String? activePassId;
  final String? activeCheckoutPassId;
  final Future<void> Function(String passId, String visitorName)
  onApproveVisitor;
  final Future<void> Function(String passId, String visitorName) onDenyVisitor;
  final Future<void> Function(String passId, String visitorName)
  onCheckoutVisitor;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    final currentlyInside = visitors
        .where(
          (row) => const {
            'approved',
            'expected',
            'checked_in',
          }.contains(_normalize(row['status'])),
        )
        .toList();
    final historyRows = logs.take(12).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Visitor Logs',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: _GuardPalette.surfaceMid,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              _GuardTabButton(
                label: 'Currently Inside',
                selected: selectedView == 'inside',
                onTap: () => onViewChanged('inside'),
              ),
              _GuardTabButton(
                label: 'History',
                selected: selectedView == 'history',
                onTap: () => onViewChanged('history'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onFilterTap,
          icon: const Icon(Icons.tune_rounded),
          label: const Text('Filter Results'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AvenueColors.primary,
            side: BorderSide(
              color: _GuardPalette.outline.withValues(alpha: 0.7),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(height: 16),
        if (hasError)
          const _GuardMessageCard(
            title: 'Could not load visitor logs',
            body: 'Please retry after checking visitor and duty log records.',
          )
        else if (isLoading)
          const _GuardMessageCard(
            title: 'Loading visitor logs',
            body: 'Fetching currently inside and recent history...',
          )
        else if (selectedView == 'inside')
          if (currentlyInside.isEmpty)
            const _GuardMessageCard(
              title: 'No visitors currently inside',
              body: 'Active entry records will appear here in real time.',
            )
          else
            ...currentlyInside.map(
              (row) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _GuardInsideVisitorCard(
                  row: row,
                  isProcessing: activePassId == row['id']?.toString(),
                  isCheckoutProcessing:
                      activeCheckoutPassId == row['id']?.toString(),
                  onApprove: () => onApproveVisitor(
                    row['id'].toString(),
                    row['visitor_name']?.toString() ?? 'Visitor',
                  ),
                  onDeny: () => onDenyVisitor(
                    row['id'].toString(),
                    row['visitor_name']?.toString() ?? 'Visitor',
                  ),
                  onCheckout: () => onCheckoutVisitor(
                    row['id'].toString(),
                    row['visitor_name']?.toString() ?? 'Visitor',
                  ),
                ),
              ),
            )
        else ...[
          Text(
            'Recent History',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          Text(
            'Last 24 hours activity logs',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: _GuardPalette.muted),
          ),
          const SizedBox(height: 12),
          if (historyRows.isEmpty)
            const _GuardMessageCard(
              title: 'No recent history',
              body: 'Visitor activity logs will appear here as events happen.',
            )
          else
            ...historyRows.map(
              (row) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _GuardHistoryRowCard(row: row),
              ),
            ),
        ],
      ],
    );
  }
}

class _GuardDailyEntryAnalyticsTab extends StatelessWidget {
  const _GuardDailyEntryAnalyticsTab({
    required this.isLoading,
    required this.hasError,
    required this.visitors,
    required this.logs,
  });

  final bool isLoading;
  final bool hasError;
  final List<Map<String, dynamic>> visitors;
  final List<Map<String, dynamic>> logs;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayVisitors = visitors.where((row) {
      final parsed = DateTime.tryParse(
        row['created_at']?.toString() ??
            row['expected_arrival']?.toString() ??
            '',
      );
      if (parsed == null) {
        return false;
      }
      final local = parsed.toLocal();
      return local.year == now.year &&
          local.month == now.month &&
          local.day == now.day;
    }).toList();

    int countKind(String kind) => todayVisitors
        .where((row) => _normalize(row['visitor_kind']) == kind)
        .length;

    final totalEntries = todayVisitors.length;
    final guestCount = countKind('guest');
    final deliveryCount = countKind('delivery');
    final serviceCount = countKind('service');
    final staffCount = logs
        .where((row) => _normalize(row['title']).contains('staff'))
        .length;

    final totalForBreakdown = [
      guestCount,
      deliveryCount,
      serviceCount,
      staffCount,
    ].reduce((a, b) => a + b);

    int percent(int value) {
      if (totalForBreakdown <= 0) {
        return 0;
      }
      return ((value / totalForBreakdown) * 100).round();
    }

    final hourlyBuckets = List<int>.filled(6, 0);
    for (final row in todayVisitors) {
      final parsed = DateTime.tryParse(
        row['created_at']?.toString() ??
            row['expected_arrival']?.toString() ??
            '',
      );
      if (parsed == null) {
        continue;
      }
      final local = parsed.toLocal();
      final bucket = ((local.hour.clamp(8, 19) - 8) / 2).floor().clamp(0, 5);
      hourlyBuckets[bucket]++;
    }
    final maxBucket = hourlyBuckets.fold<int>(1, (a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Entry Analytics',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 14),
        if (hasError)
          const _GuardMessageCard(
            title: 'Could not load analytics',
            body: 'Please retry after checking guard data sync.',
          )
        else if (isLoading)
          const _GuardMessageCard(
            title: 'Loading analytics',
            body: 'Building daily summary and traffic distribution...',
          )
        else ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
            decoration: BoxDecoration(
              gradient: AvenueColors.primaryGradient,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33005BBF),
                  blurRadius: 24,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DAILY SUMMARY',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total Entries:\n$totalEntries',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    height: 1.06,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.trending_up_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Live from today',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _GuardGlassCard(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Visitor Breakdown',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _GuardBreakdownBar(
                    label: 'Guests',
                    count: guestCount,
                    percent: percent(guestCount),
                    color: AvenueColors.primary,
                  ),
                  const SizedBox(height: 10),
                  _GuardBreakdownBar(
                    label: 'Deliveries',
                    count: deliveryCount,
                    percent: percent(deliveryCount),
                    color: const Color(0xFF00769A),
                  ),
                  const SizedBox(height: 10),
                  _GuardBreakdownBar(
                    label: 'Staff',
                    count: staffCount,
                    percent: percent(staffCount),
                    color: const Color(0xFF2A6CB0),
                  ),
                  const SizedBox(height: 10),
                  _GuardBreakdownBar(
                    label: 'Services',
                    count: serviceCount,
                    percent: percent(serviceCount),
                    color: const Color(0xFF7A808A),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          _GuardGlassCard(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Entry Traffic (Last 12h)',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AvenueColors.primaryFixed,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'PEAK: ${_peakHourLabel(hourlyBuckets)}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AvenueColors.primary,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (final bucket in hourlyBuckets)
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            height: 26 + (bucket / maxBucket) * 88,
                            decoration: BoxDecoration(
                              color: AvenueColors.primary.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              gradient: bucket == maxBucket
                                  ? AvenueColors.primaryGradient
                                  : null,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Recent Activity Log',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              TextButton(onPressed: () {}, child: const Text('View All')),
            ],
          ),
          ...logs
              .take(8)
              .map(
                (row) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _GuardAnalyticsActivityRow(row: row),
                ),
              ),
        ],
      ],
    );
  }
}

class _GuardInsideVisitorCard extends StatelessWidget {
  const _GuardInsideVisitorCard({
    required this.row,
    required this.isProcessing,
    required this.isCheckoutProcessing,
    required this.onApprove,
    required this.onDeny,
    required this.onCheckout,
  });

  final Map<String, dynamic> row;
  final bool isProcessing;
  final bool isCheckoutProcessing;
  final VoidCallback onApprove;
  final VoidCallback onDeny;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final status = _normalize(row['status']);
    final statusColor = _guardStatusColor(status);
    final visitorName = row['visitor_name']?.toString() ?? 'Visitor';
    final kind = _titleCase(row['visitor_kind']?.toString() ?? 'Visitor');
    final initials = _initialsFor(visitorName);

    return _GuardGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AvenueColors.primaryFixed,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    initials,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AvenueColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        visitorName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        kind,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _GuardPalette.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    _statusLabelForVisitor(status),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.7,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _GuardFieldMini(
                    label: 'FLAT',
                    value: row['unit_number']?.toString() ?? '-',
                  ),
                ),
                Expanded(
                  child: _GuardFieldMini(
                    label: 'ENTRY TIME',
                    value: _guardArrivalLabel(row['expected_arrival']),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (status == 'approved' || status == 'expected')
              Row(
                children: [
                  Expanded(
                    child: _GuardPrimaryButton(
                      label: isProcessing ? 'Processing...' : 'Allow Entry',
                      icon: Icons.check_circle_rounded,
                      onTap: isProcessing ? null : onApprove,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _GuardSecondaryDangerButton(
                      label: 'Deny',
                      icon: Icons.cancel_rounded,
                      onTap: isProcessing ? null : onDeny,
                    ),
                  ),
                ],
              )
            else
              _GuardPrimaryButton(
                label: isCheckoutProcessing ? 'Checking Out...' : 'Check Out',
                icon: Icons.logout_rounded,
                onTap: isCheckoutProcessing ? null : onCheckout,
              ),
          ],
        ),
      ),
    );
  }
}

class _GuardHistoryRowCard extends StatelessWidget {
  const _GuardHistoryRowCard({required this.row});

  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) {
    final status = _normalize(row['log_status']);
    final statusColor = _guardStatusColor(status);

    return _GuardGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              row['related_visitor_name']?.toString() ??
                  row['title']?.toString() ??
                  'Visitor',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 2),
            Text(
              '${row['details']?.toString() ?? 'Activity'} • ${row['related_unit'] ?? '-'}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: _GuardPalette.muted),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _GuardFieldMini(
                    label: 'ENTRY',
                    value: _guardArrivalLabel(row['logged_at']),
                  ),
                ),
                Expanded(
                  child: _GuardFieldMini(
                    label: 'EXIT',
                    value: _guardArrivalLabel(row['logged_at']),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    status.isEmpty ? 'LOGGED' : status.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w900,
                    ),
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

class _GuardBreakdownBar extends StatelessWidget {
  const _GuardBreakdownBar({
    required this.label,
    required this.count,
    required this.percent,
    required this.color,
  });

  final String label;
  final int count;
  final int percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Text(label)),
            Text('$count ($percent%)'),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: (percent / 100).clamp(0, 1),
            minHeight: 10,
            backgroundColor: _GuardPalette.surfaceMid,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _GuardAnalyticsActivityRow extends StatelessWidget {
  const _GuardAnalyticsActivityRow({required this.row});

  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) {
    final status = _normalize(row['log_status']);
    final statusColor = _guardStatusColor(status);
    final visitorName = row['related_visitor_name']?.toString() ?? 'Activity';
    final subtitle = '${row['related_unit'] ?? '-'} • ${row['title'] ?? 'Log'}';

    return _GuardGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AvenueColors.primaryFixed,
              child: Text(
                _initialsFor(visitorName),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AvenueColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    visitorName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: _GuardPalette.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _guardArrivalLabel(row['logged_at']),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AvenueColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    status.isEmpty ? 'LOGGED' : status.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w900,
                    ),
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

class _GuardFieldMini extends StatelessWidget {
  const _GuardFieldMini({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: _GuardPalette.muted,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}

class _GuardAttendanceTab extends StatefulWidget {
  const _GuardAttendanceTab({required this.repository, required this.onMarked});

  final AvenueRepository repository;
  final Future<void> Function() onMarked;

  @override
  State<_GuardAttendanceTab> createState() => _GuardAttendanceTabState();
}

class _GuardAttendanceTabState extends State<_GuardAttendanceTab> {
  late Future<_GuardAttendanceData> _future;
  String? _activeAction;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_GuardAttendanceData> _load() async {
    final results = await Future.wait([
      widget.repository.fetchGuardTodayAttendance(),
      widget.repository.fetchGuardAttendanceHistory(),
    ]);
    return _GuardAttendanceData(
      today: results[0] as Map<String, dynamic>?,
      history: results[1] as List<Map<String, dynamic>>,
    );
  }

  Future<void> _mark(String action) async {
    if (_activeAction != null) {
      return;
    }

    setState(() {
      _activeAction = action;
    });

    try {
      await widget.repository.setGuardAttendance(action: action, notes: null);
      if (!mounted) {
        return;
      }

      setState(() {
        _future = _load();
      });
      await widget.onMarked();
      if (!mounted) {
        return;
      }

      await showAvenueDialogMessage(
        context,
        message: action == 'check_in'
            ? 'Attendance check-in marked successfully.'
            : 'Attendance check-out marked successfully.',
        type: AvenueMessageType.success,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      await showAvenueDialogMessage(
        context,
        message: _friendlyAttendanceError(error),
        type: AvenueMessageType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _activeAction = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_GuardAttendanceData>(
      future: _future,
      builder: (context, snapshot) {
        final today = snapshot.data?.today;
        final history =
            snapshot.data?.history ?? const <Map<String, dynamic>>[];
        final isLoading = snapshot.connectionState != ConnectionState.done;
        final hasError = snapshot.hasError;

        final checkedInAt = today?['check_in_at'];
        final checkedOutAt = today?['check_out_at'];
        final hasCheckedIn = checkedInAt != null;
        final hasCheckedOut = checkedOutAt != null;
        final canCheckIn = !hasCheckedIn;
        final canCheckOut = hasCheckedIn && !hasCheckedOut;
        final action = canCheckIn ? 'check_in' : 'check_out';
        final isMarking = _activeAction != null;
        final canTapPrimary =
            !isLoading && !isMarking && (canCheckIn || canCheckOut);
        final actionLabel = hasCheckedOut
            ? 'ATTENDANCE COMPLETED'
            : isMarking
            ? 'LOGGING ATTENDANCE...'
            : canCheckIn
            ? 'LOG ATTENDANCE'
            : 'LOG CHECK-OUT';
        final actionHint = hasCheckedOut
            ? 'You already completed attendance for today.'
            : canCheckIn
            ? 'Take a selfie to enable check-in'
            : 'Tap to mark shift check-out';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'ATTENDANCE LOG',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AvenueColors.primary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (hasError)
              const _GuardMessageCard(
                title: 'Could not load attendance',
                body: 'Please retry after checking attendance records.',
              )
            else ...[
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFDCE3E8),
                  borderRadius: BorderRadius.circular(34),
                  border: Border.all(
                    color: _GuardPalette.outline.withValues(alpha: 0.45),
                  ),
                ),
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(34),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFFE5EBF1), Color(0xFFD0D7DF)],
                            ),
                          ),
                        ),
                      ),
                      const Positioned(
                        top: 22,
                        left: 22,
                        child: _GuardCameraCorner(side: _CornerSide.topLeft),
                      ),
                      const Positioned(
                        top: 22,
                        right: 22,
                        child: _GuardCameraCorner(side: _CornerSide.topRight),
                      ),
                      const Positioned(
                        bottom: 22,
                        left: 22,
                        child: _GuardCameraCorner(side: _CornerSide.bottomLeft),
                      ),
                      const Positioned(
                        bottom: 22,
                        right: 22,
                        child: _GuardCameraCorner(
                          side: _CornerSide.bottomRight,
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.photo_camera_rounded,
                              size: 68,
                              color: _GuardPalette.muted.withValues(
                                alpha: 0.52,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Camera preview will appear here',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: _GuardPalette.muted.withValues(
                                      alpha: 0.8,
                                    ),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  actionHint,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _GuardPalette.ink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: canTapPrimary ? () => _mark(action) : null,
                  icon: Icon(
                    hasCheckedOut
                        ? Icons.task_alt_rounded
                        : canCheckIn
                        ? Icons.how_to_reg_rounded
                        : Icons.logout_rounded,
                  ),
                  label: Text(actionLabel),
                  style: FilledButton.styleFrom(
                    backgroundColor: hasCheckedOut
                        ? const Color(0xFFD5DEE8)
                        : AvenueColors.primary,
                    foregroundColor: hasCheckedOut
                        ? const Color(0xFF2F3B4E)
                        : Colors.white,
                    minimumSize: const Size.fromHeight(58),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(
                        color: _GuardPalette.outline.withValues(alpha: 0.5),
                      ),
                    ),
                    textStyle: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.4,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  isLoading
                      ? 'Loading attendance...'
                      : hasCheckedOut
                      ? 'In: ${_attendanceTimeLabel(checkedInAt)} • Out: ${_attendanceTimeLabel(checkedOutAt)}'
                      : canCheckIn
                      ? 'Selfie required to log'
                      : 'Checked in at ${_attendanceTimeLabel(checkedInAt)}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: _GuardPalette.muted),
                ),
              ),
              const SizedBox(height: 18),
              Divider(
                color: _GuardPalette.outline.withValues(alpha: 0.45),
                height: 1,
              ),
              const SizedBox(height: 18),
              Text(
                'Previous Attendance History',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              if (isLoading)
                const _GuardMessageCard(
                  title: 'Loading attendance history',
                  body: 'Fetching latest attendance records...',
                )
              else if (history.isEmpty)
                const _GuardMessageCard(
                  title: 'No attendance records yet',
                  body: 'Your attendance history will appear after check-in.',
                )
              else
                ...history
                    .take(12)
                    .map(
                      (row) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _GuardAttendanceHistoryCard(row: row),
                      ),
                    ),
            ],
          ],
        );
      },
    );
  }
}

class _GuardAttendanceData {
  const _GuardAttendanceData({required this.today, required this.history});

  final Map<String, dynamic>? today;
  final List<Map<String, dynamic>> history;
}

class _GuardAttendanceHistoryCard extends StatelessWidget {
  const _GuardAttendanceHistoryCard({required this.row});

  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) {
    final checkIn = row['check_in_at'];
    final checkOut = row['check_out_at'];
    final status = _normalize(row['status']);
    final isCompleted = status == 'completed' || checkOut != null;

    return Container(
      decoration: BoxDecoration(
        color: _GuardPalette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _GuardPalette.outline.withValues(alpha: 0.18),
        ),
        boxShadow: const [
          BoxShadow(
            color: _GuardPalette.shadow,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFA5C8DB), Color(0xFF4E86A7)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 38,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_attendanceMonthDayLabel(row['attendance_date'])}, Day Shift',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'In: ${_attendanceTimeLabel(checkIn)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: _GuardPalette.ink.withValues(alpha: 0.92),
                    ),
                  ),
                  Text(
                    'Out: ${_attendanceTimeLabel(checkOut)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: _GuardPalette.ink.withValues(alpha: 0.92),
                    ),
                  ),
                  if ((row['notes']?.toString().trim().isNotEmpty ?? false))
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        row['notes'].toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _GuardPalette.muted,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AvenueColors.primaryFixed,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: AvenueColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                isCompleted ? 'COMPLETED' : 'PRESENT',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AvenueColors.primary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _CornerSide { topLeft, topRight, bottomLeft, bottomRight }

class _GuardCameraCorner extends StatelessWidget {
  const _GuardCameraCorner({required this.side});

  final _CornerSide side;

  @override
  Widget build(BuildContext context) {
    final borderColor = AvenueColors.primary.withValues(alpha: 0.38);
    final radius = Radius.circular(12);
    BorderRadius cornerRadius;
    Border border;

    switch (side) {
      case _CornerSide.topLeft:
        cornerRadius = BorderRadius.only(topLeft: radius);
        border = Border(
          left: BorderSide(color: borderColor, width: 3),
          top: BorderSide(color: borderColor, width: 3),
        );
        break;
      case _CornerSide.topRight:
        cornerRadius = BorderRadius.only(topRight: radius);
        border = Border(
          right: BorderSide(color: borderColor, width: 3),
          top: BorderSide(color: borderColor, width: 3),
        );
        break;
      case _CornerSide.bottomLeft:
        cornerRadius = BorderRadius.only(bottomLeft: radius);
        border = Border(
          left: BorderSide(color: borderColor, width: 3),
          bottom: BorderSide(color: borderColor, width: 3),
        );
        break;
      case _CornerSide.bottomRight:
        cornerRadius = BorderRadius.only(bottomRight: radius);
        border = Border(
          right: BorderSide(color: borderColor, width: 3),
          bottom: BorderSide(color: borderColor, width: 3),
        );
        break;
    }

    return SizedBox(
      width: 44,
      height: 44,
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: cornerRadius, border: border),
      ),
    );
  }
}

String _statusLabelForVisitor(String status) {
  switch (status) {
    case 'approved':
      return 'VERIFIED';
    case 'expected':
      return 'EXPECTED';
    case 'checked_in':
      return 'INSIDE';
    case 'checked_out':
      return 'EXITED';
    default:
      return status.isEmpty ? 'LOGGED' : status.toUpperCase();
  }
}

String _peakHourLabel(List<int> buckets) {
  if (buckets.isEmpty) {
    return '10AM';
  }
  final max = buckets.reduce((a, b) => a > b ? a : b);
  final peakIndices = <int>[];
  for (var i = 0; i < buckets.length; i++) {
    if (buckets[i] == max) {
      peakIndices.add(i);
    }
  }
  final labels = peakIndices
      .take(2)
      .map((index) => '${(8 + (index * 2)).toString().padLeft(2, '0')}AM')
      .toList();
  return labels.join(' & ');
}

String _initialsFor(String value) {
  final parts = value
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();
  if (parts.isEmpty) {
    return 'V';
  }
  if (parts.length == 1) {
    return parts.first.substring(0, 1).toUpperCase();
  }
  return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
      .toUpperCase();
}

String _attendanceMonthDayLabel(dynamic value) {
  if (value == null) {
    return '--';
  }

  final parsed = value is DateTime
      ? value
      : DateTime.tryParse(value.toString());
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
  final local = parsed.toLocal();
  return '${months[local.month - 1]} ${local.day}';
}

String _attendanceTimeLabel(dynamic value) {
  if (value == null) {
    return '--';
  }

  final parsed = DateTime.tryParse(value.toString());
  if (parsed == null) {
    return value.toString();
  }

  final local = parsed.toLocal();
  final hour = local.hour == 0
      ? 12
      : local.hour > 12
      ? local.hour - 12
      : local.hour;
  final suffix = local.hour >= 12 ? 'PM' : 'AM';
  final minute = local.minute.toString().padLeft(2, '0');
  return '$hour:$minute $suffix';
}

String _friendlyAttendanceError(Object error) {
  final message = error.toString();
  final sanitized = message
      .replaceFirst('PostgrestException(message: ', '')
      .replaceFirst('Exception: ', '')
      .replaceFirst(RegExp(r', code:.*$'), '')
      .trim();
  if (sanitized.contains('Check-in is required')) {
    return 'Please check in before checking out.';
  }
  if (sanitized.contains('Only an active guard')) {
    return 'Only active guard users can mark attendance.';
  }

  if (sanitized.length <= 160) {
    return sanitized;
  }
  return '${sanitized.substring(0, 157)}...';
}
