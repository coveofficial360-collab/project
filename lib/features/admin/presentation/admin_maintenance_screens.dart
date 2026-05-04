import 'package:flutter/material.dart';

import '../../../app/app_page.dart';
import '../../../core/supabase/avenue_repository.dart';
import '../../../theme/avenue_theme.dart';
import '../../common/presentation/avenue_ui.dart';

class AdminMaintenanceDashboardScreen extends StatelessWidget {
  const AdminMaintenanceDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();

    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Maintenance',
        leading: AvenueIconButton(
          icon: Icons.menu_rounded,
          onPressed: () => Navigator.of(context).pushNamed(
            AppPage.adminMenu.routeName,
            arguments: AppPage.adminMaintenance,
          ),
          filled: true,
        ),
        actions: [
          AvenueIconButton(
            icon: Icons.refresh_rounded,
            onPressed: () => Navigator.of(
              context,
            ).pushReplacementNamed(AppPage.adminMaintenance.routeName),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: repository.fetchAdminMaintenanceResidentLog(),
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          final total = rows.length;
          final paid = rows.where((row) => _status(row) == 'paid').length;
          final pending = rows.where((row) => _status(row) == 'pending').length;
          final overdue = rows.where((row) => _status(row) == 'overdue').length;
          final totalDue = rows
              .where((row) => _status(row) != 'paid')
              .fold<double>(
                0,
                (sum, row) => sum + _toDouble(row['amount_due']),
              );

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvenueCard(
                  radius: 28,
                  child: Row(
                    children: [
                      Expanded(
                        child: _MetricBox(
                          label: 'Residents',
                          value: '$total',
                          icon: Icons.groups_rounded,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _MetricBox(
                          label: 'Paid',
                          value: '$paid',
                          icon: Icons.check_circle_rounded,
                          color: const Color(0xFF1F8E5A),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                AvenueCard(
                  radius: 28,
                  color: AvenueColors.surfaceLow,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Collection Snapshot',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _InfoRow(label: 'Pending', value: '$pending'),
                      _InfoRow(label: 'Overdue', value: '$overdue'),
                      _InfoRow(label: 'Outstanding', value: _money(totalDue)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Quick Actions',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _QuickActionCard(
                      icon: Icons.warning_amber_rounded,
                      label: 'Forced Alert',
                      onTap: () => Navigator.of(context).pushNamed(
                        AppPage.adminMaintenanceForcedAlert.routeName,
                      ),
                    ),
                    _QuickActionCard(
                      icon: Icons.list_alt_rounded,
                      label: 'Resident Log',
                      onTap: () => Navigator.of(context).pushNamed(
                        AppPage.adminMaintenanceResidentLog.routeName,
                      ),
                    ),
                    _QuickActionCard(
                      icon: Icons.notifications_active_rounded,
                      label: 'Notify Settings',
                      onTap: () => Navigator.of(context).pushNamed(
                        AppPage.adminMaintenanceNotificationSettings.routeName,
                      ),
                    ),
                    _QuickActionCard(
                      icon: Icons.file_download_rounded,
                      label: 'Export',
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(AppPage.adminMaintenanceExport.routeName),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AvenueSectionHeader(
                  title: 'Recent Activity',
                  actionLabel: 'View All',
                  onActionTap: () => Navigator.of(
                    context,
                  ).pushNamed(AppPage.adminMaintenanceResidentLog.routeName),
                ),
                const SizedBox(height: 8),
                if (snapshot.connectionState != ConnectionState.done &&
                    rows.isEmpty)
                  const AvenueCard(
                    radius: 16,
                    child: AvenueSkeletonBlock(height: 120, radius: 14),
                  )
                else if (rows.isEmpty)
                  const AvenueCard(
                    radius: 16,
                    child: Text('No maintenance records found.'),
                  )
                else
                  ...rows
                      .take(5)
                      .map(
                        (row) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: AvenueCard(
                            radius: 16,
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              onTap: () => Navigator.of(context).pushNamed(
                                AppPage
                                    .adminMaintenanceResidentDetail
                                    .routeName,
                                arguments: {'resident': row},
                              ),
                              leading: CircleAvatar(
                                backgroundColor: _statusColor(
                                  _status(row),
                                ).withValues(alpha: 0.14),
                                child: Icon(
                                  Icons.person_rounded,
                                  color: _statusColor(_status(row)),
                                ),
                              ),
                              title: Text(
                                row['resident_name']?.toString() ?? 'Resident',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              subtitle: Text(
                                '${row['unit_number'] ?? '-'} • Due ${_date(row['due_date'])}',
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    _money(_maintenanceDisplayAmount(row)),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(height: 2),
                                  _TinyStatusChip(label: _status(row)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
      bottomNavigation: const AvenueBottomNavigationBar(
        items: [
          AvenueNavItem(
            label: 'HOME',
            icon: Icons.home_rounded,
            page: AppPage.adminDrawer,
          ),
          AvenueNavItem(
            label: 'RESIDENTS',
            icon: Icons.group_outlined,
            page: AppPage.residentDirectory,
          ),
          AvenueNavItem(
            label: 'NOTIFY',
            icon: Icons.campaign_outlined,
            page: AppPage.announcementsManagement,
          ),
          AvenueNavItem(
            label: 'REPORTS',
            icon: Icons.summarize_outlined,
            page: AppPage.generateReports,
          ),
        ],
        currentPage: AppPage.adminMaintenance,
      ),
    );
  }
}

class AdminMaintenanceResidentLogScreen extends StatefulWidget {
  const AdminMaintenanceResidentLogScreen({super.key});

  @override
  State<AdminMaintenanceResidentLogScreen> createState() =>
      _AdminMaintenanceResidentLogScreenState();
}

class _AdminMaintenanceResidentLogScreenState
    extends State<AdminMaintenanceResidentLogScreen> {
  final AvenueRepository _repository = AvenueRepository();
  final TextEditingController _searchController = TextEditingController();
  String _statusFilter = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Resident Log',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          AvenueIconButton(
            icon: Icons.search_rounded,
            onPressed: () => setState(() {}),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _repository.fetchAdminMaintenanceResidentLog(),
        builder: (context, snapshot) {
          final allRows = snapshot.data ?? const <Map<String, dynamic>>[];
          final query = _searchController.text.trim().toLowerCase();
          final rows = allRows.where((row) {
            final status = _status(row);
            if (_statusFilter != 'all' && status != _statusFilter) {
              return false;
            }
            if (query.isEmpty) {
              return true;
            }
            final name = row['resident_name']?.toString().toLowerCase() ?? '';
            final unit = row['unit_number']?.toString().toLowerCase() ?? '';
            return name.contains(query) || unit.contains(query);
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search by name or flat number...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: AvenueColors.surfaceHigh,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    _FilterPill(
                      label: 'All',
                      selected: _statusFilter == 'all',
                      onTap: () => setState(() => _statusFilter = 'all'),
                    ),
                    _FilterPill(
                      label: 'Paid',
                      selected: _statusFilter == 'paid',
                      onTap: () => setState(() => _statusFilter = 'paid'),
                    ),
                    _FilterPill(
                      label: 'Pending',
                      selected: _statusFilter == 'pending',
                      onTap: () => setState(() => _statusFilter = 'pending'),
                    ),
                    _FilterPill(
                      label: 'Overdue',
                      selected: _statusFilter == 'overdue',
                      onTap: () => setState(() => _statusFilter = 'overdue'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (snapshot.connectionState != ConnectionState.done &&
                    allRows.isEmpty)
                  const AvenueCard(
                    radius: 16,
                    child: AvenueSkeletonBlock(height: 140, radius: 14),
                  )
                else if (rows.isEmpty)
                  const AvenueCard(
                    radius: 16,
                    child: Text('No residents found for this filter.'),
                  )
                else
                  ...rows.map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: AvenueCard(
                        radius: 16,
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          onTap: () => Navigator.of(context).pushNamed(
                            AppPage.adminMaintenanceResidentDetail.routeName,
                            arguments: {'resident': row},
                          ),
                          leading: CircleAvatar(
                            backgroundColor: AvenueColors.surfaceLow,
                            child: Text(
                              _initials(
                                row['resident_name']?.toString() ?? 'R',
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AvenueColors.primary,
                              ),
                            ),
                          ),
                          title: Text(
                            row['resident_name']?.toString() ?? '-',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text(
                            '${row['unit_number'] ?? '-'} • Due ${_date(row['due_date'])}',
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _money(_maintenanceDisplayAmount(row)),
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              _TinyStatusChip(label: _status(row)),
                            ],
                          ),
                        ),
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

class AdminMaintenanceResidentDetailScreen extends StatefulWidget {
  const AdminMaintenanceResidentDetailScreen({
    super.key,
    required this.resident,
  });

  final Map<String, dynamic> resident;

  @override
  State<AdminMaintenanceResidentDetailScreen> createState() =>
      _AdminMaintenanceResidentDetailScreenState();
}

class _AdminMaintenanceResidentDetailScreenState
    extends State<AdminMaintenanceResidentDetailScreen> {
  final AvenueRepository _repository = AvenueRepository();
  bool _isMarkingPaid = false;

  @override
  Widget build(BuildContext context) {
    final userId = widget.resident['user_id']?.toString() ?? '';

    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Resident Detail',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: const [SizedBox(width: 12)],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          _repository.fetchMaintenanceBillsForResident(userId),
          _repository.fetchMaintenancePaymentHistoryForResident(userId),
        ]),
        builder: (context, snapshot) {
          final bills = snapshot.hasData
              ? List<Map<String, dynamic>>.from(snapshot.data![0] as List)
              : const <Map<String, dynamic>>[];
          final history = snapshot.hasData
              ? List<Map<String, dynamic>>.from(snapshot.data![1] as List)
              : const <Map<String, dynamic>>[];
          final activeBill =
              bills.where((row) => _status(row) != 'paid').isNotEmpty
              ? bills.firstWhere((row) => _status(row) != 'paid')
              : (bills.isNotEmpty ? bills.first : null);

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvenueCard(
                  radius: 24,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AvenueColors.surfaceLow,
                        child: Text(
                          _initials(
                            widget.resident['resident_name']?.toString() ?? 'R',
                          ),
                          style: const TextStyle(
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
                              widget.resident['resident_name']?.toString() ??
                                  'Resident',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.resident['unit_number'] ?? '-'} • ${widget.resident['tower'] ?? ''}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AvenueColors.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      _TinyStatusChip(
                        label: activeBill == null
                            ? 'paid'
                            : _status(activeBill),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (activeBill != null)
                  AvenueCard(
                    radius: 24,
                    color: AvenueColors.surfaceLow,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _monthYear(activeBill['due_date']),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        _InfoRow(
                          label: 'Due Amount',
                          value: _money(activeBill['amount_due']),
                        ),
                        _InfoRow(
                          label: 'Due Date',
                          value: _date(activeBill['due_date']),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: AvenuePrimaryButton(
                                label: _isMarkingPaid
                                    ? 'Marking...'
                                    : 'Mark Paid',
                                onPressed: _isMarkingPaid
                                    ? () {}
                                    : () => _markPaid(activeBill),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AvenueSecondaryButton(
                                label: 'Send Alert',
                                onPressed: () =>
                                    Navigator.of(context).pushNamed(
                                      AppPage
                                          .adminMaintenanceForcedAlert
                                          .routeName,
                                      arguments: {
                                        'preselectedResidentIds': [userId],
                                      },
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 14),
                Text(
                  'Payment History',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                if (snapshot.connectionState != ConnectionState.done &&
                    bills.isEmpty)
                  const AvenueCard(
                    radius: 16,
                    child: AvenueSkeletonBlock(height: 120, radius: 14),
                  )
                else if (history.isEmpty)
                  const AvenueCard(
                    radius: 16,
                    child: Text('No payment history yet.'),
                  )
                else
                  ...history
                      .take(6)
                      .map(
                        (row) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: AvenueCard(
                            radius: 16,
                            child: _InfoRow(
                              label:
                                  '${row['activity_title'] ?? 'Maintenance Payment'} • ${_date(row['activity_at'])}',
                              value: _money(row['amount']),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 10),
                AvenueSecondaryButton(
                  label: 'Open Secure Payment',
                  icon: Icons.lock_outline_rounded,
                  onPressed: () => Navigator.of(
                    context,
                  ).pushNamed(AppPage.adminMaintenanceSecurePayment.routeName),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _markPaid(Map<String, dynamic> bill) async {
    final billId = bill['id']?.toString();
    if (billId == null) {
      return;
    }
    setState(() => _isMarkingPaid = true);
    try {
      final response = await _repository.adminMarkMaintenancePaid(
        billId: billId,
        note: 'Marked paid from admin maintenance detail.',
      );
      if (!mounted) {
        return;
      }
      if (response == null) {
        await showAvenueDialogMessage(
          context,
          type: AvenueMessageType.error,
          message: 'Could not mark this bill as paid right now.',
        );
        return;
      }
      await showAvenueDialogMessage(
        context,
        type: AvenueMessageType.success,
        message: 'Maintenance payment marked as paid.',
      );
      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      await showAvenueDialogMessage(
        context,
        type: AvenueMessageType.error,
        message: error.toString(),
      );
    } finally {
      if (mounted) {
        setState(() => _isMarkingPaid = false);
      }
    }
  }
}

class AdminMaintenanceForcedAlertScreen extends StatefulWidget {
  const AdminMaintenanceForcedAlertScreen({
    super.key,
    this.preselectedResidentIds = const [],
  });

  final List<String> preselectedResidentIds;

  @override
  State<AdminMaintenanceForcedAlertScreen> createState() =>
      _AdminMaintenanceForcedAlertScreenState();
}

class _AdminMaintenanceForcedAlertScreenState
    extends State<AdminMaintenanceForcedAlertScreen> {
  final AvenueRepository _repository = AvenueRepository();
  final TextEditingController _messageController = TextEditingController(
    text:
        'Hi [Resident Name], your maintenance of ₹[Amount] for [Month] is due on [Due Date]. Please complete payment from the Cove app.',
  );
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedResidentIds = <String>{};
  Set<String> _eligibleResidentIds = <String>{};
  String _searchMode = 'name';
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _selectedResidentIds.addAll(widget.preselectedResidentIds);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Send Alert',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: const [SizedBox(width: 12)],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _repository.fetchAdminMaintenanceResidentLog(),
        builder: (context, snapshot) {
          final allRows = snapshot.data ?? const <Map<String, dynamic>>[];
          final rows = _latestMaintenanceRowsForAlert(allRows);
          final query = _searchController.text.trim().toLowerCase();
          final visibleRows = rows.where((row) {
            if (query.isEmpty) {
              return true;
            }
            return _matchesResidentAlertQuery(
              row,
              query,
              searchMode: _searchMode,
            );
          }).toList();
          _eligibleResidentIds = rows
              .map((row) => row['user_id']?.toString() ?? '')
              .where((userId) => userId.isNotEmpty)
              .toSet();
          final effectiveSelectedResidentIds = _selectedResidentIds
              .intersection(_eligibleResidentIds);

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _messageController,
                  minLines: 5,
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText: 'Enter alert message...',
                    filled: true,
                    fillColor: AvenueColors.surfaceHigh,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Add residents',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: _searchMode == 'name'
                        ? 'Search name...'
                        : 'Search flat number...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: query.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.close_rounded),
                          ),
                    filled: true,
                    fillColor: AvenueColors.surfaceHigh,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('By Name'),
                      selected: _searchMode == 'name',
                      onSelected: (_) => setState(() => _searchMode = 'name'),
                    ),
                    ChoiceChip(
                      label: const Text('By Flat Number'),
                      selected: _searchMode == 'unit',
                      onSelected: (_) => setState(() => _searchMode = 'unit'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (snapshot.connectionState != ConnectionState.done &&
                    rows.isEmpty)
                  const AvenueCard(
                    radius: 16,
                    child: AvenueSkeletonBlock(height: 120, radius: 14),
                  )
                else if (rows.isEmpty)
                  const AvenueCard(
                    radius: 16,
                    child: Text(
                      'No residents have an unpaid latest maintenance bill.',
                    ),
                  )
                else if (visibleRows.isEmpty)
                  AvenueCard(
                    radius: 16,
                    child: Text(
                      query.isEmpty
                          ? 'Search residents by name or flat number.'
                          : 'No matching unpaid residents found.',
                    ),
                  )
                else
                  ...visibleRows.map((row) {
                    final userId = row['user_id']?.toString() ?? '';
                    final selected = effectiveSelectedResidentIds.contains(
                      userId,
                    );
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: AvenueCard(
                        radius: 14,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (selected) {
                                _selectedResidentIds.remove(userId);
                              } else {
                                _selectedResidentIds.add(userId);
                              }
                            });
                          },
                          child: Row(
                            children: [
                              Checkbox(
                                value: selected,
                                onChanged: (_) {
                                  setState(() {
                                    if (selected) {
                                      _selectedResidentIds.remove(userId);
                                    } else {
                                      _selectedResidentIds.add(userId);
                                    }
                                  });
                                },
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${row['resident_name']} • ${row['unit_number']}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Latest due ${_date(row['due_date'])} • ${_status(row)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color:
                                                AvenueColors.onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(_money(row['amount_due'])),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 14),
                AvenuePrimaryButton(
                  label: _isSending
                      ? 'Sending...'
                      : 'Send Alert to ${effectiveSelectedResidentIds.length} Residents',
                  icon: Icons.send_rounded,
                  onPressed: _isSending ? () {} : _sendAlerts,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _sendAlerts() async {
    final residentUserIds = _selectedResidentIds
        .where(_eligibleResidentIds.contains)
        .toList(growable: false);

    if (residentUserIds.isEmpty) {
      await showAvenueDialogMessage(
        context,
        type: AvenueMessageType.error,
        message: 'Select at least one resident.',
      );
      return;
    }

    setState(() => _isSending = true);
    try {
      final response = await _repository.sendMaintenanceAlerts(
        residentUserIds: residentUserIds,
        messageTemplate: _messageController.text.trim(),
        channels: const ['push', 'email'],
      );
      if (!mounted) {
        return;
      }
      if (response == null) {
        await showAvenueDialogMessage(
          context,
          type: AvenueMessageType.error,
          message: 'Could not send alerts right now.',
        );
        return;
      }
      await showAvenueDialogMessage(
        context,
        type: AvenueMessageType.success,
        message:
            'Alerts sent to ${response['alerted_count'] ?? residentUserIds.length} residents.',
      );
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      await showAvenueDialogMessage(
        context,
        type: AvenueMessageType.error,
        message: error.toString(),
      );
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }
}

List<Map<String, dynamic>> _latestMaintenanceRowsForAlert(
  List<Map<String, dynamic>> rows,
) {
  final latestByResident = <String, Map<String, dynamic>>{};

  for (final row in rows) {
    final userId = row['user_id']?.toString() ?? '';
    if (userId.isEmpty) {
      continue;
    }

    final existing = latestByResident[userId];
    if (existing == null || _isMoreRecentMaintenanceRow(row, existing)) {
      latestByResident[userId] = row;
    }
  }

  final latestRows = latestByResident.values
      .where((row) => _status(row) != 'paid')
      .toList(growable: false);
  latestRows.sort((left, right) {
    final leftName = left['resident_name']?.toString().toLowerCase() ?? '';
    final rightName = right['resident_name']?.toString().toLowerCase() ?? '';
    return leftName.compareTo(rightName);
  });
  return latestRows;
}

bool _isMoreRecentMaintenanceRow(
  Map<String, dynamic> candidate,
  Map<String, dynamic> current,
) {
  final candidateDue = DateTime.tryParse(candidate['due_date']?.toString() ?? '');
  final currentDue = DateTime.tryParse(current['due_date']?.toString() ?? '');

  if (candidateDue != null && currentDue != null && candidateDue != currentDue) {
    return candidateDue.isAfter(currentDue);
  }
  if (candidateDue != null && currentDue == null) {
    return true;
  }
  if (candidateDue == null && currentDue != null) {
    return false;
  }

  final candidateCreated = DateTime.tryParse(
    candidate['created_at']?.toString() ?? '',
  );
  final currentCreated = DateTime.tryParse(current['created_at']?.toString() ?? '');

  if (candidateCreated != null && currentCreated != null) {
    return candidateCreated.isAfter(currentCreated);
  }
  if (candidateCreated != null && currentCreated == null) {
    return true;
  }

  return false;
}

bool _matchesResidentAlertQuery(
  Map<String, dynamic> row,
  String query, {
  required String searchMode,
}) {
  final residentName = row['resident_name']?.toString().toLowerCase() ?? '';
  final unitNumber = row['unit_number']?.toString().toLowerCase() ?? '';

  if (searchMode == 'unit') {
    return unitNumber.contains(query);
  }

  return residentName.contains(query);
}

class AdminMaintenanceNotificationSettingsScreen extends StatefulWidget {
  const AdminMaintenanceNotificationSettingsScreen({super.key});

  @override
  State<AdminMaintenanceNotificationSettingsScreen> createState() =>
      _AdminMaintenanceNotificationSettingsScreenState();
}

class _AdminMaintenanceNotificationSettingsScreenState
    extends State<AdminMaintenanceNotificationSettingsScreen> {
  final AvenueRepository _repository = AvenueRepository();
  final TextEditingController _templateController = TextEditingController();
  bool _hasHydratedSettings = false;

  bool _beforeDueEnabled = true;
  int _beforeDueDays = 5;
  bool _onDueEnabled = true;
  bool _followUpEnabled = true;
  bool _weeklyOverdueEnabled = true;
  bool _pushEnabled = true;
  bool _emailEnabled = true;
  bool _smsEnabled = false;
  bool _isSaving = false;
  String _followUpFrequency = 'weekly';

  @override
  void dispose() {
    _templateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Notification Settings',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: const [SizedBox(width: 12)],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _repository.fetchAdminMaintenanceNotificationSettings(),
        builder: (context, snapshot) {
          if (!_hasHydratedSettings &&
              snapshot.hasData &&
              snapshot.data != null) {
            _hydrateFromSettingsRow(snapshot.data!);
          } else if (!_hasHydratedSettings &&
              _templateController.text.trim().isEmpty) {
            _templateController.text =
                'Hi [Resident Name], your maintenance of ₹[Amount] for [Month] is due on [Due Date]. Please pay from the Cove app.';
            _hasHydratedSettings = true;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ToggleTile(
                  label: 'Before Due Date Reminder',
                  value: _beforeDueEnabled,
                  onChanged: (value) =>
                      setState(() => _beforeDueEnabled = value),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Before due (days):',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => setState(() {
                        _beforeDueDays = (_beforeDueDays - 1).clamp(1, 30);
                      }),
                      icon: const Icon(Icons.remove_circle_outline_rounded),
                    ),
                    Text(
                      '$_beforeDueDays',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() {
                        _beforeDueDays = (_beforeDueDays + 1).clamp(1, 30);
                      }),
                      icon: const Icon(Icons.add_circle_outline_rounded),
                    ),
                  ],
                ),
                _ToggleTile(
                  label: 'On Due Date Reminder',
                  value: _onDueEnabled,
                  onChanged: (value) => setState(() => _onDueEnabled = value),
                ),
                _ToggleTile(
                  label: 'After Due Follow-up',
                  value: _followUpEnabled,
                  onChanged: (value) =>
                      setState(() => _followUpEnabled = value),
                ),
                _ToggleTile(
                  label: 'Weekly Overdue Reminder',
                  value: _weeklyOverdueEnabled,
                  onChanged: (value) =>
                      setState(() => _weeklyOverdueEnabled = value),
                ),
                const SizedBox(height: 12),
                Text(
                  'Delivery Channels',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _SwitchChip(
                      label: 'Push',
                      enabled: _pushEnabled,
                      onTap: () => setState(() => _pushEnabled = !_pushEnabled),
                    ),
                    _SwitchChip(
                      label: 'Email',
                      enabled: _emailEnabled,
                      onTap: () =>
                          setState(() => _emailEnabled = !_emailEnabled),
                    ),
                    _SwitchChip(
                      label: 'SMS',
                      enabled: _smsEnabled,
                      onTap: () => setState(() => _smsEnabled = !_smsEnabled),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Template Preview',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _templateController,
                  minLines: 5,
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText:
                        'Template with [Resident Name], [Amount], [Month]',
                    filled: true,
                    fillColor: AvenueColors.surfaceHigh,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                AvenuePrimaryButton(
                  label: _isSaving ? 'Saving...' : 'Save Settings',
                  onPressed: _isSaving ? () {} : _save,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final response = await _repository
          .saveAdminMaintenanceNotificationSettings(
            beforeDueEnabled: _beforeDueEnabled,
            beforeDueDays: _beforeDueDays,
            onDueEnabled: _onDueEnabled,
            followUpEnabled: _followUpEnabled,
            followUpFrequency: _followUpFrequency,
            weeklyOverdueEnabled: _weeklyOverdueEnabled,
            channelPushEnabled: _pushEnabled,
            channelEmailEnabled: _emailEnabled,
            channelSmsEnabled: _smsEnabled,
            templateBody: _templateController.text.trim(),
          );
      if (!mounted) {
        return;
      }
      if (response == null) {
        await showAvenueDialogMessage(
          context,
          type: AvenueMessageType.error,
          message: 'Could not save notification settings right now.',
        );
        return;
      }
      await showAvenueDialogMessage(
        context,
        type: AvenueMessageType.success,
        message: 'Notification settings saved.',
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      await showAvenueDialogMessage(
        context,
        type: AvenueMessageType.error,
        message: error.toString(),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _hydrateFromSettingsRow(Map<String, dynamic> row) {
    _beforeDueEnabled = row['before_due_enabled'] == true;
    _beforeDueDays = (row['before_due_days'] as int?) ?? 5;
    _onDueEnabled = row['on_due_enabled'] == true;
    _followUpEnabled = row['follow_up_enabled'] == true;
    _weeklyOverdueEnabled = row['weekly_overdue_enabled'] == true;
    _pushEnabled = row['channel_push_enabled'] == true;
    _emailEnabled = row['channel_email_enabled'] == true;
    _smsEnabled = row['channel_sms_enabled'] == true;
    _followUpFrequency = row['follow_up_frequency']?.toString() ?? 'weekly';
    if (_templateController.text.trim().isEmpty) {
      _templateController.text =
          row['template_body']?.toString() ??
          'Hi [Resident Name], your maintenance of ₹[Amount] for [Month] is due on [Due Date].';
    }
    _hasHydratedSettings = true;
  }
}

class AdminMaintenanceExportOptionsScreen extends StatelessWidget {
  const AdminMaintenanceExportOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Export Options',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: const [SizedBox(width: 12)],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: repository.fetchAdminMaintenanceResidentLog(),
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          final csvRows = [
            'Resident,Unit,Bill Code,Amount,Due Date,Status',
            ...rows.map(
              (row) =>
                  '"${row['resident_name'] ?? ''}","${row['unit_number'] ?? ''}","${row['code'] ?? ''}","${_maintenanceDisplayAmount(row)}","${_date(row['due_date'])}","${_status(row)}"',
            ),
          ];
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
            child: AvenueCard(
              radius: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Export as CSV/PDF',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(label: 'Rows', value: '${rows.length}'),
                  const SizedBox(height: 14),
                  AvenuePrimaryButton(
                    label: 'Export CSV',
                    icon: Icons.table_chart_rounded,
                    onPressed: () => showAvenueDialogMessage(
                      context,
                      type: AvenueMessageType.success,
                      message:
                          'CSV prepared with ${rows.length} resident records.\n\nPreview:\n${csvRows.take(4).join('\n')}',
                    ),
                  ),
                  const SizedBox(height: 10),
                  AvenueSecondaryButton(
                    label: 'Export PDF',
                    icon: Icons.picture_as_pdf_rounded,
                    onPressed: () => showAvenueDialogMessage(
                      context,
                      type: AvenueMessageType.info,
                      message:
                          'PDF export template is ready. Connect your file service for download.',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AdminMaintenanceSecurePaymentScreen extends StatelessWidget {
  const AdminMaintenanceSecurePaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Secure Payment',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: const [SizedBox(width: 12)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AvenueCard(
              radius: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pay with UPI',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: const [
                      _BrandTile(label: 'GPay'),
                      _BrandTile(label: 'PhonePe'),
                      _BrandTile(label: 'Paytm'),
                      _BrandTile(label: 'BHIM'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AvenuePrimaryButton(
                    label: 'Proceed Securely',
                    icon: Icons.lock_rounded,
                    onPressed: () => showAvenueDialogMessage(
                      context,
                      type: AvenueMessageType.info,
                      message:
                          'Secure payment gateway can be linked to your PSP credentials.',
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

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.label,
    required this.value,
    required this.icon,
    this.color = AvenueColors.primary,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        width: 152,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AvenueColors.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: AvenueColors.primary),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _TinyStatusChip extends StatelessWidget {
  const _TinyStatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(label);
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
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
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AvenueColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? AvenueColors.primary
                : AvenueColors.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AvenueColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 16,
      color: AvenueColors.surfaceLow,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _SwitchChip extends StatelessWidget {
  const _SwitchChip({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: enabled
              ? AvenueColors.primary.withValues(alpha: 0.14)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: enabled
                ? AvenueColors.primary
                : AvenueColors.outlineVariant.withValues(alpha: 0.45),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: enabled
                ? AvenueColors.primary
                : AvenueColors.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _BrandTile extends StatelessWidget {
  const _BrandTile({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 14,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      color: AvenueColors.surfaceLow,
      child: Text(label),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AvenueColors.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

String _status(Map<String, dynamic> row) {
  final value = row['payment_status']?.toString().toLowerCase();
  if (value != null && value.isNotEmpty) {
    return value;
  }
  final state = row['state']?.toString().toLowerCase() ?? 'due';
  final due = DateTime.tryParse(row['due_date']?.toString() ?? '');
  if (state == 'paid') {
    return 'paid';
  }
  if (due != null && due.isBefore(DateTime.now())) {
    return 'overdue';
  }
  return 'pending';
}

Color _statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'paid':
      return const Color(0xFF1F8E5A);
    case 'overdue':
      return const Color(0xFFD33B2C);
    default:
      return const Color(0xFF946200);
  }
}

String _money(dynamic value) {
  final parsed = _toDouble(value);
  final rounded = parsed == parsed.roundToDouble()
      ? parsed.toStringAsFixed(0)
      : parsed.toStringAsFixed(2);
  return '₹$rounded';
}

dynamic _maintenanceDisplayAmount(Map<String, dynamic> row) {
  if (_status(row) == 'paid') {
    return row['amount_paid'] ?? row['amount_due'];
  }
  return row['amount_due'];
}

double _toDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

String _date(dynamic value) {
  final parsed = DateTime.tryParse(value?.toString() ?? '');
  if (parsed == null) {
    return '-';
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
  return '${local.day.toString().padLeft(2, '0')} ${months[local.month - 1]} ${local.year}';
}

String _monthYear(dynamic value) {
  final parsed = DateTime.tryParse(value?.toString() ?? '');
  if (parsed == null) {
    return 'Current Cycle';
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
  return '${months[local.month - 1]} ${local.year}';
}

String _initials(String name) {
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
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}
