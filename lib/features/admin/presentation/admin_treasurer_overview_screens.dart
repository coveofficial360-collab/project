part of 'admin_screens.dart';

class AdminTreasurerDashboardScreen extends StatelessWidget {
  const AdminTreasurerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();
    return _AdminScaffold(
      currentPage: AppPage.adminTreasurerDashboard,
      topBar: _AdminTopBar(
        title: 'Treasurer Hub',
        leadingIcon: Icons.menu_rounded,
        onLeadingTap: () =>
            _openAdminMenu(context, AppPage.adminTreasurerDashboard),
      ),
      child: FutureBuilder<_TreasurerDashboardData>(
        future: _TreasurerDashboardData.load(repository),
        builder: (context, snapshot) {
          final data = snapshot.data;
          final metrics = data?.metrics;
          final summary = data?.summary ?? const <Map<String, dynamic>>[];
          final vendors = data?.vendors ?? const <Map<String, dynamic>>[];
          final expenses = data?.expenses ?? const <Map<String, dynamic>>[];

          return _AdminBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cashflow, vendor health, and contracts in one place.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: _AdminPalette.muted),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _AdminMetricTile(
                      icon: Icons.storefront_rounded,
                      label: 'Total Vendors',
                      value: _formatMetricValue(metrics?['total_vendors']),
                    ),
                    _AdminMetricTile(
                      icon: Icons.verified_user_rounded,
                      label: 'Active Contracts',
                      value: _formatMetricValue(metrics?['active_contracts']),
                    ),
                    _AdminMetricTile(
                      icon: Icons.warning_amber_rounded,
                      label: 'Expiring Soon',
                      value: _formatMetricValue(metrics?['expiring_contracts']),
                    ),
                    _AdminMetricTile(
                      icon: Icons.currency_rupee_rounded,
                      label: 'Monthly Spend',
                      value: _compactCurrency(metrics?['monthly_expenses']),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _AdminSectionHeading(title: 'Quick Actions'),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _AdminQuickActionButton(
                        icon: Icons.store_mall_directory_rounded,
                        label: 'Vendors',
                        emphasized: true,
                        onTap: () =>
                            goToPage(context, AppPage.adminTreasurerVendors),
                      ),
                      const SizedBox(width: 10),
                      _AdminQuickActionButton(
                        icon: Icons.add_card_rounded,
                        label: 'Add Vendor',
                        onTap: () =>
                            goToPage(context, AppPage.adminTreasurerAddVendor),
                      ),
                      const SizedBox(width: 10),
                      _AdminQuickActionButton(
                        icon: Icons.receipt_long_rounded,
                        label: 'Expenses',
                        onTap: () =>
                            goToPage(context, AppPage.adminTreasurerExpenses),
                      ),
                      const SizedBox(width: 10),
                      _AdminQuickActionButton(
                        icon: Icons.request_quote_rounded,
                        label: 'RFQ',
                        onTap: () => goToPage(
                          context,
                          AppPage.adminTreasurerQuotationRequest,
                        ),
                      ),
                      const SizedBox(width: 10),
                      _AdminQuickActionButton(
                        icon: Icons.analytics_rounded,
                        label: 'Analysis',
                        onTap: () =>
                            goToPage(context, AppPage.adminTreasurerAnalysis),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _AdminGlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Income vs Expense',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 18),
                        if (snapshot.connectionState != ConnectionState.done)
                          const _AdminEmptyState(
                            label: 'Loading financial summary...',
                          )
                        else if (summary.isEmpty)
                          const _AdminEmptyState(
                            label: 'No monthly financial data available yet.',
                          )
                        else
                          ...summary
                              .take(4)
                              .map(
                                (row) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _MiniFinanceBar(row: row),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _AdminSectionHeading(title: 'Recent Expenses'),
                const SizedBox(height: 12),
                if (snapshot.connectionState != ConnectionState.done)
                  const _AdminEmptyState(label: 'Loading expenses...')
                else if (expenses.isEmpty)
                  const _AdminEmptyState(label: 'No expense records yet.')
                else
                  ...expenses
                      .take(4)
                      .map(
                        (expense) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _AdminGlassCard(
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: _AdminPalette.surfaceLow,
                                child: const Icon(
                                  Icons.receipt_long_rounded,
                                  color: AvenueColors.primary,
                                ),
                              ),
                              title: Text(
                                expense['category']?.toString() ?? 'Expense',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Text(
                                '${expense['vendor_name'] ?? 'General vendor'} • ${expense['description'] ?? 'Recorded expense'}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    _compactCurrency(expense['amount']),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(height: 4),
                                  _AdminTag(
                                    label:
                                        expense['approval_status']
                                            ?.toString()
                                            .toUpperCase() ??
                                        'LOGGED',
                                    background: _expenseStatusColor(
                                      expense['approval_status'] as String?,
                                    ).withValues(alpha: 0.14),
                                    foreground: _expenseStatusColor(
                                      expense['approval_status'] as String?,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 24),
                _AdminSectionHeading(title: 'Top Vendors'),
                const SizedBox(height: 12),
                if (snapshot.connectionState != ConnectionState.done)
                  const _AdminEmptyState(label: 'Loading vendors...')
                else if (vendors.isEmpty)
                  const _AdminEmptyState(label: 'No vendors have been added.')
                else
                  ...vendors
                      .take(3)
                      .map(
                        (vendor) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _VendorListCard(
                            vendor: vendor,
                            onTap: () => Navigator.of(context).pushNamed(
                              AppPage.adminTreasurerContractRenewal.routeName,
                              arguments: {'vendorId': vendor['vendor_id']},
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

class AdminVendorManagementScreen extends StatelessWidget {
  const AdminVendorManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();
    return _AdminScaffold(
      currentPage: AppPage.adminTreasurerVendors,
      topBar: _AdminTopBar(
        title: 'Vendor Ecosystem',
        leadingIcon: Icons.arrow_back_rounded,
        onLeadingTap: () => _goBackOrAdminHome(context),
      ),
      child: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          repository.fetchTreasurerDashboardMetrics(),
          repository.fetchFinanceVendors(),
        ]),
        builder: (context, snapshot) {
          final metricRows = snapshot.data != null && snapshot.data!.isNotEmpty
              ? snapshot.data!.first as List<Map<String, dynamic>>
              : null;
          final metrics = metricRows == null || metricRows.isEmpty
              ? null
              : metricRows.first;
          final vendors = snapshot.data == null || snapshot.data!.length < 2
              ? const <Map<String, dynamic>>[]
              : snapshot.data![1] as List<Map<String, dynamic>>;

          return _AdminBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _AdminMetricTile(
                      icon: Icons.groups_rounded,
                      label: 'Total Vendors',
                      value: _formatMetricValue(metrics?['total_vendors']),
                    ),
                    _AdminMetricTile(
                      icon: Icons.assignment_turned_in_rounded,
                      label: 'Active Contracts',
                      value: _formatMetricValue(metrics?['active_contracts']),
                    ),
                    _AdminMetricTile(
                      icon: Icons.alarm_on_rounded,
                      label: 'Expiring Contracts',
                      value: _formatMetricValue(metrics?['expiring_contracts']),
                    ),
                    _AdminMetricTile(
                      icon: Icons.payments_rounded,
                      label: 'Vendor Payroll',
                      value: _compactCurrency(metrics?['vendor_payroll']),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _AdminGlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _TreasurerActionTile(
                            title: 'Compare Vendors',
                            subtitle: 'See quotations side by side',
                            icon: Icons.compare_arrows_rounded,
                            onTap: () => goToPage(
                              context,
                              AppPage.adminTreasurerVendorComparison,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _TreasurerActionTile(
                            title: 'Request RFQ',
                            subtitle: 'Invite fresh quotes',
                            icon: Icons.request_quote_rounded,
                            onTap: () => goToPage(
                              context,
                              AppPage.adminTreasurerQuotationRequest,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _AdminSectionHeading(title: 'Vendor List'),
                const SizedBox(height: 12),
                if (snapshot.connectionState != ConnectionState.done)
                  const _AdminEmptyState(label: 'Loading vendor directory...')
                else if (vendors.isEmpty)
                  const _AdminEmptyState(
                    label: 'No vendors in the registry yet.',
                  )
                else
                  ...vendors.map(
                    (vendor) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _VendorListCard(
                        vendor: vendor,
                        onTap: () => Navigator.of(context).pushNamed(
                          AppPage.adminTreasurerContractRenewal.routeName,
                          arguments: {'vendorId': vendor['vendor_id']},
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => goToPage(context, AppPage.adminTreasurerAddVendor),
        backgroundColor: AvenueColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Vendor'),
      ),
    );
  }
}

class AdminAddVendorScreen extends StatefulWidget {
  const AdminAddVendorScreen({super.key});

  @override
  State<AdminAddVendorScreen> createState() => _AdminAddVendorScreenState();
}
