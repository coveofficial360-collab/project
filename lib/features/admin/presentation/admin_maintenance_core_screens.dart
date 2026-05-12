part of 'admin_screens.dart';

class AdminMaintenanceDashboardScreen extends StatelessWidget {
  const AdminMaintenanceDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();

    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Maintenance',
        leading: AvenueIconButton(
          icon: Icons.menu_rounded,
          onPressed: () => Navigator.of(context).pushNamed(
            AppPage.adminMenu.routeName,
            arguments: AppPage.adminMaintenance,
          ),
          filled: true,
        ),
        actions: [
          AvenueIconButton(
            icon: Icons.refresh_rounded,
            onPressed: () => Navigator.of(
              context,
            ).pushReplacementNamed(AppPage.adminMaintenance.routeName),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: repository.fetchAdminMaintenanceResidentLog(),
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          final total = rows.length;
          final paid = rows.where((row) => _status(row) == 'paid').length;
          final pending = rows.where((row) => _status(row) == 'pending').length;
          final overdue = rows.where((row) => _status(row) == 'overdue').length;
          final totalDue = rows
              .where((row) => _status(row) != 'paid')
              .fold<double>(
                0,
                (sum, row) => sum + _toDouble(row['amount_due']),
              );

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvenueCard(
                  radius: 28,
                  child: Row(
                    children: [
                      Expanded(
                        child: _MetricBox(
                          label: 'Residents',
                          value: '$total',
                          icon: Icons.groups_rounded,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _MetricBox(
                          label: 'Paid',
                          value: '$paid',
                          icon: Icons.check_circle_rounded,
                          color: const Color(0xFF1F8E5A),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                AvenueCard(
                  radius: 28,
                  color: AvenueColors.surfaceLow,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Collection Snapshot',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _InfoRow(label: 'Pending', value: '$pending'),
                      _InfoRow(label: 'Overdue', value: '$overdue'),
                      _InfoRow(label: 'Outstanding', value: _money(totalDue)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Quick Actions',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _QuickActionCard(
                      icon: Icons.warning_amber_rounded,
                      label: 'Forced Alert',
                      onTap: () => Navigator.of(context).pushNamed(
                        AppPage.adminMaintenanceForcedAlert.routeName,
                      ),
                    ),
                    _QuickActionCard(
                      icon: Icons.list_alt_rounded,
                      label: 'Resident Log',
                      onTap: () => Navigator.of(context).pushNamed(
                        AppPage.adminMaintenanceResidentLog.routeName,
                      ),
                    ),
                    _QuickActionCard(
                      icon: Icons.notifications_active_rounded,
                      label: 'Notify Settings',
                      onTap: () => Navigator.of(context).pushNamed(
                        AppPage.adminMaintenanceNotificationSettings.routeName,
                      ),
                    ),
                    _QuickActionCard(
                      icon: Icons.file_download_rounded,
                      label: 'Export',
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(AppPage.adminMaintenanceExport.routeName),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AvenueSectionHeader(
                  title: 'Recent Activity',
                  actionLabel: 'View All',
                  onActionTap: () => Navigator.of(
                    context,
                  ).pushNamed(AppPage.adminMaintenanceResidentLog.routeName),
                ),
                const SizedBox(height: 8),
                if (snapshot.connectionState != ConnectionState.done &&
                    rows.isEmpty)
                  const AvenueCard(
                    radius: 16,
                    child: AvenueSkeletonBlock(height: 120, radius: 14),
                  )
                else if (rows.isEmpty)
                  const AvenueCard(
                    radius: 16,
                    child: Text('No maintenance records found.'),
                  )
                else
                  ...rows
                      .take(5)
                      .map(
                        (row) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: AvenueCard(
                            radius: 16,
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              onTap: () => Navigator.of(context).pushNamed(
                                AppPage
                                    .adminMaintenanceResidentDetail
                                    .routeName,
                                arguments: {'resident': row},
                              ),
                              leading: CircleAvatar(
                                backgroundColor: _statusColor(
                                  _status(row),
                                ).withValues(alpha: 0.14),
                                child: Icon(
                                  Icons.person_rounded,
                                  color: _statusColor(_status(row)),
                                ),
                              ),
                              title: Text(
                                row['resident_name']?.toString() ?? 'Resident',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              subtitle: Text(
                                '${row['unit_number'] ?? '-'} • Due ${_date(row['due_date'])}',
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    _money(_maintenanceDisplayAmount(row)),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(height: 2),
                                  _TinyStatusChip(label: _status(row)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
      bottomNavigation: const AvenueBottomNavigationBar(
        items: [
          AvenueNavItem(
            label: 'HOME',
            icon: Icons.home_rounded,
            page: AppPage.adminDrawer,
          ),
          AvenueNavItem(
            label: 'RESIDENTS',
            icon: Icons.group_outlined,
            page: AppPage.residentDirectory,
          ),
          AvenueNavItem(
            label: 'NOTIFY',
            icon: Icons.campaign_outlined,
            page: AppPage.announcementsManagement,
          ),
          AvenueNavItem(
            label: 'REPORTS',
            icon: Icons.summarize_outlined,
            page: AppPage.generateReports,
          ),
        ],
        currentPage: AppPage.adminMaintenance,
      ),
    );
  }
}

class AdminMaintenanceResidentLogScreen extends StatefulWidget {
  const AdminMaintenanceResidentLogScreen({super.key});

  @override
  State<AdminMaintenanceResidentLogScreen> createState() =>
      _AdminMaintenanceResidentLogScreenState();
}

class AdminMaintenanceResidentDetailScreen extends StatefulWidget {
  const AdminMaintenanceResidentDetailScreen({
    super.key,
    required this.resident,
  });

  final Map<String, dynamic> resident;

  @override
  State<AdminMaintenanceResidentDetailScreen> createState() =>
      _AdminMaintenanceResidentDetailScreenState();
}
