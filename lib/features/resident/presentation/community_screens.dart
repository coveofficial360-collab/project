import 'package:flutter/material.dart';

import '../../../app/app_page.dart';
import '../../../core/session/app_session.dart';
import '../../../core/supabase/avenue_repository.dart';
import '../../../theme/avenue_theme.dart';
import '../../common/presentation/avenue_ui.dart';

const _communityFallbackImage =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBRVw79TfH1uKB3Z-BbU9buXnJoUSuSN1gANqlczHFukpEvx_MgfE05fVTRVYA4boAnRmUeaCcdjHq3ZD2dIWGRkSrmUpSI7XmMn7U9gcImkCOMDlaNhnJfxQBF0h8F0QCRg5dKfJN8xwZ-80g6jv15zwzML56sm-nAiqSaeLLtDAvvvatLtefyjsPYPvrItjbZzkgC7rg6yiiGn1XoO6YjsynIAnyxztuVS7nsSeBe775H3ZhSHWh3gdnpg_xGQNdiLX9C6PlgHA';

String _communityRelativeTime(dynamic value) {
  if (value == null) {
    return 'Just now';
  }

  final parsed = DateTime.tryParse(value.toString());
  if (parsed == null) {
    return value.toString();
  }

  final difference = DateTime.now().difference(parsed.toLocal());
  if (difference.inMinutes < 60) {
    return '${difference.inMinutes.clamp(1, 59)}m ago';
  }
  if (difference.inHours < 24) {
    return '${difference.inHours}h ago';
  }
  if (difference.inDays < 7) {
    return '${difference.inDays}d ago';
  }

  return _communityDateLabel(value);
}

String _communityDateLabel(dynamic value) {
  if (value == null) {
    return 'Today';
  }

  final parsed = DateTime.tryParse(value.toString());
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
  return '${months[local.month - 1]} ${local.day}, ${local.year}';
}

IconData _communityIconFor(String? iconName) {
  switch ((iconName ?? '').trim()) {
    case 'compost':
      return Icons.compost_rounded;
    case 'fitness_center':
      return Icons.fitness_center_rounded;
    case 'directions_bike':
      return Icons.directions_bike_rounded;
    case 'self_improvement':
      return Icons.self_improvement_rounded;
    case 'security':
      return Icons.gpp_good_rounded;
    case 'eco':
      return Icons.eco_rounded;
    case 'groups':
      return Icons.groups_rounded;
    default:
      return Icons.lightbulb_rounded;
  }
}

Color _hexColor(String? hex, {Color fallback = AvenueColors.primary}) {
  final cleaned = (hex ?? '').replaceAll('#', '').trim();
  if (cleaned.length != 6) {
    return fallback;
  }

  return Color(int.parse('FF$cleaned', radix: 16));
}

void _openCommunitySuggestion(BuildContext context, String suggestionId) {
  Navigator.of(context).pushNamed(
    AppPage.communitySuggestionDetail.routeName,
    arguments: {'suggestionId': suggestionId},
  );
}

void _openMeeting(BuildContext context, String meetingId) {
  Navigator.of(context).pushNamed(
    AppPage.communityMeetingDetail.routeName,
    arguments: {'meetingId': meetingId},
  );
}

void _showCommunityMessage(BuildContext context, String message) {
  final lowerMessage = message.toLowerCase();
  final isError =
      lowerMessage.contains('could not') ||
      lowerMessage.contains('wrong') ||
      lowerMessage.contains('join the discussion before');
  showAvenueDialogMessage(
    context,
    message: message,
    type: isError ? AvenueMessageType.error : AvenueMessageType.success,
  );
}

String _communityErrorMessage(Object error) {
  final message = error.toString();
  final sanitized = message
      .replaceFirst('PostgrestException(message: ', '')
      .replaceFirst('Exception: ', '')
      .trim();

  if (sanitized.length <= 140) {
    return sanitized;
  }

  return '${sanitized.substring(0, 137)}...';
}

class CommunityFeedScreen extends StatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen> {
  final AvenueRepository _repository = AvenueRepository();
  late Future<List<Map<String, dynamic>>> _feedFuture;

  @override
  void initState() {
    super.initState();
    _feedFuture = _repository.fetchCommunitySuggestions();
  }

