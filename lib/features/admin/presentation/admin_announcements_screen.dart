part of 'admin_screens.dart';

class AnnouncementsManagementScreen extends StatefulWidget {
  const AnnouncementsManagementScreen({super.key});

  @override
  State<AnnouncementsManagementScreen> createState() =>
      _AnnouncementsManagementScreenState();
}

class _AnnouncementsManagementScreenState
    extends State<AnnouncementsManagementScreen> {
  final AvenueRepository _repository = AvenueRepository();
  late Future<_AnnouncementsData> _announcementsFuture;

  String _selectedState = 'sent';
  int _visibleRows = 6;

  @override
  void initState() {
    super.initState();
    _announcementsFuture = _AnnouncementsData.load(_repository);
  }

  @override
  Widget build(BuildContext context) {
    return _AdminScaffold(
      currentPage: AppPage.announcementsManagement,
      topBar: _AdminTopBar(
        title: 'Announcements',
        leadingIcon: Icons.menu_rounded,
        onLeadingTap: () =>
            _openAdminMenu(context, AppPage.announcementsManagement),
        trailing: IconButton(
          onPressed: () {
            setState(() {
              _announcementsFuture = _AnnouncementsData.load(_repository);
            });
          },
          icon: const Icon(Icons.refresh_rounded),
          color: _AdminPalette.muted,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddAnnouncement,
        backgroundColor: AvenueColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
      ),
      child: FutureBuilder<_AnnouncementsData>(
        future: _announcementsFuture,
        builder: (context, snapshot) {
          final rows = snapshot.data?.rows ?? const <Map<String, dynamic>>[];
          final filteredRows = rows.where((row) {
            final state = _normalize(row['state']?.toString() ?? '');
            return state == _selectedState;
          }).toList();
          final visibleRows = filteredRows.take(_visibleRows).toList();

          return _AdminBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _AnnouncementStateTab(
                        label: 'Sent Notices',
                        selected: _selectedState == 'sent',
                        onTap: () => setState(() {
                          _selectedState = 'sent';
                          _visibleRows = 6;
                        }),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _AnnouncementStateTab(
                        label: 'Scheduled',
                        selected: _selectedState == 'scheduled',
                        onTap: () => setState(() {
                          _selectedState = 'scheduled';
                          _visibleRows = 6;
                        }),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _AnnouncementStateTab(
                        label: 'Drafts',
                        selected: _selectedState == 'draft',
                        onTap: () => setState(() {
                          _selectedState = 'draft';
                          _visibleRows = 6;
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Text(
                      'Recent History',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Showing last 30 days',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _AdminPalette.muted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (snapshot.connectionState != ConnectionState.done &&
                    filteredRows.isEmpty)
                  const _AdminEmptyState(
                    label: 'Loading announcement history...',
                  )
                else if (filteredRows.isEmpty)
                  _AdminEmptyState(
                    label: _selectedState == 'sent'
                        ? 'No sent announcements yet.'
                        : _selectedState == 'scheduled'
                        ? 'No scheduled announcements yet.'
                        : 'No saved drafts yet.',
                  )
                else
                  ...visibleRows.map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _AnnouncementHistoryCard(
                        category: _announcementKindLabel(
                          row['kind'] as String?,
                        ),
                        categoryColor: _announcementKindColor(
                          row['kind'] as String?,
                        ),
                        timestamp: _timeAgoLabel(row['created_at']),
                        title: row['title'] as String? ?? 'Announcement',
                        body: row['body'] as String? ?? '',
                        reads: '${row['reads_count']?.toString() ?? '0'} Reads',
                        audience:
                            row['target_audience'] as String? ?? 'Residents',
                      ),
                    ),
                  ),
                if (filteredRows.length > _visibleRows) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _visibleRows += 6;
                        });
                      },
                      icon: Text(
                        'Load More History',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AvenueColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      label: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AvenueColors.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _openAddAnnouncement() async {
    final created = await Navigator.of(
      context,
    ).pushNamed(AppPage.addAnnouncement.routeName);
    if (created == true && mounted) {
      setState(() {
        _announcementsFuture = _AnnouncementsData.load(_repository);
        _selectedState = 'sent';
        _visibleRows = 6;
      });
    }
  }
}

class AddAnnouncementScreen extends StatefulWidget {
  const AddAnnouncementScreen({super.key});

  @override
  State<AddAnnouncementScreen> createState() => _AddAnnouncementScreenState();
}

class _AddAnnouncementScreenState extends State<AddAnnouncementScreen> {
  final AvenueRepository _repository = AvenueRepository();
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final audienceController = TextEditingController(text: 'All Residents');

  String selectedKind = 'general';
  bool isSubmitting = false;

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    audienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AdminScaffold(
      currentPage: AppPage.announcementsManagement,
      showBottomNavigation: false,
      topBar: _AdminTopBar(
        title: 'Add Announcement',
        leadingIcon: Icons.arrow_back_rounded,
        onLeadingTap: () => Navigator.of(context).pop(),
      ),
      child: _AdminBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _AdminTag(
              label: 'NOTICE MODULE',
              background: Color(0x1A005BBF),
              foreground: AvenueColors.primary,
            ),
            const SizedBox(height: 14),
            Text(
              'Create Announcement',
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(fontSize: 32, height: 1.05),
            ),
            const SizedBox(height: 8),
            Text(
              'Compose a resident notice, choose the audience, and publish it to the notice board.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: _AdminPalette.muted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            _AdminGlassCard(
              radius: 28,
              backgroundColor: _AdminPalette.surfaceLow.withValues(alpha: 0.74),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _AdminSectionLabel(text: 'ANNOUNCEMENT DETAILS'),
                    const SizedBox(height: 12),
                    _AdminComposerField(
                      label: 'Title',
                      hintText: 'Water supply update',
                      controller: titleController,
                    ),
                    const SizedBox(height: 12),
                    _AdminComposerField(
                      label: 'Body',
                      hintText: 'Emergency repairs are underway...',
                      controller: bodyController,
                      minLines: 4,
                      maxLines: 6,
                    ),
                    const SizedBox(height: 12),
                    _AdminComposerField(
                      label: 'Audience',
                      hintText: 'All Residents',
                      controller: audienceController,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'ANNOUNCEMENT TYPE',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: _AdminPalette.muted,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _AdminSelectChip(
                          label: 'General',
                          selected: selectedKind == 'general',
                          onTap: () => setState(() => selectedKind = 'general'),
                        ),
                        _AdminSelectChip(
                          label: 'Urgent',
                          selected: selectedKind == 'urgent',
                          onTap: () => setState(() => selectedKind = 'urgent'),
                        ),
                        _AdminSelectChip(
                          label: 'Event',
                          selected: selectedKind == 'event',
                          onTap: () => setState(() => selectedKind = 'event'),
                        ),
                        _AdminSelectChip(
                          label: 'Facility',
                          selected: selectedKind == 'facility',
                          onTap: () =>
                              setState(() => selectedKind = 'facility'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(54),
                              side: BorderSide(
                                color: AvenueColors.primary.withValues(
                                  alpha: 0.25,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AvenueColors.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: AvenuePrimaryButton(
                            label: isSubmitting ? 'Publishing...' : 'Publish',
                            onPressed: _publishAnnouncement,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            const _AdminInfoBanner(
              icon: Icons.notifications_active_rounded,
              title: 'LIVE UPDATE',
              body:
                  'Published notices appear in the resident notice board and create resident notifications.',
            ),
            const SizedBox(height: 12),
            const _AdminInfoBanner(
              icon: Icons.group_rounded,
              title: 'AUDIENCE',
              body:
                  'Use all residents for community notices or a focused audience label for targeted communication.',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _publishAnnouncement() async {
    if (isSubmitting) {
      return;
    }

    final title = titleController.text.trim();
    final body = bodyController.text.trim();
    final audience = audienceController.text.trim();
    if (title.isEmpty || body.isEmpty || audience.isEmpty) {
      showAvenueDialogMessage(
        context,
        title: 'Missing details',
        message: 'Enter title, body, and audience.',
        type: AvenueMessageType.error,
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    Map<String, dynamic>? result;
    String? errorMessage;
    try {
      result = await _repository.createAnnouncement(
        kind: selectedKind,
        title: title,
        body: body,
        targetAudience: audience,
      );
    } catch (error) {
      errorMessage = error.toString();
    }

    if (!mounted) {
      return;
    }

    if (result == null) {
      setState(() {
        isSubmitting = false;
      });
      showAvenueDialogMessage(
        context,
        message: errorMessage ?? 'Could not publish notice.',
        type: AvenueMessageType.error,
      );
      return;
    }

    final announcementId = result['announcement_id']?.toString() ?? '';
    var successMessage = 'Announcement published.';

    if (announcementId.isNotEmpty) {
      try {
        await _repository.sendAnnouncementPush(announcementId: announcementId);
      } catch (_) {
        successMessage =
            'Announcement published. Push delivery is not configured yet.';
      }
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(successMessage)));
    Navigator.of(context).pop(true);
  }
}
