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
                      child: _AdminComplaintCard(row: row),
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
      '${row['title'] ?? ''} ${row['description'] ?? ''} ${row['resident_name'] ?? ''} ${row['unit_number'] ?? ''} ${row['code'] ?? ''}',
    );

    final matchesSearch = search.isEmpty || haystack.contains(search);
    final matchesFilter = _selectedFilter == 'all' || state == _selectedFilter;

    return matchesSearch && matchesFilter;
  }
}

class _AdminComplaintCard extends StatelessWidget {
  const _AdminComplaintCard({required this.row});

  final Map<String, dynamic> row;

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
              ],
            ),
          ],
        ),
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

IconData _complaintIcon(String? iconName) {
  switch (_normalize(iconName ?? '')) {
    case 'plumbing':
      return Icons.plumbing_rounded;
    case 'electrical_services':
      return Icons.electrical_services_rounded;
    case 'cleaning_services':
      return Icons.cleaning_services_rounded;
    default:
      return Icons.report_problem_rounded;
  }
}
