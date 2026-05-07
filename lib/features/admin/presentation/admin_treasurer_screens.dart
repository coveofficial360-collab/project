part of 'admin_screens.dart';

Color _treasurerHealthColor(String? value) {
  switch (_normalize(value ?? '')) {
    case 'expiring':
      return _AdminPalette.warning;
    case 'renew':
      return _AdminPalette.danger;
    default:
      return _AdminPalette.success;
  }
}

Color _expenseStatusColor(String? value) {
  switch (_normalize(value ?? '')) {
    case 'approved':
      return _AdminPalette.success;
    case 'pending':
      return _AdminPalette.warning;
    default:
      return _AdminPalette.muted;
  }
}

String _compactCurrency(dynamic value) {
  final amount = double.tryParse(value?.toString() ?? '') ?? 0;
  if (amount >= 100000) {
    return '₹${(amount / 100000).toStringAsFixed(1)}L';
  }
  if (amount >= 1000) {
    return '₹${(amount / 1000).toStringAsFixed(1)}K';
  }
  return '₹${amount.toStringAsFixed(0)}';
}

String _treasurerDateLabel(dynamic value) {
  if (value == null) {
    return '-';
  }

  final parsed = value is DateTime
      ? value
      : DateTime.tryParse(value.toString());
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

  return '${parsed.day.toString().padLeft(2, '0')} ${months[parsed.month - 1]} ${parsed.year}';
}

class _TreasurerDashboardData {
  const _TreasurerDashboardData({
    required this.metrics,
    required this.summary,
    required this.vendors,
    required this.expenses,
  });

  final Map<String, dynamic>? metrics;
  final List<Map<String, dynamic>> summary;
  final List<Map<String, dynamic>> vendors;
  final List<Map<String, dynamic>> expenses;

  static Future<_TreasurerDashboardData> load(
    AvenueRepository repository,
  ) async {
    final results = await Future.wait([
      repository.fetchTreasurerDashboardMetrics(),
      repository.fetchFinancialMonthlySummary(),
      repository.fetchFinanceVendors(),
      repository.fetchTreasurerExpenses(),
    ]);

    final metricRows = results[0];
    return _TreasurerDashboardData(
      metrics: metricRows.isEmpty ? null : metricRows.first,
      summary: results[1],
      vendors: results[2],
      expenses: results[3],
    );
  }
}

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

