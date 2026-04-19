import 'package:flutter/material.dart';

import '../../../app/app_page.dart';
import '../../../core/session/app_session.dart';
import '../../../core/supabase/avenue_repository.dart';
import '../../../theme/avenue_theme.dart';
import '../../common/presentation/avenue_ui.dart';

class GuardHomeScreen extends StatelessWidget {
  const GuardHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = AppSession.instance.currentUser;
    final repository = AvenueRepository();

    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Gate Control',
        leading: AvenueIconButton(
          icon: Icons.shield_outlined,
          onPressed: () {},
          filled: true,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AvenueColors.primaryFixed,
              child: Text(
                currentUser?.initials ?? 'G',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AvenueColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: FutureBuilder<_GuardDashboardData>(
          future: _GuardDashboardData.load(repository),
          builder: (context, snapshot) {
            final data = snapshot.data;
            final isLoading = snapshot.connectionState != ConnectionState.done;
            final error = snapshot.hasError;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUser?.fullName ?? 'Guard Dashboard',
                        style: Theme.of(
                          context,
                        ).textTheme.displayMedium?.copyWith(fontSize: 22),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        currentUser?.subtitle ?? 'Main Gate',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AvenueColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: _GuardStatCard(
                              label: 'Expected',
                              value:
                                  data?.upcomingVisitors.length.toString() ??
                                  (isLoading ? '...' : '0'),
                              icon: Icons.group_outlined,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _GuardStatCard(
                              label: 'Duty Logs',
                              value:
                                  data?.logs.length.toString() ??
                                  (isLoading ? '...' : '0'),
                              icon: Icons.fact_check_outlined,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      AvenueSectionHeader(title: 'Expected Visitors'),
                      const SizedBox(height: 12),
                      if (error)
                        const _GuardMessageCard(
                          title: 'Could not load gate activity',
                          body:
                              'The guard screen is connected, but this fetch failed. Please retry after checking the database grants.',
                        )
                      else if (isLoading)
                        const _GuardMessageCard(
                          title: 'Loading gate activity',
                          body:
                              'Fetching visitor approvals and access queue...',
                        )
                      else if (data == null || data.upcomingVisitors.isEmpty)
                        const _GuardMessageCard(
                          title: 'No expected visitors',
                          body:
                              'There are no active visitor passes at the moment.',
                        )
                      else
                        ...data.upcomingVisitors.map(_GuardVisitorCard.new),
                      const SizedBox(height: 22),
                      AvenueSectionHeader(title: 'Recent Guard Logs'),
                      const SizedBox(height: 12),
                      if (!isLoading && !error && data != null)
                        ...data.logs.map(_GuardLogCard.new),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            AppSession.instance.clear();
                            goToPage(context, AppPage.login, replace: true);
                          },
                          icon: const Icon(Icons.logout_rounded),
                          label: const Text('Logout'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFEB4B3D),
                            side: const BorderSide(color: Color(0xFFEB4B3D)),
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 18),
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
    );
  }
}

class _GuardDashboardData {
  const _GuardDashboardData({
    required this.upcomingVisitors,
    required this.logs,
  });

  final List<Map<String, dynamic>> upcomingVisitors;
  final List<Map<String, dynamic>> logs;

  static Future<_GuardDashboardData> load(AvenueRepository repository) async {
    final results = await Future.wait([
      repository.fetchGuardGateActivities(),
      repository.fetchGuardDutyLogs(),
    ]);

    return _GuardDashboardData(upcomingVisitors: results[0], logs: results[1]);
  }
}

class _GuardStatCard extends StatelessWidget {
  const _GuardStatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AvenueColors.primary),
          const SizedBox(height: 14),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _GuardVisitorCard extends StatelessWidget {
  const _GuardVisitorCard(this.row);

  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AvenueCard(
        radius: 22,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    row['visitor_name'] as String? ?? 'Visitor',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                AvenuePill(
                  label: (row['status'] as String? ?? 'expected').toUpperCase(),
                  backgroundColor: const Color(0xFFE8EEFF),
                  foregroundColor: AvenueColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${row['visitor_kind']} • ${row['resident_name']} • Unit ${row['unit_number'] ?? '-'}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AvenueColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'PIN ${row['pin_code']}',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuardLogCard extends StatelessWidget {
  const _GuardLogCard(this.row);

  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AvenueCard(
        radius: 22,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              row['title'] as String? ?? 'Log',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              row['details'] as String? ?? '',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AvenueColors.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuardMessageCard extends StatelessWidget {
  const _GuardMessageCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AvenueColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
