part of 'admin_screens.dart';

class AdminCommunityScreen extends StatefulWidget {
  const AdminCommunityScreen({super.key});

  @override
  State<AdminCommunityScreen> createState() => _AdminCommunityScreenState();
}

class _AdminCommunityScreenState extends State<AdminCommunityScreen> {
  final AvenueRepository _repository = AvenueRepository();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _suggestionsFuture;
  final Set<String> _processingIds = <String>{};

  String _selectedFilter = 'review';

  @override
  void initState() {
    super.initState();
    _suggestionsFuture = _repository.fetchAdminCommunitySuggestions();
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
      currentPage: AppPage.adminCommunity,
      topBar: _AdminTopBar(
        title: 'Community',
        leadingIcon: Icons.menu_rounded,
        onLeadingTap: () => _openAdminMenu(context, AppPage.adminCommunity),
        trailing: IconButton(
          onPressed: _refresh,
          icon: const Icon(Icons.refresh_rounded),
          color: AvenueColors.primary,
        ),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _suggestionsFuture,
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          final filtered = rows.where(_matchesSuggestionFilter).toList();
          final votes = rows.fold<int>(
            0,
            (total, row) => total + ((row['total_votes'] as int?) ?? 0),
          );
          final reviewCount = rows
              .where(
                (row) =>
                    _normalize(row['status']?.toString() ?? '') == 'review',
              )
              .length;
          final publishedCount = rows.where((row) {
            final status = _normalize(row['status']?.toString() ?? '');
            return status == 'published' || status == 'active';
          }).length;

          return _AdminBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AdminSearchBar(
                  controller: _searchController,
                  hintText:
                      'Search community ideas by title, category, or author...',
                ),
                const SizedBox(height: 14),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _ResidentFilterChip(
                        label: 'In Review',
                        selected: _selectedFilter == 'review',
                        onTap: () => setState(() => _selectedFilter = 'review'),
                      ),
                      const SizedBox(width: 8),
                      _ResidentFilterChip(
                        label: 'Published',
                        selected: _selectedFilter == 'published',
                        onTap: () =>
                            setState(() => _selectedFilter = 'published'),
                      ),
                      const SizedBox(width: 8),
                      _ResidentFilterChip(
                        label: 'Rejected',
                        selected: _selectedFilter == 'rejected',
                        onTap: () =>
                            setState(() => _selectedFilter = 'rejected'),
                      ),
                      const SizedBox(width: 8),
                      _ResidentFilterChip(
                        label: 'All',
                        selected: _selectedFilter == 'all',
                        onTap: () => setState(() => _selectedFilter = 'all'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _ResidentInsightTile(
                        label: 'Awaiting Review',
                        value: reviewCount.toString(),
                        icon: Icons.lightbulb_rounded,
                        tint: const Color(0xFFFFF3D7),
                        iconColor: _AdminPalette.warning,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ResidentInsightTile(
                        label: 'Published',
                        value: publishedCount.toString(),
                        icon: Icons.publish_rounded,
                        tint: const Color(0xFFE7F6EE),
                        iconColor: _AdminPalette.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _ResidentInsightTile(
                  label: 'Resident Votes',
                  value: votes.toString(),
                  icon: Icons.how_to_vote_rounded,
                  tint: const Color(0xFFEAF2FF),
                  iconColor: AvenueColors.primary,
                ),
                const SizedBox(height: 24),
                _AdminSectionHeading(title: 'Community Suggestions'),
                const SizedBox(height: 6),
                Text(
                  '${filtered.length} suggestion${filtered.length == 1 ? '' : 's'} visible',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: _AdminPalette.muted),
                ),
                const SizedBox(height: 14),
                if (snapshot.connectionState != ConnectionState.done &&
                    rows.isEmpty)
                  const _AdminEmptyState(label: 'Loading community ideas...')
                else if (filtered.isEmpty)
                  const _AdminEmptyState(
                    label: 'No community suggestions match this search.',
                  )
                else
                  ...filtered.map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _AdminCommunitySuggestionCard(
                        row: row,
                        isProcessing: _processingIds.contains(
                          row['id']?.toString(),
                        ),
                        onPublish: () => _reviewSuggestion(row, 'published'),
                        onReject: () => _reviewSuggestion(row, 'rejected'),
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
      _suggestionsFuture = _repository.fetchAdminCommunitySuggestions();
    });
  }

  bool _matchesSuggestionFilter(Map<String, dynamic> row) {
    final search = _normalize(_searchController.text);
    final status = _normalize(row['status']?.toString() ?? '');
    final haystack = _normalize(
      '${row['title'] ?? ''} ${row['summary'] ?? ''} ${row['category'] ?? ''} ${row['author_name'] ?? ''}',
    );
    final matchesSearch = search.isEmpty || haystack.contains(search);
    final matchesFilter =
        _selectedFilter == 'all' ||
        status == _selectedFilter ||
        (_selectedFilter == 'published' && status == 'active');

    return matchesSearch && matchesFilter;
  }

  Future<void> _reviewSuggestion(
    Map<String, dynamic> row,
    String decision,
  ) async {
    final suggestionId = row['id']?.toString();
    if (suggestionId == null || _processingIds.contains(suggestionId)) {
      return;
    }

    setState(() {
      _processingIds.add(suggestionId);
    });

    try {
      final result = await _repository.reviewCommunitySuggestion(
        suggestionId: suggestionId,
        decision: decision,
      );

      if (!mounted) {
        return;
      }

      final status = result?['status']?.toString() ?? decision;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Suggestion marked as $status.')));
      _refresh();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not review this suggestion.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _processingIds.remove(suggestionId);
        });
      }
    }
  }
}

