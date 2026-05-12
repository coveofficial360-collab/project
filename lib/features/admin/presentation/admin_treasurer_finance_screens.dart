part of 'admin_screens.dart';

class AdminExpensesManagementScreen extends StatefulWidget {
  const AdminExpensesManagementScreen({super.key});

  @override
  State<AdminExpensesManagementScreen> createState() =>
      _AdminExpensesManagementScreenState();
}

class AdminFinancialAnalysisScreen extends StatelessWidget {
  const AdminFinancialAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AdminScaffold(
      currentPage: AppPage.adminTreasurerAnalysis,
      topBar: _AdminTopBar(
        title: 'Analysis Overview',
        leadingIcon: Icons.arrow_back_rounded,
        onLeadingTap: () => _goBackOrAdminHome(context),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: AvenueRepository().fetchFinancialMonthlySummary(),
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          final totalIncome = rows.fold<double>(
            0,
            (sum, row) =>
                sum + (double.tryParse('${row['income_total'] ?? 0}') ?? 0),
          );
          final totalExpense = rows.fold<double>(
            0,
            (sum, row) =>
                sum + (double.tryParse('${row['expense_total'] ?? 0}') ?? 0),
          );

          return _AdminBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _AdminMetricTile(
                      icon: Icons.savings_rounded,
                      label: 'Total Income',
                      value: _compactCurrency(totalIncome),
                    ),
                    _AdminMetricTile(
                      icon: Icons.money_off_csred_rounded,
                      label: 'Total Expenses',
                      value: _compactCurrency(totalExpense),
                    ),
                    _AdminMetricTile(
                      icon: Icons.trending_up_rounded,
                      label: 'Net Position',
                      value: _compactCurrency(totalIncome - totalExpense),
                    ),
                  ],
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
                            label: 'Loading analysis overview...',
                          )
                        else if (rows.isEmpty)
                          const _AdminEmptyState(
                            label: 'No financial trend data yet.',
                          )
                        else
                          ...rows.map(
                            (row) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _MiniFinanceBar(row: row, showNet: true),
                            ),
                          ),
                      ],
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

class AdminRequestVendorQuotationScreen extends StatefulWidget {
  const AdminRequestVendorQuotationScreen({super.key});

  @override
  State<AdminRequestVendorQuotationScreen> createState() =>
      _AdminRequestVendorQuotationScreenState();
}

class AdminVendorComparisonScreen extends StatelessWidget {
  const AdminVendorComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AdminScaffold(
      currentPage: AppPage.adminTreasurerVendorComparison,
      topBar: _AdminTopBar(
        title: 'Vendor Comparison',
        leadingIcon: Icons.arrow_back_rounded,
        onLeadingTap: () => _goBackOrAdminHome(context),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: AvenueRepository().fetchVendorComparisonRows(),
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          return _AdminBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AdminGlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundColor: Color(0x1A005BBF),
                          child: Icon(
                            Icons.compare_arrows_rounded,
                            color: AvenueColors.primary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            '${rows.length} vendor quotation rows ready for review.',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (snapshot.connectionState != ConnectionState.done)
                  const _AdminEmptyState(label: 'Loading comparison matrix...')
                else if (rows.isEmpty)
                  const _AdminEmptyState(
                    label: 'No quotation requests have vendor responses yet.',
                  )
                else
                  ...rows.map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _AdminGlassCard(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      row['company_name']?.toString() ??
                                          'Vendor',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                  ),
                                  _AdminTag(
                                    label:
                                        row['service_type']
                                            ?.toString()
                                            .toUpperCase() ??
                                        'GENERAL',
                                    background: const Color(0x14005BBF),
                                    foreground: AvenueColors.primary,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                row['request_title']?.toString() ??
                                    'Quotation Request',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                children: [
                                  Text(
                                    'Quote: ${_compactCurrency(row['quoted_amount'])}',
                                  ),
                                  Text(
                                    'Staff: ${row['quoted_staff_count'] ?? '--'}',
                                  ),
                                  Text(
                                    'Rating: ${row['quality_rating'] ?? '--'}/5',
                                  ),
                                ],
                              ),
                              if ((row['notes']?.toString().trim().isNotEmpty ??
                                  false)) ...[
                                const SizedBox(height: 10),
                                Text(
                                  row['notes'].toString(),
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: _AdminPalette.muted),
                                ),
                              ],
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            goToPage(context, AppPage.adminTreasurerQuotationRequest),
        backgroundColor: AvenueColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.request_quote_rounded),
        label: const Text('Request Quotation'),
      ),
    );
  }
}

class AdminVendorContractRenewalScreen extends StatefulWidget {
  const AdminVendorContractRenewalScreen({super.key, this.vendorId});

  final String? vendorId;

  @override
  State<AdminVendorContractRenewalScreen> createState() =>
      _AdminVendorContractRenewalScreenState();
}