class _AdminAddVendorScreenState extends State<AdminAddVendorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _contactController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _serviceScopeController = TextEditingController();
  final _monthlyCostController = TextEditingController(text: '0');
  final _staffCountController = TextEditingController(text: '0');
  final _notesController = TextEditingController();

  String _serviceType = 'Security';
  bool _saving = false;

  @override
  void dispose() {
    _companyController.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _serviceScopeController.dispose();
    _monthlyCostController.dispose();
    _staffCountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _saving) {
      return;
    }

    setState(() => _saving = true);
    try {
      await AvenueRepository().createFinanceVendor(
        companyName: _companyController.text,
        contactName: _contactController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        address: _addressController.text,
        serviceType: _serviceType,
        serviceScope: _serviceScopeController.text,
        monthlyCost: double.tryParse(_monthlyCostController.text.trim()) ?? 0,
        staffCount: int.tryParse(_staffCountController.text.trim()) ?? 0,
        notes: _notesController.text,
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vendor added to the treasurer registry.'),
        ),
      );
      goToPage(context, AppPage.adminTreasurerVendors, replace: true);
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not add vendor: $error')));
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _AdminScaffold(
      currentPage: AppPage.adminTreasurerAddVendor,
      topBar: _AdminTopBar(
        title: 'Add New Vendor',
        leadingIcon: Icons.arrow_back_rounded,
        onLeadingTap: () => _goBackOrAdminHome(context),
      ),
      child: _AdminBody(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Capture the core vendor profile, service scope, and contact details for finance tracking.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: _AdminPalette.muted),
              ),
              const SizedBox(height: 20),
              _AdminGlassCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _TreasurerTextField(
                        controller: _companyController,
                        label: 'Company Name',
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? 'Enter the company name'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      _TreasurerTextField(
                        controller: _contactController,
                        label: 'Contact Person',
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? 'Enter the primary contact'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      _TreasurerTextField(
                        controller: _phoneController,
                        label: 'Phone',
                        keyboardType: TextInputType.phone,
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? 'Enter a phone number'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      _TreasurerTextField(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        value: _serviceType,
                        decoration: _treasurerInputDecoration('Service Type'),
                        items: const [
                          DropdownMenuItem(
                            value: 'Security',
                            child: Text('Security'),
                          ),
                          DropdownMenuItem(
                            value: 'Housekeeping',
                            child: Text('Housekeeping'),
                          ),
                          DropdownMenuItem(
                            value: 'Landscape',
                            child: Text('Landscape'),
                          ),
                          DropdownMenuItem(
                            value: 'Maintenance',
                            child: Text('Maintenance'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _serviceType = value);
                          }
                        },
                      ),
                      const SizedBox(height: 14),
                      _TreasurerTextField(
                        controller: _serviceScopeController,
                        label: 'Service Scope',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _TreasurerTextField(
                              controller: _monthlyCostController,
                              label: 'Monthly Cost',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _TreasurerTextField(
                              controller: _staffCountController,
                              label: 'Staff Count',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _TreasurerTextField(
                        controller: _addressController,
                        label: 'Address',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 14),
                      _TreasurerTextField(
                        controller: _notesController,
                        label: 'Notes',
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saving ? null : _submit,
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_rounded),
                  label: Text(_saving ? 'Saving...' : 'Create Vendor'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AvenueColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
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

class AdminExpensesManagementScreen extends StatefulWidget {
  const AdminExpensesManagementScreen({super.key});

  @override
  State<AdminExpensesManagementScreen> createState() =>
      _AdminExpensesManagementScreenState();
}

class _AdminExpensesManagementScreenState
    extends State<AdminExpensesManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _vendorNameController = TextEditingController();
  DateTime _expenseDate = DateTime.now();
  String _category = 'Housekeeping';
  String _paymentMode = 'bank_transfer';
  String? _selectedVendorId;
  bool _saving = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _vendorNameController.dispose();
    super.dispose();
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate() || _saving) {
      return;
    }

    setState(() => _saving = true);
    try {
      await AvenueRepository().createTreasurerExpense(
        expenseDate: _expenseDate,
        category: _category,
        vendorId: _selectedVendorId,
        vendorName: _selectedVendorId == null
            ? _vendorNameController.text
            : null,
        amount: double.tryParse(_amountController.text.trim()) ?? 0,
        description: _descriptionController.text,
        paymentMode: _paymentMode,
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense recorded successfully.')),
      );
      setState(() {
        _amountController.clear();
        _descriptionController.clear();
        _vendorNameController.clear();
        _selectedVendorId = null;
        _expenseDate = DateTime.now();
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not save expense: $error')));
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();
    return _AdminScaffold(
      currentPage: AppPage.adminTreasurerExpenses,
      topBar: _AdminTopBar(
        title: 'Expenses Management',
        leadingIcon: Icons.arrow_back_rounded,
        onLeadingTap: () => _goBackOrAdminHome(context),
      ),
      child: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          repository.fetchTreasurerDashboardMetrics(),
          repository.fetchTreasurerExpenses(),
          repository.fetchFinanceVendors(),
        ]),
        builder: (context, snapshot) {
          final metricRows = snapshot.data != null && snapshot.data!.isNotEmpty
              ? snapshot.data!.first as List<Map<String, dynamic>>
              : null;
          final metrics = metricRows == null || metricRows.isEmpty
              ? null
              : metricRows.first;
          final expenses = snapshot.data == null || snapshot.data!.length < 2
              ? const <Map<String, dynamic>>[]
              : snapshot.data![1] as List<Map<String, dynamic>>;
          final vendors = snapshot.data == null || snapshot.data!.length < 3
              ? const <Map<String, dynamic>>[]
              : snapshot.data![2] as List<Map<String, dynamic>>;

          return _AdminBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _AdminMetricTile(
                      icon: Icons.account_balance_wallet_rounded,
                      label: 'This Month',
                      value: _compactCurrency(metrics?['monthly_expenses']),
                    ),
                    _AdminMetricTile(
                      icon: Icons.task_alt_rounded,
                      label: 'Approved',
                      value: _compactCurrency(metrics?['approved_expenses']),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _AdminGlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Record New Expense',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedVendorId,
                            decoration: _treasurerInputDecoration('Vendor'),
                            items: [
                              const DropdownMenuItem<String>(
                                value: null,
                                child: Text('Manual vendor entry'),
                              ),
                              ...vendors.map(
                                (vendor) => DropdownMenuItem<String>(
                                  value: vendor['vendor_id']?.toString(),
                                  child: Text(
                                    vendor['company_name']?.toString() ??
                                        'Vendor',
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() => _selectedVendorId = value);
                            },
                          ),
                          const SizedBox(height: 14),
                          if (_selectedVendorId == null)
                            Column(
                              children: [
                                _TreasurerTextField(
                                  controller: _vendorNameController,
                                  label: 'Vendor Name',
                                ),
                                const SizedBox(height: 14),
                              ],
                            ),
                          DropdownButtonFormField<String>(
                            value: _category,
                            decoration: _treasurerInputDecoration('Category'),
                            items: const [
                              DropdownMenuItem(
                                value: 'Housekeeping',
                                child: Text('Housekeeping'),
                              ),
                              DropdownMenuItem(
                                value: 'Security',
                                child: Text('Security'),
                              ),
                              DropdownMenuItem(
                                value: 'Landscape',
                                child: Text('Landscape'),
                              ),
                              DropdownMenuItem(
                                value: 'Utilities',
                                child: Text('Utilities'),
                              ),
                              DropdownMenuItem(
                                value: 'Maintenance',
                                child: Text('Maintenance'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _category = value);
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: _TreasurerTextField(
                                  controller: _amountController,
                                  label: 'Amount',
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  validator: (value) =>
                                      (double.tryParse(value?.trim() ?? '') ??
                                              0) <=
                                          0
                                      ? 'Enter a valid amount'
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _paymentMode,
                                  decoration: _treasurerInputDecoration(
                                    'Payment Mode',
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'bank_transfer',
                                      child: Text('Bank Transfer'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'upi',
                                      child: Text('UPI'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'cash',
                                      child: Text('Cash'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => _paymentMode = value);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Expense Date'),
                            subtitle: Text(_treasurerDateLabel(_expenseDate)),
                            trailing: const Icon(Icons.calendar_today_rounded),
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _expenseDate,
                                firstDate: DateTime(2023),
                                lastDate: DateTime(2030),
                              );
                              if (picked != null) {
                                setState(() => _expenseDate = picked);
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          _TreasurerTextField(
                            controller: _descriptionController,
                            label: 'Description',
                            maxLines: 3,
                            validator: (value) =>
                                (value == null || value.trim().isEmpty)
                                ? 'Add a short description'
                                : null,
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _saving ? null : _saveExpense,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AvenueColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                _saving ? 'Saving...' : 'Save Expense Entry',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _AdminSectionHeading(title: 'Expense Log'),
                const SizedBox(height: 12),
                if (snapshot.connectionState != ConnectionState.done)
                  const _AdminEmptyState(label: 'Loading expense log...')
                else if (expenses.isEmpty)
                  const _AdminEmptyState(label: 'No expenses logged yet.')
                else
                  ...expenses.map(
                    (expense) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _AdminGlassCard(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
                          ),
                          title: Text(
                            expense['description']?.toString() ?? 'Expense',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            '${expense['vendor_name'] ?? 'General'} • ${_treasurerDateLabel(expense['expense_date'])}',
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _compactCurrency(expense['amount']),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
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
              ],
            ),
          );
        },
      ),
    );
  }
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

class _AdminRequestVendorQuotationScreenState
    extends State<AdminRequestVendorQuotationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _budgetController = TextEditingController();
  final _durationController = TextEditingController(text: '12 months');
  final _staffController = TextEditingController(text: '4');
  final _requirementsController = TextEditingController();

  String _serviceType = 'Security';
  DateTime? _startDate = DateTime.now().add(const Duration(days: 14));
  final Set<String> _selectedVendorIds = <String>{};
  bool _sending = false;

  @override
  void dispose() {
    _titleController.dispose();
    _budgetController.dispose();
    _durationController.dispose();
    _staffController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() ||
        _selectedVendorIds.isEmpty ||
        _sending) {
      if (_selectedVendorIds.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Select at least one vendor.')),
        );
      }
      return;
    }

    setState(() => _sending = true);
    try {
      await AvenueRepository().createVendorQuotationRequest(
        requestTitle: _titleController.text,
        serviceType: _serviceType,
        requestedStartDate: _startDate,
        contractDuration: _durationController.text,
        estimatedBudget: double.tryParse(_budgetController.text.trim()),
        staffRequired: int.tryParse(_staffController.text.trim()),
        requirements: _requirementsController.text,
        vendorIds: _selectedVendorIds.toList(),
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quotation request sent to vendors.')),
      );
      goToPage(context, AppPage.adminTreasurerVendorComparison, replace: true);
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not send RFQ: $error')));
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _AdminScaffold(
      currentPage: AppPage.adminTreasurerQuotationRequest,
      topBar: _AdminTopBar(
        title: 'Request Vendor Quotation',
        leadingIcon: Icons.arrow_back_rounded,
        onLeadingTap: () => _goBackOrAdminHome(context),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: AvenueRepository().fetchFinanceVendors(),
        builder: (context, snapshot) {
          final vendors = snapshot.data ?? const <Map<String, dynamic>>[];
          return _AdminBody(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AdminGlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _TreasurerTextField(
                            controller: _titleController,
                            label: 'Request Title',
                            validator: (value) =>
                                (value == null || value.trim().isEmpty)
                                ? 'Enter a request title'
                                : null,
                          ),
                          const SizedBox(height: 14),
                          DropdownButtonFormField<String>(
                            value: _serviceType,
                            decoration: _treasurerInputDecoration(
                              'Service Type',
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Security',
                                child: Text('Security'),
                              ),
                              DropdownMenuItem(
                                value: 'Housekeeping',
                                child: Text('Housekeeping'),
                              ),
                              DropdownMenuItem(
                                value: 'Landscape',
                                child: Text('Landscape'),
                              ),
                              DropdownMenuItem(
                                value: 'Maintenance',
                                child: Text('Maintenance'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _serviceType = value);
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: _TreasurerTextField(
                                  controller: _budgetController,
                                  label: 'Estimated Budget',
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _TreasurerTextField(
                                  controller: _staffController,
                                  label: 'Staff Required',
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _TreasurerTextField(
                            controller: _durationController,
                            label: 'Contract Duration',
                          ),
                          const SizedBox(height: 14),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Requested Start Date'),
                            subtitle: Text(_treasurerDateLabel(_startDate)),
                            trailing: const Icon(Icons.calendar_today_rounded),
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _startDate ?? DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2030),
                              );
                              if (picked != null) {
                                setState(() => _startDate = picked);
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                          _TreasurerTextField(
                            controller: _requirementsController,
                            label: 'Requirements',
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _AdminSectionHeading(
                    title: 'Vendor Selection (${_selectedVendorIds.length})',
                  ),
                  const SizedBox(height: 12),
                  if (snapshot.connectionState != ConnectionState.done)
                    const _AdminEmptyState(label: 'Loading vendor shortlist...')
                  else if (vendors.isEmpty)
                    const _AdminEmptyState(
                      label: 'No vendors available for quotation requests.',
                    )
                  else
                    ...vendors.map((vendor) {
                      final vendorId = vendor['vendor_id']?.toString() ?? '';
                      final selected = _selectedVendorIds.contains(vendorId);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (selected) {
                                _selectedVendorIds.remove(vendorId);
                              } else {
                                _selectedVendorIds.add(vendorId);
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(24),
                          child: _VendorListCard(
                            vendor: vendor,
                            selected: selected,
                          ),
                        ),
                      );
                    }),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _sending ? null : _submit,
                      icon: const Icon(Icons.send_rounded),
                      label: Text(
                        _sending ? 'Sending...' : 'Send RFQ to Vendors',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AvenueColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
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

class _AdminVendorContractRenewalScreenState
    extends State<AdminVendorContractRenewalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _monthlyAmountController = TextEditingController();
  final _termsController = TextEditingController();
  final _slaController = TextEditingController();

  String? _selectedVendorId;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 365));
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selectedVendorId = widget.vendorId;
  }

  @override
  void dispose() {
    _monthlyAmountController.dispose();
    _termsController.dispose();
    _slaController.dispose();
    super.dispose();
  }

  Future<void> _renew() async {
    if (!_formKey.currentState!.validate() ||
        _selectedVendorId == null ||
        _saving) {
      return;
    }

    setState(() => _saving = true);
    try {
      await AvenueRepository().renewFinanceVendorContract(
        vendorId: _selectedVendorId!,
        startDate: _startDate,
        endDate: _endDate,
        monthlyAmount:
            double.tryParse(_monthlyAmountController.text.trim()) ?? 0,
        termsSummary: _termsController.text,
        slaSummary: _slaController.text,
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vendor contract renewed successfully.')),
      );
      goToPage(context, AppPage.adminTreasurerVendors, replace: true);
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not renew contract: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();
    return _AdminScaffold(
      currentPage: AppPage.adminTreasurerContractRenewal,
      topBar: _AdminTopBar(
        title: 'Vendor Contract Renewal',
        leadingIcon: Icons.arrow_back_rounded,
        onLeadingTap: () => _goBackOrAdminHome(context),
      ),
      child: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          repository.fetchFinanceVendors(),
          if (_selectedVendorId != null)
            repository.fetchVendorContractHistory(_selectedVendorId!)
          else
            Future.value(const <Map<String, dynamic>>[]),
        ]),
        builder: (context, snapshot) {
          final vendors = snapshot.data == null || snapshot.data!.isEmpty
              ? const <Map<String, dynamic>>[]
              : snapshot.data!.first as List<Map<String, dynamic>>;
          final history = snapshot.data == null || snapshot.data!.length < 2
              ? const <Map<String, dynamic>>[]
              : snapshot.data![1] as List<Map<String, dynamic>>;

          return _AdminBody(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedVendorId,
                    decoration: _treasurerInputDecoration('Vendor'),
                    items: vendors
                        .map(
                          (vendor) => DropdownMenuItem<String>(
                            value: vendor['vendor_id']?.toString(),
                            child: Text(
                              vendor['company_name']?.toString() ?? 'Vendor',
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => _selectedVendorId = value);
                    },
                  ),
                  const SizedBox(height: 18),
                  _AdminGlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text('Start Date'),
                                  subtitle: Text(
                                    _treasurerDateLabel(_startDate),
                                  ),
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: _startDate,
                                      firstDate: DateTime(2023),
                                      lastDate: DateTime(2030),
                                    );
                                    if (picked != null) {
                                      setState(() => _startDate = picked);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text('End Date'),
                                  subtitle: Text(_treasurerDateLabel(_endDate)),
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: _endDate,
                                      firstDate: DateTime(2023),
                                      lastDate: DateTime(2032),
                                    );
                                    if (picked != null) {
                                      setState(() => _endDate = picked);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _TreasurerTextField(
                            controller: _monthlyAmountController,
                            label: 'Renewed Monthly Amount',
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (value) =>
                                (double.tryParse(value?.trim() ?? '') ?? 0) <= 0
                                ? 'Enter a valid monthly amount'
                                : null,
                          ),
                          const SizedBox(height: 14),
                          _TreasurerTextField(
                            controller: _termsController,
                            label: 'Terms Summary',
                            maxLines: 3,
                          ),
                          const SizedBox(height: 14),
                          _TreasurerTextField(
                            controller: _slaController,
                            label: 'SLA Summary',
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _AdminSectionHeading(title: 'Contract History'),
                  const SizedBox(height: 12),
                  if (_selectedVendorId == null)
                    const _AdminEmptyState(
                      label: 'Select a vendor to view history.',
                    )
                  else if (snapshot.connectionState != ConnectionState.done)
                    const _AdminEmptyState(label: 'Loading contract history...')
                  else if (history.isEmpty)
                    const _AdminEmptyState(
                      label: 'No contract history recorded yet.',
                    )
                  else
                    ...history.map(
                      (row) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _AdminGlassCard(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),
                            title: Text(
                              '${_treasurerDateLabel(row['contract_start_date'])} - ${_treasurerDateLabel(row['contract_end_date'])}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Text(
                              row['terms_summary']
                                          ?.toString()
                                          .trim()
                                          .isNotEmpty ==
                                      true
                                  ? row['terms_summary'].toString()
                                  : 'Previous contract revision',
                            ),
                            trailing: Text(
                              _compactCurrency(row['monthly_amount']),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saving ? null : _renew,
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(_saving ? 'Renewing...' : 'Renew Contract'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AvenueColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _VendorListCard extends StatelessWidget {
  const _VendorListCard({
    required this.vendor,
    this.onTap,
    this.selected = false,
  });

  final Map<String, dynamic> vendor;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final health = vendor['contract_health']?.toString();
    final companyName = vendor['company_name']?.toString() ?? 'Vendor';
    final type = vendor['service_type']?.toString() ?? 'General';
    return _AdminGlassCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          decoration: selected
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AvenueColors.primary, width: 1.4),
                )
              : null,
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      companyName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _AdminTag(
                    label: type.toUpperCase(),
                    background: const Color(0x14005BBF),
                    foreground: AvenueColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  Text('Contact: ${vendor['contact_name'] ?? '--'}'),
                  Text('Staff: ${vendor['staff_count'] ?? '--'}'),
                  Text('Monthly: ${_compactCurrency(vendor['monthly_cost'])}'),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _AdminTag(
                    label: (health ?? 'healthy').toUpperCase(),
                    background: _treasurerHealthColor(
                      health,
                    ).withValues(alpha: 0.14),
                    foreground: _treasurerHealthColor(health),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    vendor['onboarding_status']?.toString().toUpperCase() ??
                        'ACTIVE',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _AdminPalette.muted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniFinanceBar extends StatelessWidget {
  const _MiniFinanceBar({required this.row, this.showNet = false});

  final Map<String, dynamic> row;
  final bool showNet;

  @override
  Widget build(BuildContext context) {
    final income = double.tryParse('${row['income_total'] ?? 0}') ?? 0;
    final expense = double.tryParse('${row['expense_total'] ?? 0}') ?? 0;
    final peak = [income, expense, 1.0].reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                _treasurerDateLabel(row['month_bucket']),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            if (showNet)
              Text(
                'Net ${_compactCurrency(row['net_total'])}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _AdminPalette.muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Row(
            children: [
              Expanded(
                flex: ((income / peak) * 100).round().clamp(1, 100),
                child: Container(height: 10, color: AvenueColors.primary),
              ),
              Expanded(
                flex: ((expense / peak) * 100).round().clamp(1, 100),
                child: Container(height: 10, color: const Color(0xFFE28039)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: Text('Income ${_compactCurrency(income)}')),
            Expanded(
              child: Text(
                'Expense ${_compactCurrency(expense)}',
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TreasurerActionTile extends StatelessWidget {
  const _TreasurerActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _AdminPalette.surfaceLow,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AvenueColors.primary),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: _AdminPalette.muted),
            ),
          ],
        ),
      ),
    );
  }
}

InputDecoration _treasurerInputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: _AdminPalette.outline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: _AdminPalette.outline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: AvenueColors.primary, width: 1.4),
    ),
  );
}

class _TreasurerTextField extends StatelessWidget {
  const _TreasurerTextField({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: _treasurerInputDecoration(label),
    );
  }
}