class _AdminCommunitySuggestionCard extends StatelessWidget {
  const _AdminCommunitySuggestionCard({
    required this.row,
    required this.isProcessing,
    required this.onPublish,
    required this.onReject,
  });

  final Map<String, dynamic> row;
  final bool isProcessing;
  final VoidCallback onPublish;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final progress = ((row['progress_percent'] as int?) ?? 0).clamp(0, 100);
    final support = ((row['support_percent'] as int?) ?? 0).clamp(0, 100);
    final status = _normalize(row['status']?.toString() ?? 'review');
    final isInReview = status == 'review';
    final statusColor = _communityStatusColor(status);

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
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF3D7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lightbulb_rounded,
                    color: _AdminPalette.warning,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        row['title'] as String? ?? 'Community suggestion',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${row['category'] ?? 'Community'} • ${row['author_name'] ?? 'Resident'}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _AdminPalette.muted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                _AdminTag(
                  label: _communityStatusLabel(status).toUpperCase(),
                  background: statusColor.withValues(alpha: 0.14),
                  foreground: statusColor,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              row['summary'] as String? ?? '',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _AdminPalette.muted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress / 100,
                minHeight: 8,
                backgroundColor: _AdminPalette.surfaceLow,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AvenueColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _AdminMiniInfo(
                  icon: Icons.how_to_vote_outlined,
                  label: '${row['total_votes'] ?? 0} votes',
                ),
                const SizedBox(width: 8),
                _AdminMiniInfo(
                  icon: Icons.thumb_up_alt_outlined,
                  label: '$support% support',
                ),
                const SizedBox(width: 8),
                _AdminMiniInfo(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: '${row['comment_count'] ?? 0} comments',
                ),
                const Spacer(),
                Text(
                  _timeAgoLabel(row['created_at']),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _AdminPalette.muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            if (isInReview) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AvenuePrimaryButton(
                      label: isProcessing ? 'Publishing...' : 'Publish',
                      icon: Icons.publish_rounded,
                      onPressed: isProcessing ? () {} : onPublish,
                      height: 46,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isProcessing ? null : onReject,
                      icon: const Icon(Icons.close_rounded),
                      label: const Text('Reject'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _AdminPalette.danger,
                        side: BorderSide(
                          color: _AdminPalette.danger.withValues(alpha: 0.34),
                        ),
                        minimumSize: const Size.fromHeight(46),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Color _communityStatusColor(String status) {
  switch (_normalize(status)) {
    case 'published':
    case 'active':
      return _AdminPalette.success;
    case 'rejected':
      return _AdminPalette.danger;
    default:
      return _AdminPalette.warning;
  }
}

String _communityStatusLabel(String status) {
  switch (_normalize(status)) {
    case 'published':
    case 'active':
      return 'Published';
    case 'rejected':
      return 'Rejected';
    default:
      return 'In Review';
  }
}
