part of 'admin_screens.dart';

class AdminComplaintsScreen extends StatefulWidget {
  const AdminComplaintsScreen({super.key});

  @override
  State<AdminComplaintsScreen> createState() => _AdminComplaintsScreenState();
}

class _AdminComplaintsScreenState extends State<AdminComplaintsScreen> {
  final AvenueRepository _repository = AvenueRepository();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _complaintsFuture;

  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _complaintsFuture = _repository.fetchAdminComplaints();
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
      currentPage: AppPage.adminComplaints,
      topBar: _AdminTopBar(
        title: 'Complaints',
        leadingIcon: Icons.menu_rounded,
        onLeadingTap: () => _openAdminMenu(context, AppPage.adminComplaints),
        trailing: IconButton(
          onPressed: _refresh,
          icon: const Icon(Icons.refresh_rounded),
          color: AvenueColors.primary,
        ),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _complaintsFuture,
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          final filtered = rows.where(_matchesComplaintFilter).toList();
          final pendingCount = rows.where((row) {
            final state = _normalize(row['state']?.toString() ?? '');
            return state == 'pending' || state == 'in_progress';
          }).length;
          final resolvedCount = rows.where((row) {
            return _normalize(row['state']?.toString() ?? '') == 'resolved';
          }).length;

          return _AdminBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AdminSearchBar(
                  controller: _searchController,
                  hintText: 'Search complaints by resident, unit, or title...',
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
                        label: 'Pending',
                        selected: _selectedFilter == 'pending',
                        onTap: () =>
                            setState(() => _selectedFilter = 'pending'),
                      ),
                      const SizedBox(width: 8),
                      _ResidentFilterChip(
                        label: 'In Progress',
                        selected: _selectedFilter == 'in_progress',
                        onTap: () =>
                            setState(() => _selectedFilter = 'in_progress'),
                      ),
                      const SizedBox(width: 8),
                      _ResidentFilterChip(
                        label: 'Resolved',
                        selected: _selectedFilter == 'resolved',
                        onTap: () =>
                            setState(() => _selectedFilter = 'resolved'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _ResidentInsightTile(
                        label: 'Open Issues',
                        value: pendingCount.toString(),
                        icon: Icons.report_problem_rounded,
                        tint: const Color(0xFFFFE9E6),
                        iconColor: _AdminPalette.danger,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ResidentInsightTile(
                        label: 'Resolved',
                        value: resolvedCount.toString(),
                        icon: Icons.verified_rounded,
                        tint: const Color(0xFFE7F6EE),
                        iconColor: _AdminPalette.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _AdminSectionHeading(title: 'Resident Complaints'),
                const SizedBox(height: 6),
                Text(
                  '${filtered.length} complaint${filtered.length == 1 ? '' : 's'} visible',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: _AdminPalette.muted),
                ),
                const SizedBox(height: 14),
                if (snapshot.connectionState != ConnectionState.done &&
                    rows.isEmpty)
                  const _AdminEmptyState(label: 'Loading complaints...')
                else if (filtered.isEmpty)
                  const _AdminEmptyState(
                    label: 'No complaints match the current search or filter.',
                  )
                else
                  ...filtered.map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _AdminComplaintCard(
                        row: row,
                        onManage: () => _openComplaintDetail(row),
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

  void _refresh() {
    setState(() {
      _complaintsFuture = _repository.fetchAdminComplaints();
    });
  }

  bool _matchesComplaintFilter(Map<String, dynamic> row) {
    final search = _normalize(_searchController.text);
    final state = _normalize(row['state']?.toString() ?? '');
    final haystack = _normalize(
      '${row['title'] ?? ''} ${row['description'] ?? ''} ${row['category'] ?? ''} ${row['urgency'] ?? ''} ${row['location_label'] ?? ''} ${row['resident_name'] ?? ''} ${row['unit_number'] ?? ''} ${row['code'] ?? ''}',
    );

    final matchesSearch = search.isEmpty || haystack.contains(search);
    final matchesFilter = _selectedFilter == 'all' || state == _selectedFilter;

    return matchesSearch && matchesFilter;
  }

  Future<void> _openComplaintDetail(Map<String, dynamic> row) async {
    final updated = await Navigator.of(context).pushNamed(
      AppPage.adminComplaintDetail.routeName,
      arguments: {'complaint': row},
    );

    if (updated == true && mounted) {
      _refresh();
    }
  }
}

class AdminComplaintDetailScreen extends StatefulWidget {
  const AdminComplaintDetailScreen({required this.row, super.key});

  final Map<String, dynamic> row;

  @override
  State<AdminComplaintDetailScreen> createState() =>
      _AdminComplaintDetailScreenState();
}

class _AdminComplaintDetailScreenState
    extends State<AdminComplaintDetailScreen> {
  final AvenueRepository _repository = AvenueRepository();
  late final TextEditingController _noteController;

  bool _isSubmitting = false;

  Map<String, dynamic> get row => widget.row;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(
      text: row['admin_notes']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit(String state) async {
    if (_isSubmitting) {
      return;
    }

    final complaintId = row['id']?.toString();
    if (complaintId == null || complaintId.isEmpty) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    Map<String, dynamic>? result;
    try {
      result = await _repository.updateAdminComplaintStatus(
        complaintId: complaintId,
        state: state,
        adminNotes: _noteController.text,
        resolutionNote: state == 'resolved' ? _noteController.text : null,
      );
    } catch (_) {
      result = null;
    }

    if (!mounted) {
      return;
    }

    if (result == null) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not update this complaint right now.'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Complaint ${result['code']} updated.')),
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final state = row['state']?.toString() ?? 'pending';
    final stateColor = _complaintStateColor(state);

    return _AdminScaffold(
      currentPage: AppPage.adminComplaints,
      topBar: _AdminTopBar(
        title: 'Complaint Details',
        leadingIcon: Icons.arrow_back_rounded,
        onLeadingTap: () => Navigator.of(context).pop(),
      ),
      child: _AdminBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _AdminTag(
              label: 'SERVICE DESK',
              background: Color(0x1A005BBF),
              foreground: AvenueColors.primary,
            ),
            const SizedBox(height: 14),
            Text(
              row['title'] as String? ?? 'Complaint',
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(fontSize: 30, height: 1.08),
            ),
            const SizedBox(height: 8),
            Text(
              '${row['code'] ?? '--'} • ${row['resident_name'] ?? 'Resident'} • Unit ${row['unit_number'] ?? '--'}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: _AdminPalette.muted,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),
            _AdminGlassCard(
              radius: 28,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: stateColor.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _complaintIcon(row['icon_name']?.toString()),
                          color: stateColor,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          row['description'] as String? ?? '',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: _AdminPalette.muted,
                                height: 1.5,
                              ),
                        ),
                      ),
                      _AdminTag(
                        label: _complaintStateLabel(state).toUpperCase(),
                        background: stateColor.withValues(alpha: 0.14),
                        foreground: stateColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _AdminMiniInfo(
                        icon: Icons.category_outlined,
                        label: _complaintCategoryLabel(
                          row['category']?.toString(),
                        ),
                      ),
                      _AdminMiniInfo(
                        icon: Icons.priority_high_rounded,
                        label: _complaintUrgencyLabel(
                          row['urgency']?.toString(),
                        ),
                      ),
                      _AdminMiniInfo(
                        icon: Icons.location_on_outlined,
                        label: _adminOptionalText(row['location_label']),
                      ),
                      _AdminMiniInfo(
                        icon: Icons.schedule_rounded,
                        label: _adminOptionalText(row['preferred_access_time']),
                      ),
                      if ((row['photo_url'] as String?)?.isNotEmpty ?? false)
                        const _AdminMiniInfo(
                          icon: Icons.photo_outlined,
                          label: 'Photo attached',
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _AdminGlassCard(
              radius: 28,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _AdminSectionLabel(text: 'ADMIN ACTION'),
                  const SizedBox(height: 12),
                  Text(
                    'NOTE',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _AdminPalette.muted,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteController,
                    maxLines: 4,
                    decoration: _adminComplaintInputDecoration(
                      context,
                      'Add the update residents should see',
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isSubmitting
                              ? null
                              : () => _submit('in_progress'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(_isSubmitting ? 'Saving...' : 'Start'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: _isSubmitting
                              ? null
                              : () => _submit('resolved'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('Resolve'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const _AdminInfoBanner(
              icon: Icons.notifications_active_rounded,
              title: 'RESIDENT NOTIFICATION',
              body:
                  'Every status update sends a notification to the resident and refreshes their complaint timeline.',
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminComplaintCard extends StatelessWidget {
  const _AdminComplaintCard({required this.row, required this.onManage});

  final Map<String, dynamic> row;
  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    final state = row['state']?.toString() ?? 'pending';
    final stateColor = _complaintStateColor(state);

    return _AdminGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: stateColor.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _complaintIcon(row['icon_name']?.toString()),
                    color: stateColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        row['title'] as String? ?? 'Complaint',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${row['code'] ?? '--'} • ${_timeAgoLabel(row['created_at'])}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _AdminPalette.muted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                _AdminTag(
                  label: _complaintStateLabel(state).toUpperCase(),
                  background: stateColor.withValues(alpha: 0.14),
                  foreground: stateColor,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              row['description'] as String? ?? '',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _AdminPalette.muted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _AdminMiniInfo(
                  icon: Icons.person_outline_rounded,
                  label: row['resident_name'] as String? ?? 'Resident',
                ),
                _AdminMiniInfo(
                  icon: Icons.home_work_outlined,
                  label: 'Unit ${row['unit_number'] ?? '--'}',
                ),
                _AdminMiniInfo(
                  icon: Icons.engineering_outlined,
                  label: row['assigned_to'] as String? ?? 'Unassigned',
                ),
                _AdminMiniInfo(
                  icon: Icons.category_outlined,
                  label: _complaintCategoryLabel(row['category']?.toString()),
                ),
                _AdminMiniInfo(
                  icon: Icons.priority_high_rounded,
                  label: _complaintUrgencyLabel(row['urgency']?.toString()),
                ),
                if ((row['location_label'] as String?)?.isNotEmpty ?? false)
                  _AdminMiniInfo(
                    icon: Icons.location_on_outlined,
                    label: row['location_label'] as String,
                  ),
                if ((row['preferred_access_time'] as String?)?.isNotEmpty ??
                    false)
                  _AdminMiniInfo(
                    icon: Icons.schedule_rounded,
                    label: row['preferred_access_time'] as String,
                  ),
                if ((row['photo_url'] as String?)?.isNotEmpty ?? false)
                  const _AdminMiniInfo(
                    icon: Icons.photo_outlined,
                    label: 'Photo attached',
                  ),
              ],
            ),
            if ((row['admin_notes'] as String?)?.isNotEmpty ?? false) ...[
              const SizedBox(height: 12),
              _AdminComplaintNote(
                title: 'Admin note',
                body: row['admin_notes'] as String,
              ),
            ],
            if ((row['resolution_note'] as String?)?.isNotEmpty ?? false) ...[
              const SizedBox(height: 12),
              _AdminComplaintNote(
                title: 'Resolution',
                body: row['resolution_note'] as String,
              ),
            ],
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: onManage,
                icon: const Icon(Icons.tune_rounded, size: 18),
                label: const Text('Manage'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminComplaintNote extends StatelessWidget {
  const _AdminComplaintNote({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _AdminPalette.surfaceLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _AdminPalette.muted,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: _AdminPalette.muted,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

Color _complaintStateColor(String state) {
  switch (_normalize(state)) {
    case 'resolved':
      return _AdminPalette.success;
    case 'in_progress':
      return AvenueColors.primary;
    default:
      return _AdminPalette.danger;
  }
}

String _complaintStateLabel(String state) {
  switch (_normalize(state)) {
    case 'in_progress':
      return 'In Progress';
    case 'resolved':
      return 'Resolved';
    default:
      return 'Pending';
  }
}

String _complaintCategoryLabel(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Other';
  }

  return value
      .split('_')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}

String _complaintUrgencyLabel(String? value) {
  switch (_normalize(value ?? '')) {
    case 'urgent':
      return 'Urgent';
    case 'low':
      return 'Low';
    default:
      return 'Normal';
  }
}

String _adminOptionalText(Object? value) {
  final text = value?.toString().trim() ?? '';
  return text.isEmpty ? 'Not specified' : text;
}

IconData _complaintIcon(String? iconName) {
  switch (_normalize(iconName ?? '')) {
    case 'water_drop':
      return Icons.water_drop_rounded;
    case 'plumbing':
      return Icons.plumbing_rounded;
    case 'electrical_services':
      return Icons.electrical_services_rounded;
    case 'cleaning_services':
      return Icons.cleaning_services_rounded;
    case 'security':
      return Icons.security_rounded;
    case 'elevator':
      return Icons.elevator_rounded;
    case 'local_parking':
      return Icons.local_parking_rounded;
    case 'campaign':
      return Icons.campaign_rounded;
    case 'pool':
      return Icons.pool_rounded;
    default:
      return Icons.report_problem_rounded;
  }
}

InputDecoration _adminComplaintInputDecoration(
  BuildContext context,
  String hintText,
) {
  return InputDecoration(
    filled: true,
    fillColor: _AdminPalette.surfaceLow,
    hintText: hintText,
    hintStyle: Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(color: _AdminPalette.muted),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  );
}