  void _refresh() {
    setState(() {
      _feedFuture = _repository.fetchCommunitySuggestions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = AppSession.instance.currentUser;

    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Community',
        centerTitle: false,
        leading: AvenueIconButton(
          icon: Icons.menu_rounded,
          onPressed: () => Navigator.of(context).pushNamed(
            AppPage.drawer.routeName,
            arguments: AppPage.communityFeed,
          ),
        ),
        titleWidget: Text(
          'Community',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18, left: 8),
            child: _CommunityAvatar(
              imageUrl: currentUser?.avatarUrl,
              label: currentUser?.initials ?? 'A',
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AvenueColors.primary,
        foregroundColor: Colors.white,
        onPressed: () => goToPage(context, AppPage.communityShareIdea),
        child: const Icon(Icons.add_rounded),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _feedFuture,
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];

          return RefreshIndicator(
            onRefresh: () async => _refresh(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 110),
              children: [
                Row(
                  children: [
                    Text(
                      'Active Suggestions',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const Spacer(),
                    AvenuePill(
                      label: '${rows.length} LIVE',
                      backgroundColor: AvenueColors.surfaceHigh,
                      foregroundColor: AvenueColors.onSurfaceVariant,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                if (snapshot.connectionState != ConnectionState.done &&
                    rows.isEmpty)
                  const _CommunityPlaceholderCard(
                    label: 'Loading community discussions...',
                  )
                else if (rows.isEmpty)
                  const _CommunityPlaceholderCard(
                    label: 'No community ideas yet. Be the first to post one.',
                  )
                else
                  ...rows.map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _CommunitySuggestionCard(
                        row: row,
                        onTap: () => _openCommunitySuggestion(
                          context,
                          row['id'] as String,
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

class ShareIdeaScreen extends StatefulWidget {
  const ShareIdeaScreen({super.key});

  @override
  State<ShareIdeaScreen> createState() => _ShareIdeaScreenState();
}

class _ShareIdeaScreenState extends State<ShareIdeaScreen> {
  final AvenueRepository _repository = AvenueRepository();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  String _selectedCategory = 'Amenities';
  String _audienceScope = 'all_residents';
  List<Map<String, dynamic>> _selectedResidents = const [];
  bool _openAsPoll = true;
  bool _isSubmitting = false;

  final List<String> _categories = const [
    'Amenities',
    'Security',
    'Social',
    'Eco',
    'Wellness',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }

    if (_titleController.text.trim().isEmpty ||
        _summaryController.text.trim().isEmpty ||
        _detailsController.text.trim().isEmpty) {
      _showCommunityMessage(
        context,
        'Add a title, summary, and details first.',
      );
      return;
    }

    if (_audienceScope == 'selected_residents' && _selectedResidents.isEmpty) {
      _showCommunityMessage(
        context,
        'Select at least one resident before submitting.',
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final result = await _repository.createCommunitySuggestion(
        title: _titleController.text,
        category: _selectedCategory,
        summary: _summaryController.text,
        details: _detailsController.text,
        audienceScope: _audienceScope,
        selectedResidentIds: _selectedResidents
            .map((row) => row['id']?.toString())
            .whereType<String>()
            .toList(),
        pollEnabled: _openAsPoll,
        iconName: _iconNameForCategory(_selectedCategory),
        accentHex: _accentHexForCategory(_selectedCategory),
      );

      if (!mounted) {
        return;
      }

      if (result?['suggestion_id'] == null) {
        _showCommunityMessage(context, 'Could not post your idea right now.');
        return;
      }

      _showCommunityMessage(
        context,
        _audienceScope == 'selected_residents'
            ? 'Your idea was sent to selected residents and admin for review.'
            : 'Your idea was sent to admin for review.',
      );
      goToPage(context, AppPage.communityFeed, replace: true);
    } catch (_) {
      if (!mounted) {
        return;
      }

      _showCommunityMessage(context, 'Something went wrong while posting.');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _openSelectResidents() async {
    final result = await Navigator.of(context).pushNamed(
      AppPage.communitySelectResidents.routeName,
      arguments: {
        'selectedResidentIds': _selectedResidents
            .map((row) => row['id']?.toString())
            .whereType<String>()
            .toList(),
      },
    );

    if (!mounted || result is! List) {
      return;
    }

    final rows = result
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
    setState(() {
      _selectedResidents = rows;
      _audienceScope = 'selected_residents';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Community',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          Text(
            'Share an Idea',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Have a suggestion for the community? Submit it here and start the conversation.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AvenueColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          const _CommunitySectionLabel('Select Audience'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _AudienceChoiceChip(
                  label: 'All Residents',
                  selected: _audienceScope == 'all_residents',
                  icon: Icons.public_rounded,
                  onTap: () {
                    setState(() {
                      _audienceScope = 'all_residents';
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _AudienceChoiceChip(
                  label: _selectedResidents.isEmpty
                      ? 'Selected'
                      : 'Selected (${_selectedResidents.length})',
                  selected: _audienceScope == 'selected_residents',
                  icon: Icons.group_rounded,
                  onTap: _openSelectResidents,
                ),
              ),
            ],
          ),
          if (_audienceScope == 'selected_residents' &&
              _selectedResidents.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              _selectedResidents
                      .take(3)
                      .map((row) => row['full_name']?.toString() ?? 'Resident')
                      .join(', ') +
                  (_selectedResidents.length > 3 ? ' and more' : ''),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AvenueColors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: 22),
          const _CommunitySectionLabel('Suggestion Title'),
          const SizedBox(height: 10),
          _CommunityInputField(
            controller: _titleController,
            hintText: 'e.g., Solar lighting for the walking track',
          ),
          const SizedBox(height: 22),
          const _CommunitySectionLabel('Short Summary'),
          const SizedBox(height: 10),
          _CommunityInputField(
            controller: _summaryController,
            hintText:
                'Write a one-line version of your idea for the feed card.',
          ),
          const SizedBox(height: 22),
          const _CommunitySectionLabel('Category'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _categories
                .map(
                  (category) => _AudienceChoiceChip(
                    label: category,
                    selected: _selectedCategory == category,
                    icon: _communityIconFor(_iconNameForCategory(category)),
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 22),
          const _CommunitySectionLabel('Details'),
          const SizedBox(height: 10),
          _CommunityInputField(
            controller: _detailsController,
            hintText:
                'Describe the idea, why it matters, and how it would help residents.',
            maxLines: 6,
          ),
          const SizedBox(height: 22),
          AvenueCard(
            radius: 28,
            color: const Color(0xFFEFF4FF),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AvenueColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.poll_rounded, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Open as Community Poll',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: AvenueColors.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                          Switch.adaptive(
                            value: _openAsPoll,
                            onChanged: (value) {
                              setState(() {
                                _openAsPoll = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'When enabled, the idea appears in the feed with support progress and becomes easier to rally around.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
          const SizedBox(height: 28),
          AvenuePrimaryButton(
            label: _isSubmitting ? 'Submitting...' : 'Submit for Review',
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

class SelectResidentsScreen extends StatefulWidget {
  const SelectResidentsScreen({
    super.key,
    this.initialSelectedResidentIds = const [],
  });

  final List<String> initialSelectedResidentIds;

  @override
  State<SelectResidentsScreen> createState() => _SelectResidentsScreenState();
}

class _SelectResidentsScreenState extends State<SelectResidentsScreen> {
  final AvenueRepository _repository = AvenueRepository();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _residentsFuture;
  late final Set<String> _selectedIds;
  List<Map<String, dynamic>> _cachedRows = const [];

  @override
  void initState() {
    super.initState();
    _selectedIds = {...widget.initialSelectedResidentIds};
    _residentsFuture = _repository.fetchResidentDirectory();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleResident(Map<String, dynamic> row) {
    final residentId = row['id']?.toString();
    if (residentId == null) {
      return;
    }

    setState(() {
      if (_selectedIds.contains(residentId)) {
        _selectedIds.remove(residentId);
      } else {
        _selectedIds.add(residentId);
      }
    });
  }

  void _done() {
    final selectedRows = _cachedRows.where((row) {
      final residentId = row['id']?.toString();
      return residentId != null && _selectedIds.contains(residentId);
    }).toList();
    Navigator.of(context).pop(selectedRows);
  }

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Community',
        centerTitle: false,
        leading: AvenueIconButton(
          icon: Icons.arrow_back_rounded,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton(
              onPressed: _done,
              style: FilledButton.styleFrom(
                backgroundColor: AvenueColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: const Text('Done'),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _residentsFuture,
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          _cachedRows = rows;
          final query = _searchController.text.trim().toLowerCase();
          final filtered = rows.where((row) {
            if (query.isEmpty) {
              return true;
            }

            final unit = row['unit_number']?.toString() ?? '';
            final tower = row['tower']?.toString() ?? '';
            final text = '${row['full_name'] ?? ''} $unit $tower'.toLowerCase();
            return text.contains(query);
          }).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search residents by name or unit...',
                  filled: true,
                  fillColor: AvenueColors.surfaceLow,
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'NEARBY RESIDENTS',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AvenueColors.onSurfaceVariant,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              if (snapshot.connectionState != ConnectionState.done &&
                  rows.isEmpty)
                const _CommunityPlaceholderCard(label: 'Loading residents...')
              else if (filtered.isEmpty)
                const _CommunityPlaceholderCard(
                  label: 'No residents match your search.',
                )
              else
                ...filtered.map((row) {
                  final residentId = row['id']?.toString();
                  final isSelected =
                      residentId != null && _selectedIds.contains(residentId);
                  final unit = row['unit_number']?.toString() ?? '--';
                  final tower = row['tower']?.toString() ?? 'Tower';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AvenueCard(
                      radius: 32,
                      padding: const EdgeInsets.all(0),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(32),
                          onTap: () => _toggleResident(row),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                _CommunityAvatar(
                                  imageUrl: row['avatar_url'] as String?,
                                  label: _initialsForName(
                                    row['full_name'] as String?,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        row['full_name'] as String? ??
                                            'Resident',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '$tower - $unit',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color:
                                                  AvenueColors.onSurfaceVariant,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AvenueColors.primaryFixed
                                        : AvenueColors.surfaceHigh,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isSelected
                                        ? Icons.person_add_rounded
                                        : Icons.person_add_alt_1_rounded,
                                    color: isSelected
                                        ? AvenueColors.primary
                                        : AvenueColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              const SizedBox(height: 18),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AvenueColors.surfaceHigh,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${_selectedIds.length} resident${_selectedIds.length == 1 ? '' : 's'} selected',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AvenueColors.onSurfaceVariant,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class SuggestionDiscussionScreen extends StatefulWidget {
  const SuggestionDiscussionScreen({super.key, this.suggestionId});

  final String? suggestionId;

  @override
  State<SuggestionDiscussionScreen> createState() =>
      _SuggestionDiscussionScreenState();
}

class _SuggestionDiscussionScreenState
    extends State<SuggestionDiscussionScreen> {
  final AvenueRepository _repository = AvenueRepository();
  final TextEditingController _commentController = TextEditingController();
  Future<_SuggestionDiscussionData>? _future;
  bool _isPosting = false;
  bool _isVoting = false;
  bool _isJoining = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<_SuggestionDiscussionData> _load() async {
    final suggestionId = widget.suggestionId;
    if (suggestionId == null) {
      return const _SuggestionDiscussionData(
        null,
        <Map<String, dynamic>>[],
        false,
      );
    }

    final results = await Future.wait([
      _repository.fetchCommunitySuggestion(suggestionId),
      _repository.fetchCommunitySuggestionComments(suggestionId),
      _repository.isCurrentUserCommunitySuggestionMember(suggestionId),
    ]);

    return _SuggestionDiscussionData(
      results[0] as Map<String, dynamic>?,
      results[1] as List<Map<String, dynamic>>,
      results[2] as bool,
    );
  }

  void _refresh() {
    setState(() {
      _future = _load();
    });
  }

  Future<void> _postComment() async {
    final hasJoined = (await _future)?.hasJoined ?? false;
    if (_isPosting || widget.suggestionId == null || !hasJoined) {
      if (!hasJoined && mounted) {
        _showCommunityMessage(
          context,
          'Join the discussion before commenting.',
        );
      }
      return;
    }

    if (_commentController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _isPosting = true;
    });

    try {
      await _repository.addCommunitySuggestionComment(
        suggestionId: widget.suggestionId!,
        body: _commentController.text,
      );
      _commentController.clear();
      _refresh();
    } catch (_) {
      if (mounted) {
        _showCommunityMessage(context, 'Could not post your comment.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
        });
      }
    }
  }

  Future<void> _vote(String voteKind) async {
    final hasJoined = (await _future)?.hasJoined ?? false;
    if (_isVoting || widget.suggestionId == null || !hasJoined) {
      if (!hasJoined && mounted) {
        _showCommunityMessage(context, 'Join the discussion before voting.');
      }
      return;
    }

    setState(() {
      _isVoting = true;
    });

    try {
      await _repository.voteCommunitySuggestion(
        suggestionId: widget.suggestionId!,
        voteKind: voteKind,
      );
      if (!mounted) {
        return;
      }
      _showCommunityMessage(
        context,
        voteKind == 'in_favor'
            ? 'Your support vote was counted.'
            : 'Your review vote was counted.',
      );
      _refresh();
    } catch (error) {
      if (mounted) {
        _showCommunityMessage(
          context,
          'Could not save your vote: ${_communityErrorMessage(error)}',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isVoting = false;
        });
      }
    }
  }

  Future<void> _joinDiscussion() async {
    if (_isJoining || widget.suggestionId == null) {
      return;
    }

    setState(() {
      _isJoining = true;
    });

    try {
      await _repository.joinCommunitySuggestion(
        suggestionId: widget.suggestionId!,
      );
      if (!mounted) {
        return;
      }
      _showCommunityMessage(context, 'You joined this discussion.');
      _refresh();
    } catch (_) {
      if (mounted) {
        _showCommunityMessage(context, 'Could not join this discussion.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isJoining = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Community',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
      ),
      body: FutureBuilder<_SuggestionDiscussionData>(
        future: _future,
        builder: (context, snapshot) {
          final suggestion = snapshot.data?.suggestion;
          final comments =
              snapshot.data?.comments ?? const <Map<String, dynamic>>[];
          final hasJoined = snapshot.data?.hasJoined ?? false;

          if (snapshot.connectionState != ConnectionState.done &&
              suggestion == null) {
            return const Center(
              child: CircularProgressIndicator(color: AvenueColors.primary),
            );
          }

          if (suggestion == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'This community suggestion is no longer available.',
                ),
              ),
            );
          }

          final accent = _hexColor(suggestion['accent_hex'] as String?);
          final reviewPercent =
              100 - (suggestion['support_percent'] as int? ?? 0);

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              AvenuePill(
                label:
                    'PROPOSED • ${_communityDateLabel(suggestion['created_at'])}',
                backgroundColor: AvenueColors.primaryFixed,
                foregroundColor: AvenueColors.primary,
              ),
              const SizedBox(height: 14),
              Text(
                suggestion['title'] as String? ?? 'Community Idea',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _CommunityAvatar(
                    imageUrl: suggestion['author_avatar_url'] as String?,
                    label: _initialsForName(
                      suggestion['author_name'] as String?,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          suggestion['author_name'] as String? ?? 'Resident',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          'Unit ${suggestion['author_unit_number'] ?? '--'}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AvenueColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _CommunityCover(
                imageUrl: suggestion['cover_image_url'] as String?,
                icon: _communityIconFor(suggestion['icon_name'] as String?),
                accent: accent,
                height: 220,
              ),
              const SizedBox(height: 18),
              if (!hasJoined) ...[
                AvenueCard(
                  radius: 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.groups_rounded, color: accent),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Join to participate',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'You can read the proposal now. Join this discussion to vote and add comments.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AvenueColors.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AvenuePrimaryButton(
                        label: _isJoining ? 'Joining...' : 'Join Discussion',
                        icon: Icons.login_rounded,
                        onPressed: _isJoining ? () {} : _joinDiscussion,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
              ],
              AvenueCard(
                radius: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestion['summary'] as String? ?? '',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AvenueColors.onSurfaceVariant,
                        height: 1.55,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      suggestion['details'] as String? ?? '',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AvenueColors.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              AvenueCard(
                radius: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Current Sentiment',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const Spacer(),
                        Icon(Icons.poll_rounded, color: accent),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SentimentBar(
                      label: 'In Favor',
                      percent: suggestion['support_percent'] as int? ?? 0,
                      color: accent,
                      background: accent.withValues(alpha: 0.12),
                    ),
                    const SizedBox(height: 12),
                    _SentimentBar(
                      label: 'Needs Review',
                      percent: reviewPercent,
                      color: AvenueColors.onSurfaceVariant,
                      background: AvenueColors.surfaceHigh,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '${suggestion['total_votes'] ?? 0} votes • ${comments.length} comments',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AvenueColors.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (suggestion['poll_enabled'] != false && hasJoined) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: AvenuePrimaryButton(
                              label: _isVoting ? 'Saving...' : 'Vote In Favor',
                              icon: Icons.thumb_up_alt_rounded,
                              onPressed: _isVoting
                                  ? () {}
                                  : () => _vote('in_favor'),
                              height: 46,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _isVoting
                                  ? null
                                  : () => _vote('needs_review'),
                              icon: const Icon(Icons.rate_review_rounded),
                              label: const Text('Needs Review'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AvenueColors.onSurface,
                                minimumSize: const Size.fromHeight(46),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else if (suggestion['poll_enabled'] != false) ...[
                      const SizedBox(height: 14),
                      Text(
                        'Join this discussion to vote.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AvenueColors.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Text(
                    'Community Discussion',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (hasJoined) ...[
                AvenueCard(
                  radius: 26,
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: AvenueColors.primaryFixed,
                        child: Icon(Icons.chat_bubble_outline_rounded),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          minLines: 1,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Share your perspective...',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      AvenuePrimaryButton(
                        label: _isPosting ? 'Post...' : 'Post',
                        onPressed: _postComment,
                        fullWidth: false,
                        height: 42,
                        fontSize: 13,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ] else ...[
                const _CommunityPlaceholderCard(
                  label: 'Join this discussion to add a comment.',
                ),
                const SizedBox(height: 14),
              ],
              if (comments.isEmpty)
                const _CommunityPlaceholderCard(
                  label: 'No comments yet. Start the discussion.',
                )
              else
                ...comments.map(
                  (comment) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _CommunityCommentCard(comment: comment),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class CommunityMeetingsScreen extends StatefulWidget {
  const CommunityMeetingsScreen({super.key});

  @override
  State<CommunityMeetingsScreen> createState() =>
      _CommunityMeetingsScreenState();
}

class _CommunityMeetingsScreenState extends State<CommunityMeetingsScreen> {
  final AvenueRepository _repository = AvenueRepository();
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repository.fetchCommunityMeetings();
  }

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Meetings',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
        actions: [
          AvenueIconButton(
            icon: Icons.support_agent_rounded,
            onPressed: () => goToPage(context, AppPage.communitySupport),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              Text(
                'Recent Discussions',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Stay informed with the latest decisions, plans, and official meeting notes from the community.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AvenueColors.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              if (snapshot.connectionState != ConnectionState.done &&
                  rows.isEmpty)
                const _CommunityPlaceholderCard(label: 'Loading meetings...')
              else if (rows.isEmpty)
                const _CommunityPlaceholderCard(
                  label: 'No meeting records yet.',
                )
              else
                ...rows.map(
                  (row) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _MeetingSummaryCard(
                      row: row,
                      onTap: () => _openMeeting(context, row['id'] as String),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class MeetingMinutesScreen extends StatelessWidget {
  const MeetingMinutesScreen({super.key, this.meetingId});

  final String? meetingId;

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();

    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Meeting Minutes',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: meetingId == null
            ? Future.value(null)
            : repository.fetchCommunityMeeting(meetingId!),
        builder: (context, snapshot) {
          final meeting = snapshot.data;

          if (snapshot.connectionState != ConnectionState.done &&
              meeting == null) {
            return const Center(
              child: CircularProgressIndicator(color: AvenueColors.primary),
            );
          }

          if (meeting == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('Meeting minutes not found.'),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              Container(
                height: 220,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  image: DecorationImage(
                    image: NetworkImage(
                      (meeting['image_url'] as String?)?.trim().isNotEmpty ==
                              true
                          ? meeting['image_url'] as String
                          : _communityFallbackImage,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Color(0xC0005BBF), Color(0x20005BBF)],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const AvenuePill(
                          label: 'OFFICIAL RECORD',
                          backgroundColor: Color(0x33FFFFFF),
                          foregroundColor: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          meeting['title'] as String? ?? 'Meeting',
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            _HeroMeta(
                              icon: Icons.calendar_today_rounded,
                              label: _communityDateLabel(
                                meeting['meeting_date'],
                              ),
                            ),
                            _HeroMeta(
                              icon: Icons.location_on_outlined,
                              label:
                                  meeting['location'] as String? ??
                                  'Community Hall',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              AvenueCard(
                radius: 30,
                color: AvenueColors.surfaceLow,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.summarize_rounded,
                          color: AvenueColors.primary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Executive Summary',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      meeting['executive_summary'] as String? ?? '',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AvenueColors.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: AvenueCard(
                      radius: 26,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Duration',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AvenueColors.onSurfaceVariant,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            meeting['duration_label'] as String? ?? '--',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AvenueCard(
                      radius: 26,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Attendance',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AvenueColors.onSurfaceVariant,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${meeting['attendee_count'] ?? 0} members',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            meeting['quorum_reached'] == true
                                ? 'Quorum reached'
                                : 'Attendance below quorum',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AvenueColors.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              AvenueCard(
                radius: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.list_alt_rounded,
                          color: AvenueColors.primary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Minutes',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      meeting['minutes_body'] as String? ?? '',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AvenueColors.onSurfaceVariant,
                        height: 1.65,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class SupportHelpScreen extends StatefulWidget {
  const SupportHelpScreen({super.key});

  @override
  State<SupportHelpScreen> createState() => _SupportHelpScreenState();
}

class _SupportHelpScreenState extends State<SupportHelpScreen> {
  final AvenueRepository _repository = AvenueRepository();
  late Future<List<Map<String, dynamic>>> _future;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _future = _repository.fetchCommunitySupportFaqs();
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
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Support',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          final categories = <String>{
            'All',
            ...rows.map((row) => (row['category'] as String?) ?? 'Other'),
          }.toList();

          final filtered = rows.where((row) {
            final category = (row['category'] as String?) ?? '';
            final query = _searchController.text.trim().toLowerCase();
            final matchesCategory =
                _selectedCategory == 'All' || category == _selectedCategory;
            final haystack = '${row['question'] ?? ''} ${row['answer'] ?? ''}'
                .toLowerCase();
            final matchesQuery = query.isEmpty || haystack.contains(query);
            return matchesCategory && matchesQuery;
          }).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AvenueColors.primaryGradient,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How can we help you today?',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.94),
                        prefixIcon: const Icon(Icons.search_rounded),
                        hintText: 'Search for topics or keywords...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: categories
                    .map(
                      (category) => _AudienceChoiceChip(
                        label: category,
                        selected: category == _selectedCategory,
                        icon: _supportCategoryIcon(category),
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),
              Text(
                'Frequently Asked Questions',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              if (snapshot.connectionState != ConnectionState.done &&
                  rows.isEmpty)
                const _CommunityPlaceholderCard(
                  label: 'Loading support topics...',
                )
              else if (filtered.isEmpty)
                const _CommunityPlaceholderCard(
                  label: 'No support topics match this search yet.',
                )
              else
                ...filtered.map(
                  (row) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _FaqTile(row: row),
                  ),
                ),
              const SizedBox(height: 20),
              AvenueCard(
                radius: 34,
                color: AvenueColors.surfaceLow,
                child: Column(
                  children: [
                    Text(
                      'Need more help?',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Our resident support team and security are available around the clock.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AvenueColors.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: AvenuePrimaryButton(
                            label: 'Message Concierge',
                            onPressed: () => _showCommunityMessage(
                              context,
                              'Concierge chat is coming soon.',
                            ),
                            icon: Icons.chat_bubble_outline_rounded,
                            height: 48,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AvenueSecondaryButton(
                            label: 'Call Security',
                            onPressed: () => _showCommunityMessage(
                              context,
                              'Use the guard contact configured for your building.',
                            ),
                            icon: Icons.call_rounded,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SuggestionDiscussionData {
  const _SuggestionDiscussionData(
    this.suggestion,
    this.comments,
    this.hasJoined,
  );

  final Map<String, dynamic>? suggestion;
  final List<Map<String, dynamic>> comments;
  final bool hasJoined;
}

class _CommunitySuggestionCard extends StatelessWidget {
  const _CommunitySuggestionCard({required this.row, required this.onTap});

  final Map<String, dynamic> row;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _hexColor(row['accent_hex'] as String?);
    final totalVotes = row['total_votes'] as int? ?? 0;
    final hasJoined = row['has_joined'] == true;
    final targetVotes = row['target_votes'] as int? ?? 0;
    final votesNeeded = (targetVotes - totalVotes).clamp(0, targetVotes);
    final progress = ((row['progress_percent'] as int? ?? 0) / 100)
        .clamp(0, 1)
        .toDouble();
    final category = (row['category'] as String? ?? 'Community').toUpperCase();

    return AvenueCard(
      radius: 32,
      padding: const EdgeInsets.all(0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _communityIconFor(row['icon_name'] as String?),
                        color: accent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            row['title'] as String? ?? 'Suggestion',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  height: 1.12,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$category • $votesNeeded VOTES NEEDED',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AvenueColors.onSurfaceVariant,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  row['summary'] as String? ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AvenueColors.onSurfaceVariant,
                    height: 1.55,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: AvenueColors.surfaceHigh,
                          valueColor: AlwaysStoppedAnimation<Color>(accent),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${row['progress_percent'] ?? 0}%',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(
                  color: AvenueColors.outlineVariant.withValues(alpha: 0.3),
                  height: 1,
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _AvatarStack(
                      count: totalVotes,
                      seedName: row['author_name'] as String?,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 196,
                      child: AvenuePrimaryButton(
                        label: hasJoined ? 'Details' : 'Join Discussion',
                        onPressed: onTap,
                        height: 48,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MeetingSummaryCard extends StatelessWidget {
  const _MeetingSummaryCard({required this.row, required this.onTap});

  final Map<String, dynamic> row;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 26,
      padding: const EdgeInsets.all(0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    (row['image_url'] as String?)?.trim().isNotEmpty == true
                        ? row['image_url'] as String
                        : _communityFallbackImage,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AvenuePill(
                        label: (row['category'] as String? ?? 'Meeting')
                            .toUpperCase(),
                        backgroundColor: AvenueColors.surfaceLow,
                        foregroundColor: AvenueColors.primary,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        row['title'] as String? ?? 'Meeting',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        row['summary'] as String? ?? '',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AvenueColors.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _communityDateLabel(row['meeting_date']),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AvenueColors.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CommunityCommentCard extends StatelessWidget {
  const _CommunityCommentCard({required this.comment});

  final Map<String, dynamic> comment;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 26,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CommunityAvatar(
                imageUrl: comment['avatar_url'] as String?,
                label: _initialsForName(comment['full_name'] as String?),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment['full_name'] as String? ?? 'Resident',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Unit ${comment['unit_number'] ?? '--'} • ${_communityRelativeTime(comment['created_at'])}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AvenueColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            comment['body'] as String? ?? '',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AvenueColors.onSurfaceVariant,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  const _FaqTile({required this.row});

  final Map<String, dynamic> row;

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 22,
      padding: const EdgeInsets.all(0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.row['question'] as String? ?? 'Support topic',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      _expanded
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      color: AvenueColors.onSurfaceVariant,
                    ),
                  ],
                ),
                if (_expanded) ...[
                  const SizedBox(height: 12),
                  Text(
                    widget.row['answer'] as String? ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AvenueColors.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SentimentBar extends StatelessWidget {
  const _SentimentBar({
    required this.label,
    required this.percent,
    required this.color,
    required this.background,
  });

  final String label;
  final int percent;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            '$percent%',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _CommunityInputField extends StatelessWidget {
  const _CommunityInputField({
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _AudienceChoiceChip extends StatelessWidget {
  const _AudienceChoiceChip({
    required this.label,
    required this.selected,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: selected ? AvenueColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? AvenueColors.primary
                  : AvenueColors.outlineVariant.withValues(alpha: 0.6),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? Colors.white : AvenueColors.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: selected
                        ? Colors.white
                        : AvenueColors.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommunityPlaceholderCard extends StatelessWidget {
  const _CommunityPlaceholderCard({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 24,
      color: AvenueColors.surfaceLow,
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AvenueColors.onSurfaceVariant),
        ),
      ),
    );
  }
}

class _CommunitySectionLabel extends StatelessWidget {
  const _CommunitySectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: AvenueColors.onSurfaceVariant,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.0,
      ),
    );
  }
}

class _CommunityCover extends StatelessWidget {
  const _CommunityCover({
    required this.imageUrl,
    required this.icon,
    required this.accent,
    this.height = 180,
  });

  final String? imageUrl;
  final IconData icon;
  final Color accent;
  final double height;

  @override
  Widget build(BuildContext context) {
    final hasImage = (imageUrl ?? '').trim().isNotEmpty;

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: hasImage
            ? null
            : LinearGradient(
                colors: [
                  accent.withValues(alpha: 0.95),
                  accent.withValues(alpha: 0.6),
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
        image: hasImage
            ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
            : null,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withValues(alpha: hasImage ? 0.36 : 0.08),
              Colors.transparent,
            ],
          ),
        ),
        child: hasImage
            ? const SizedBox.shrink()
            : Center(child: Icon(icon, size: 72, color: Colors.white)),
      ),
    );
  }
}

class _CommunityAvatar extends StatelessWidget {
  const _CommunityAvatar({required this.imageUrl, required this.label});

  final String? imageUrl;
  final String label;

  @override
  Widget build(BuildContext context) {
    final value = (imageUrl ?? '').trim();
    if (value.isNotEmpty) {
      return AvenueNetworkAvatar(
        imageUrl: value,
        size: 42,
        fallbackLabel: label,
      );
    }

    return CircleAvatar(
      radius: 21,
      backgroundColor: AvenueColors.primaryFixed,
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AvenueColors.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack({required this.count, required this.seedName});

  final int count;
  final String? seedName;

  @override
  Widget build(BuildContext context) {
    final labels = [
      _initialsForName(seedName),
      seedName != null && seedName!.trim().contains(' ')
          ? _initialsForName(seedName!.trim().split(' ').last)
          : 'R',
    ];

    Widget buildCircle({
      required String label,
      required Color background,
      Color foreground = AvenueColors.primary,
    }) {
      return CircleAvatar(
        radius: 16,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 14,
          backgroundColor: background,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w800,
              fontSize: 10,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: 110,
      height: 34,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            child: buildCircle(
              label: labels[0],
              background: AvenueColors.primaryFixed,
            ),
          ),
          Positioned(
            left: 22,
            child: buildCircle(
              label: labels[1],
              background: const Color(0xFFFFEDD5),
              foreground: const Color(0xFF9A3412),
            ),
          ),
          Positioned(
            left: 44,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 14,
                backgroundColor: AvenueColors.surfaceHigh,
                child: Text(
                  '+$count',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMeta extends StatelessWidget {
  const _HeroMeta({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: Colors.white.withValues(alpha: 0.9)),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.92),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

String _iconNameForCategory(String category) {
  switch (category) {
    case 'Amenities':
      return 'lightbulb';
    case 'Security':
      return 'security';
    case 'Social':
      return 'groups';
    case 'Eco':
      return 'eco';
    case 'Wellness':
      return 'self_improvement';
    default:
      return 'lightbulb';
  }
}

String _accentHexForCategory(String category) {
  switch (category) {
    case 'Amenities':
      return '#005BBF';
    case 'Security':
      return '#C55500';
    case 'Social':
      return '#7C3AED';
    case 'Eco':
      return '#2E8B57';
    case 'Wellness':
      return '#1D4ED8';
    default:
      return '#005BBF';
  }
}

IconData _supportCategoryIcon(String category) {
  switch (category) {
    case 'Maintenance':
      return Icons.build_rounded;
    case 'Billing':
      return Icons.account_balance_wallet_rounded;
    case 'Amenities':
      return Icons.pool_rounded;
    case 'Security':
      return Icons.gpp_good_rounded;
    default:
      return Icons.help_outline_rounded;
  }
}

String _initialsForName(String? name) {
  final value = (name ?? '').trim();
  if (value.isEmpty) {
    return 'A';
  }

  final parts = value.split(RegExp(r'\s+'));
  if (parts.length == 1) {
    return parts.first.substring(0, 1).toUpperCase();
  }

  return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
      .toUpperCase();
}
