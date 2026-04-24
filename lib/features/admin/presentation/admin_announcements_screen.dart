part of 'admin_screens.dart';

class AnnouncementsManagementScreen extends StatefulWidget {
  const AnnouncementsManagementScreen({
    super.key,
    this.openComposerOnStart = false,
  });

  final bool openComposerOnStart;

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
  bool _composerShown = false;

  @override
  void initState() {
    super.initState();
    _announcementsFuture = _AnnouncementsData.load(_repository);

    if (widget.openComposerOnStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_composerShown) {
          _composerShown = true;
          _showCreateAnnouncementSheet();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _AdminScaffold(
      currentPage: AppPage.announcementsManagement,
      topBar: _AdminTopBar(
        title: 'Announcements',
        leadingIcon: Icons.menu_rounded,
        onLeadingTap: () => _openAdminMenu(
          context,
          AppPage.announcementsManagement,
        ),
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
        onPressed: _showCreateAnnouncementSheet,
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
                        reads:
                            '${row['reads_count']?.toString() ?? '0'} Reads',
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

  Future<void> _showCreateAnnouncementSheet() async {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    final audienceController = TextEditingController(text: 'All Residents');
    String selectedKind = 'general';
    bool isSubmitting = false;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 30,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: _AdminGlassCard(
                radius: 30,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'New Announcement',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Compose a notice that appears in the resident notice board and triggers live updates.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _AdminPalette.muted,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 18),
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
                    const SizedBox(height: 14),
                    Text(
                      'Announcement Type',
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
                          onTap: () {
                            setModalState(() {
                              selectedKind = 'general';
                            });
                          },
                        ),
                        _AdminSelectChip(
                          label: 'Urgent',
                          selected: selectedKind == 'urgent',
                          onTap: () {
                            setModalState(() {
                              selectedKind = 'urgent';
                            });
                          },
                        ),
                        _AdminSelectChip(
                          label: 'Event',
                          selected: selectedKind == 'event',
                          onTap: () {
                            setModalState(() {
                              selectedKind = 'event';
                            });
                          },
                        ),
                        _AdminSelectChip(
                          label: 'Facility',
                          selected: selectedKind == 'facility',
                          onTap: () {
                            setModalState(() {
                              selectedKind = 'facility';
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    AvenuePrimaryButton(
                      label: isSubmitting ? 'Publishing...' : 'Publish',
                      onPressed: () async {
                        if (isSubmitting) {
                          return;
                        }

                        final title = titleController.text.trim();
                        final body = bodyController.text.trim();
                        final audience = audienceController.text.trim();
                        if (title.isEmpty || body.isEmpty || audience.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Enter title, body, and target audience.',
                              ),
                            ),
                          );
                          return;
                        }

                        setModalState(() {
                          isSubmitting = true;
                        });

                        final messenger = ScaffoldMessenger.of(this.context);
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

                        if (!mounted || !sheetContext.mounted) {
                          return;
                        }

                        Navigator.of(sheetContext).pop();

                        if (result == null) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                errorMessage ??
                                    'Could not publish announcement.',
                              ),
                            ),
                          );
                          return;
                        }

                        final announcementId =
                            result['announcement_id']?.toString() ?? '';
                        var successMessage = 'Announcement published.';

                        if (announcementId.isNotEmpty) {
                          try {
                            await _repository.sendAnnouncementPush(
                              announcementId: announcementId,
                            );
                          } catch (_) {
                            successMessage =
                                'Announcement published. Push delivery is not configured yet.';
                          }
                        }

                        setState(() {
                          _announcementsFuture = _AnnouncementsData.load(
                            _repository,
                          );
                          _selectedState = 'sent';
                          _visibleRows = 6;
                        });

                        messenger.showSnackBar(
                          SnackBar(content: Text(successMessage)),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
