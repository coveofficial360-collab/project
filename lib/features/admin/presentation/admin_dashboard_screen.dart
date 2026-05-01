part of 'admin_screens.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();
    final currentUser = AppSession.instance.currentUser;

    return _AdminScaffold(
      currentPage: AppPage.adminDrawer,
      topBar: _AdminTopBar(
        title: 'COVE',
        leadingIcon: Icons.menu_rounded,
        onLeadingTap: () => _openAdminMenu(context, AppPage.adminDrawer),
      ),
      child: FutureBuilder<_AdminDashboardData>(
        future: _AdminDashboardData.load(repository),
        builder: (context, snapshot) {
          final metrics = snapshot.data?.metrics;
          final transactions =
              snapshot.data?.transactions ?? const <Map<String, dynamic>>[];

          final activityRows = <_AdminActivityModel>[
            if (transactions.isNotEmpty)
              ...transactions
                  .take(2)
                  .map(
                    (row) => _AdminActivityModel(
                      icon: row['icon_name'] == 'flash_on'
                          ? Icons.bolt_rounded
                          : Icons.receipt_long_rounded,
                      tint: row['icon_name'] == 'flash_on'
                          ? const Color(0xFFE4F2FF)
                          : const Color(0xFFFFF1C8),
                      title: row['title'] as String? ?? 'Transaction',
                      subtitle: row['subtitle'] as String? ?? '',
                      trailing: _formatCurrency(row['amount']),
                    ),
                  ),
            _AdminActivityModel(
              icon: Icons.person_add_alt_1_rounded,
              tint: const Color(0xFFE7F6EE),
              title: 'Residents onboarded',
              subtitle:
                  '${_formatMetricValue(metrics?['active_residents'])} active residents in the community',
              trailing: 'Live',
            ),
            _AdminActivityModel(
              icon: Icons.report_problem_rounded,
              tint: const Color(0xFFFFE9E6),
              title: 'Open complaints',
              subtitle:
                  '${_formatMetricValue(metrics?['open_complaints'])} pending issue${_formatMetricValue(metrics?['open_complaints']) == '1' ? '' : 's'} awaiting resolution',
              trailing: 'Today',
            ),
          ];

          return _AdminBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning,',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _AdminPalette.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Overview',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.2,
                    color: _AdminPalette.ink,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Welcome back, ${currentUser?.fullName.split(' ').first ?? 'Marcus'}. Here is what is happening across Avenue360 today.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _AdminPalette.muted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.1,
                  children: [
                    _AdminMetricTile(
                      icon: Icons.group_rounded,
                      label: 'Total Residents',
                      value: snapshot.connectionState != ConnectionState.done
                          ? '...'
                          : _formatMetricValue(metrics?['active_residents']),
                    ),
                    _AdminMetricTile(
                      icon: Icons.payments_rounded,
                      label: 'Revenue',
                      value: snapshot.connectionState != ConnectionState.done
                          ? '...'
                          : _formatCurrency(metrics?['total_collected']),
                      highlighted: true,
                    ),
                    _AdminMetricTile(
                      icon: Icons.report_problem_rounded,
                      label: 'Pending Complaints',
                      value: snapshot.connectionState != ConnectionState.done
                          ? '...'
                          : _formatMetricValue(metrics?['open_complaints']),
                    ),
                    _AdminMetricTile(
                      icon: Icons.event_available_rounded,
                      label: 'Active Visitors',
                      value: snapshot.connectionState != ConnectionState.done
                          ? '...'
                          : _formatMetricValue(
                              metrics?['active_visitor_passes'],
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                _AdminSectionHeading(title: 'Quick Actions'),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _AdminQuickActionButton(
                        icon: Icons.person_add_alt_1_rounded,
                        label: 'Add Resident',
                        emphasized: true,
                        onTap: () => goToPage(context, AppPage.addResident),
                      ),
                      const SizedBox(width: 10),
                      _AdminQuickActionButton(
                        icon: Icons.campaign_rounded,
                        label: 'Post Notice',
                        onTap: () => goToPage(context, AppPage.addAnnouncement),
                      ),
                      const SizedBox(width: 10),
                      _AdminQuickActionButton(
                        icon: Icons.report_problem_rounded,
                        label: 'Complaints',
                        onTap: () => goToPage(context, AppPage.adminComplaints),
                      ),
                      const SizedBox(width: 10),
                      _AdminQuickActionButton(
                        icon: Icons.apartment_rounded,
                        label: 'Amenities',
                        onTap: () => goToPage(context, AppPage.adminAmenities),
                      ),
                      const SizedBox(width: 10),
                      _AdminQuickActionButton(
                        icon: Icons.handyman_rounded,
                        label: 'Services',
                        onTap: () => goToPage(context, AppPage.adminServices),
                      ),
                      const SizedBox(width: 10),
                      _AdminQuickActionButton(
                        icon: Icons.forum_rounded,
                        label: 'Community',
                        onTap: () => goToPage(context, AppPage.adminCommunity),
                      ),
                      const SizedBox(width: 10),
                      _AdminQuickActionButton(
                        icon: Icons.summarize_rounded,
                        label: 'Generate Report',
                        onTap: () => goToPage(context, AppPage.generateReports),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                _AdminSectionHeading(title: 'Featured Spaces'),
                const SizedBox(height: 12),
                _AdminFeatureCard(
                  imageUrl: _adminPoolImageUrl,
                  title: 'The Sky Pool',
                  badge: 'OPEN',
                ),
                const SizedBox(height: 14),
                _AdminFeatureCard(
                  imageUrl: _adminGymImageUrl,
                  title: 'Zenith Gym',
                  badge: 'ACTIVE',
                ),
                const SizedBox(height: 14),
                _AdminGlassCard(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => goToPage(context, AppPage.residentDirectory),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: _AdminPalette.surfaceLow,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.group_add_rounded,
                              color: AvenueColors.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Manage Residents',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Open the directory, review verification status, and onboard new residents.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: _AdminPalette.muted,
                                  height: 1.5,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                _AdminSectionHeading(
                  title: 'Recent Activity',
                  actionLabel: 'View All',
                  onActionTap: () =>
                      goToPage(context, AppPage.announcementsManagement),
                ),
                const SizedBox(height: 12),
                if (snapshot.connectionState != ConnectionState.done &&
                    transactions.isEmpty)
                  const _AdminEmptyState(
                    label: 'Loading current admin activity...',
                  )
                else
                  ...activityRows
                      .take(4)
                      .map(
                        (row) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _AdminActivityTile(model: row),
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
