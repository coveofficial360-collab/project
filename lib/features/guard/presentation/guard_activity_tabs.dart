part of 'guard_screen.dart';

class _GuardPreApprovedTab extends StatelessWidget {
  const _GuardPreApprovedTab({
    required this.isLoading,
    required this.hasError,
    required this.visitors,
    required this.activePassId,
    required this.onApproveVisitor,
    required this.onDenyVisitor,
  });

  final bool isLoading;
  final bool hasError;
  final List<Map<String, dynamic>> visitors;
  final String? activePassId;
  final Future<void> Function(String passId, String visitorName)
  onApproveVisitor;
  final Future<void> Function(String passId, String visitorName) onDenyVisitor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Expected Visitors',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          'Pre-approved arrivals and active guest passes at the gate.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: _GuardPalette.muted),
        ),
        const SizedBox(height: 14),
        if (hasError)
          const _GuardMessageCard(
            title: 'Could not load gate activity',
            body:
                'The guard screen is connected, but this fetch failed. Please retry after checking the database grants.',
          )
        else if (isLoading)
          const _GuardMessageCard(
            title: 'Loading gate activity',
            body: 'Fetching visitor approvals and access queue...',
          )
        else if (visitors.isEmpty)
          const _GuardMessageCard(
            title: 'No expected visitors',
            body: 'There are no active visitor passes at the moment.',
          )
        else
          ...visitors.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _GuardVisitorCard(
                row,
                isProcessing: activePassId == row['id']?.toString(),
                onApprove: () => onApproveVisitor(
                  row['id'].toString(),
                  row['visitor_name']?.toString() ?? 'Visitor',
                ),
                onDeny: () => onDenyVisitor(
                  row['id'].toString(),
                  row['visitor_name']?.toString() ?? 'Visitor',
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _GuardHistoryTab extends StatelessWidget {
  const _GuardHistoryTab({
    required this.isLoading,
    required this.hasError,
    required this.logs,
  });

  final bool isLoading;
  final bool hasError;
  final List<Map<String, dynamic>> logs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Guard Logs',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          'Latest gate actions and incident notes recorded by the guard desk.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: _GuardPalette.muted),
        ),
        const SizedBox(height: 14),
        if (hasError)
          const _GuardMessageCard(
            title: 'Could not load guard logs',
            body: 'Please retry after checking the guard duty records.',
          )
        else if (isLoading)
          const _GuardMessageCard(
            title: 'Loading duty logs',
            body: 'Fetching recent activity from the guard desk...',
          )
        else if (logs.isEmpty)
          const _GuardMessageCard(
            title: 'No guard logs found',
            body:
                'Guard activity will appear here as soon as entries are recorded.',
          )
        else
          ...logs.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _GuardLogCard(row),
            ),
          ),
      ],
    );
  }
}
