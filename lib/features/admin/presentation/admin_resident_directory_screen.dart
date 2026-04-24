part of 'admin_screens.dart';

class ResidentDirectoryScreen extends StatefulWidget {
  const ResidentDirectoryScreen({super.key});

  @override
  State<ResidentDirectoryScreen> createState() =>
      _ResidentDirectoryScreenState();
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
              .where(
                (row) => _normalize(row['status']?.toString() ?? '') == 'active',
              )
              .length;
          final pendingCount = rows
              .where(
                (row) =>
                    _normalize(row['status']?.toString() ?? '') == 'pending',
              )
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
