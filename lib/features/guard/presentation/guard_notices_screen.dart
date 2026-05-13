part of 'guard_screen.dart';

class GuardNoticesScreen extends StatefulWidget {
  const GuardNoticesScreen({super.key});

  @override
  State<GuardNoticesScreen> createState() => _GuardNoticesScreenState();
}

class _GuardNoticesScreenState extends State<GuardNoticesScreen> {
  final AvenueRepository _repository = AvenueRepository();

  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    final rows = await _repository.fetchCurrentUserNotifications();
    await _repository.markAllCurrentUserNotificationsRead();
    return rows;
  }

  Future<void> _refresh() async {
    final future = _load();
    setState(() {
      _future = future;
    });
    await future;
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = AppSession.instance.currentUser;

    return Scaffold(
      backgroundColor: _GuardPalette.background,
      appBar: _GuardTopBar(
        currentUser: currentUser,
        onSearch: () => goToPage(context, AppPage.guardHome, replace: true),
        onNotifications: () => _refresh(),
        onLogout: () {
          AppSession.instance.clear();
          goToPage(context, AppPage.login, replace: true);
        },
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _future,
            builder: (context, snapshot) {
              final rows = snapshot.data ?? const <Map<String, dynamic>>[];
              final isLoading =
                  snapshot.connectionState != ConnectionState.done;
              final hasError = snapshot.hasError;

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Guard Notices',
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                color: _GuardPalette.ink,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.8,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Updates from the admin office for gate operations and security staff.',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: _GuardPalette.muted,
                                height: 1.45,
                              ),
                        ),
                        const SizedBox(height: 20),
                        if (isLoading && rows.isEmpty)
                          const _GuardMessageCard(
                            title: 'Loading notices',
                            body: 'Fetching the latest admin updates.',
                          )
                        else if (hasError)
                          const _GuardMessageCard(
                            title: 'Could not load notices',
                            body: 'Pull down to try again.',
                          )
                        else if (rows.isEmpty)
                          const _GuardMessageCard(
                            title: 'No notices yet',
                            body: 'Admin notices for guards will appear here.',
                          )
                        else
                          ...rows.map(
                            (row) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: _GuardNoticeCard(
                                row: row,
                                onOpen: () => _speakNotice(row),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: _GuardBottomNavigationBar(
        selectedTab: 'notices',
        onSelect: (_) => goToPage(context, AppPage.guardHome, replace: true),
        onNoticesTap: () {},
      ),
    );
  }

  Future<void> _speakNotice(Map<String, dynamic> row) async {
    final title = row['title']?.toString().trim() ?? 'Notice';
    final body = row['body']?.toString().trim() ?? '';
    final spokenText = body.isEmpty ? title : '$title. $body';
    final didStart = await TextToSpeechService.instance.speak(
      spokenText,
      languageCode: 'hi-IN',
    );

    if (!mounted || didStart) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Text to speech is not available here.')),
    );
  }
}

class _GuardNoticeCard extends StatelessWidget {
  const _GuardNoticeCard({required this.row, required this.onOpen});

  final Map<String, dynamic> row;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final kind = _normalize(row['kind']);
    final isUrgent = kind == 'urgent';
    final accent = isUrgent ? _GuardPalette.error : AvenueColors.primary;
    final badge = row['badge_label']?.toString().trim();

    return InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(24),
      child: _GuardGlassCard(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  isUrgent
                      ? Icons.priority_high_rounded
                      : Icons.notifications_active_rounded,
                  color: accent,
                ),
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
                            row['title'] as String? ?? 'Notice',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: _GuardPalette.ink,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                        ),
                        if (badge != null && badge.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          _GuardNoticeBadge(label: badge, color: accent),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      row['body'] as String? ?? 'No details provided.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _GuardPalette.muted,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _guardArrivalLabel(row['created_at']),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: _GuardPalette.muted,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                        Icon(Icons.volume_up_rounded, size: 20, color: accent),
                        const SizedBox(width: 4),
                        Text(
                          'Read aloud',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: accent,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuardNoticeBadge extends StatelessWidget {
  const _GuardNoticeBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
