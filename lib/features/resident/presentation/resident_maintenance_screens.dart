import 'package:flutter/material.dart';

import '../../../app/app_page.dart';
import '../../../core/supabase/avenue_repository.dart';
import '../../../theme/avenue_theme.dart';
import '../../common/presentation/avenue_ui.dart';

class ResidentMaintenanceDashboardScreen extends StatelessWidget {
  const ResidentMaintenanceDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();

    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Maintenance',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
        actions: [
          AvenueIconButton(
            icon: Icons.history_rounded,
            onPressed: () =>
                goToPage(context, AppPage.maintenanceHistory, replace: false),
            size: 40,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: FutureBuilder<_ResidentMaintenanceData>(
        future: _ResidentMaintenanceData.load(repository),
        builder: (context, snapshot) {
          final data = snapshot.data;
          final maintenanceBills = data?.maintenanceBills ?? const [];
          final maintenanceActivity = data?.maintenanceActivity ?? const [];
          final activeBill =
              maintenanceBills.where((row) => row['state'] != 'paid').isNotEmpty
              ? maintenanceBills.firstWhere((row) => row['state'] != 'paid')
              : (maintenanceBills.isNotEmpty ? maintenanceBills.first : null);

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvenueCard(
                  radius: 30,
                  color: AvenueColors.primary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Due',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.82),
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _currencyLabel(activeBill?['amount_due']),
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        activeBill?['due_date'] == null
                            ? 'No due date available'
                            : 'Due by ${_dateLabel(activeBill?['due_date'])}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: AvenuePrimaryButton(
                              label: 'Pay Now',
                              onPressed: activeBill == null
                                  ? () {}
                                  : () {
                                      Navigator.of(context).pushNamed(
                                        AppPage.maintenancePay.routeName,
                                        arguments: {'bill': activeBill},
                                      );
                                    },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AvenueSecondaryButton(
                              label: 'View Invoice',
                              onPressed: activeBill == null
                                  ? () {}
                                  : () {
                                      Navigator.of(context).pushNamed(
                                        AppPage.maintenanceInvoice.routeName,
                                        arguments: {'bill': activeBill},
                                      );
                                    },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                AvenueCard(
                  radius: 24,
                  color: AvenueColors.surfaceLow,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Information',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        label: 'Invoice',
                        value: (activeBill?['code'] as String?) ?? '-',
                      ),
                      _InfoRow(
                        label: 'Status',
                        value: ((activeBill?['state'] as String?) ?? 'due')
                            .replaceAll('_', ' ')
                            .toUpperCase(),
                      ),
                      _InfoRow(
                        label: 'Last Paid On',
                        value: _dateLabel(activeBill?['last_paid_on']),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                AvenueSectionHeader(
                  title: 'Recent Payments',
                  actionLabel: 'View All',
                  onActionTap: () =>
                      goToPage(context, AppPage.maintenanceHistory),
                ),
                const SizedBox(height: 10),
                if (snapshot.connectionState != ConnectionState.done &&
                    maintenanceBills.isEmpty)
                  const AvenueCard(
                    radius: 18,
                    child: AvenueSkeletonBlock(height: 120, radius: 16),
                  )
                else if (maintenanceActivity.isEmpty)
                  const AvenueCard(
                    radius: 18,
                    child: Text('No maintenance payments yet.'),
                  )
                else
                  ...maintenanceActivity.take(3).map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: AvenueCard(
                        radius: 18,
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0x14005BBF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.check_circle_rounded,
                                color: AvenueColors.primary,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (row['activity_title'] as String?) ??
                                        'Maintenance Payment',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _dateTimeLabel(row['activity_at']),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AvenueColors.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              _currencyLabel(row['amount']),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ],
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
            page: AppPage.home,
          ),
          AvenueNavItem(
            label: 'MAINT',
            icon: Icons.receipt_long_outlined,
            page: AppPage.bills,
          ),
          AvenueNavItem(
            label: 'NOTICES',
            icon: Icons.campaign_outlined,
            page: AppPage.notices,
          ),
          AvenueNavItem(
            label: 'PROFILE',
            icon: Icons.person_outline_rounded,
            page: AppPage.profile,
          ),
        ],
        currentPage: AppPage.bills,
      ),
    );
  }
}

class ResidentMaintenanceInvoiceScreen extends StatelessWidget {
  const ResidentMaintenanceInvoiceScreen({super.key, this.bill});

  final Map<String, dynamic>? bill;

  @override
  Widget build(BuildContext context) {
    final billRow = bill ?? const <String, dynamic>{};
    final status = ((billRow['state'] as String?) ?? 'due').toLowerCase();
    final isPaid = status == 'paid';

    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Invoice',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => Navigator.of(context).pop(),
          size: 40,
        ),
        actions: const [SizedBox(width: 12)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
        child: AvenueCard(
          radius: 28,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cove RWA',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              _StatusChip(label: isPaid ? 'Paid' : 'Pending', paid: isPaid),
              const SizedBox(height: 14),
              _InfoRow(label: 'Invoice No', value: billRow['code']?.toString() ?? '-'),
              _InfoRow(label: 'Bill Title', value: billRow['title']?.toString() ?? '-'),
              _InfoRow(label: 'Due Date', value: _dateLabel(billRow['due_date'])),
              _InfoRow(label: 'Amount', value: _currencyLabel(billRow['amount_due'])),
              _InfoRow(
                label: 'Paid On',
                value: _dateLabel(billRow['last_paid_on']),
              ),
              const SizedBox(height: 20),
              AvenuePrimaryButton(
                label: 'Download Invoice',
                icon: Icons.download_rounded,
                onPressed: () => showAvenueDialogMessage(
                  context,
                  type: AvenueMessageType.info,
                  message:
                      'Invoice download is queued. Connect export storage when ready.',
                ),
              ),
              const SizedBox(height: 10),
              AvenueSecondaryButton(
                label: 'Share Invoice',
                icon: Icons.ios_share_rounded,
                onPressed: () => showAvenueDialogMessage(
                  context,
                  type: AvenueMessageType.info,
                  message: 'Sharing support can be enabled from this screen.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResidentMaintenancePayScreen extends StatefulWidget {
  const ResidentMaintenancePayScreen({super.key, this.bill});

  final Map<String, dynamic>? bill;

  @override
  State<ResidentMaintenancePayScreen> createState() =>
      _ResidentMaintenancePayScreenState();
}

class _ResidentMaintenancePayScreenState
    extends State<ResidentMaintenancePayScreen> {
  final AvenueRepository _repository = AvenueRepository();
  String _method = 'UPI';
  bool _isPaying = false;

  @override
  Widget build(BuildContext context) {
    final bill = widget.bill ?? const <String, dynamic>{};
    final billId = bill['id']?.toString();

    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Pay Maintenance',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => Navigator.of(context).pop(),
          size: 40,
        ),
        actions: const [SizedBox(width: 12)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AvenueCard(
              radius: 26,
              color: AvenueColors.surfaceLow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Breakdown for ${_monthYearLabel(bill['due_date'])}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    label: 'Maintenance Fee',
                    value: _currencyLabel(bill['amount_due']),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Select Payment Method',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ChoiceChip(
                  label: 'UPI Apps',
                  selected: _method == 'UPI',
                  onTap: () => setState(() => _method = 'UPI'),
                ),
                _ChoiceChip(
                  label: 'Card',
                  selected: _method == 'Card',
                  onTap: () => setState(() => _method = 'Card'),
                ),
                _ChoiceChip(
                  label: 'Net Banking',
                  selected: _method == 'Net Banking',
                  onTap: () => setState(() => _method = 'Net Banking'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            AvenuePrimaryButton(
              label: _isPaying
                  ? 'Processing...'
                  : 'Proceed to Pay ${_currencyLabel(bill['amount_due'])}',
              icon: Icons.lock_rounded,
              onPressed: _isPaying || billId == null
                  ? () {}
                  : () => _pay(billId, bill),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pay(String billId, Map<String, dynamic> bill) async {
    setState(() => _isPaying = true);
    try {
      final result = await _repository.payMaintenanceBill(
        billId: billId,
        paymentMethod: _method,
      );
      if (!mounted) {
        return;
      }
      if (result == null) {
        await showAvenueDialogMessage(
          context,
          type: AvenueMessageType.error,
          message: 'Could not complete payment right now.',
        );
        return;
      }
      Navigator.of(context).pushReplacementNamed(
        AppPage.maintenancePaymentSuccess.routeName,
        arguments: {
          'amount': result['amount_paid'] ?? bill['amount_due'],
          'billCode': result['bill_code'] ?? bill['code'],
        },
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      await showAvenueDialogMessage(
        context,
        type: AvenueMessageType.error,
        message: error.toString(),
      );
    } finally {
      if (mounted) {
        setState(() => _isPaying = false);
      }
    }
  }
}

class ResidentMaintenanceHistoryScreen extends StatefulWidget {
  const ResidentMaintenanceHistoryScreen({super.key});

  @override
  State<ResidentMaintenanceHistoryScreen> createState() =>
      _ResidentMaintenanceHistoryScreenState();
}

class _ResidentMaintenanceHistoryScreenState
    extends State<ResidentMaintenanceHistoryScreen> {
  final AvenueRepository _repository = AvenueRepository();
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Payment History',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => Navigator.of(context).pop(),
          size: 40,
        ),
        actions: const [SizedBox(width: 12)],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _repository.fetchCurrentUserMaintenanceBills(),
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          final visible = rows.where((row) {
            if (_filter == 'all') {
              return true;
            }
            final status = _billStatus(row);
            return status == _filter;
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _FilterChip(
                      label: 'All',
                      selected: _filter == 'all',
                      onTap: () => setState(() => _filter = 'all'),
                    ),
                    _FilterChip(
                      label: 'Paid',
                      selected: _filter == 'paid',
                      onTap: () => setState(() => _filter = 'paid'),
                    ),
                    _FilterChip(
                      label: 'Pending',
                      selected: _filter == 'pending',
                      onTap: () => setState(() => _filter = 'pending'),
                    ),
                    _FilterChip(
                      label: 'Overdue',
                      selected: _filter == 'overdue',
                      onTap: () => setState(() => _filter = 'overdue'),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (snapshot.connectionState != ConnectionState.done &&
                    rows.isEmpty)
                  const AvenueCard(
                    radius: 16,
                    child: AvenueSkeletonBlock(height: 140, radius: 14),
                  )
                else if (visible.isEmpty)
                  const AvenueCard(
                    radius: 16,
                    child: Text('No payments found for selected filter.'),
                  )
                else
                  ...visible.map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: AvenueCard(
                        radius: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    row['title']?.toString() ??
                                        'Maintenance Payment',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                ),
                                _StatusChip(
                                  label: _billStatus(row).toUpperCase(),
                                  paid: _billStatus(row) == 'paid',
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              row['code']?.toString() ?? '-',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AvenueColors.onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Due ${_dateLabel(row['due_date'])}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _currencyLabel(
                                row['amount_paid'] ?? row['amount_due'],
                              ),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: AvenueSecondaryButton(
                        label: 'Export PDF',
                        icon: Icons.picture_as_pdf_rounded,
                        onPressed: () => showAvenueDialogMessage(
                          context,
                          type: AvenueMessageType.info,
                          message:
                              'PDF export can be connected to your file service.',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AvenuePrimaryButton(
                        label: 'Export CSV',
                        icon: Icons.table_chart_rounded,
                        onPressed: () => showAvenueDialogMessage(
                          context,
                          type: AvenueMessageType.success,
                          message:
                              'CSV export prepared from current maintenance data.',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ResidentMaintenancePaymentSuccessScreen extends StatelessWidget {
  const ResidentMaintenancePaymentSuccessScreen({
    required this.amount,
    required this.billCode,
    super.key,
  });

  final dynamic amount;
  final String billCode;

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: AvenueCard(
            radius: 30,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0x1A1F8E5A),
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF1F8E5A),
                    size: 52,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Payment Successful!',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  'Invoice: $billCode\nAmount: ${_currencyLabel(amount)}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AvenueColors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                AvenuePrimaryButton(
                  label: 'View Payment History',
                  onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    AppPage.maintenanceHistory.routeName,
                    (route) => route.settings.name == AppPage.home.routeName,
                  ),
                ),
                const SizedBox(height: 10),
                AvenueSecondaryButton(
                  label: 'Back to Maintenance',
                  onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    AppPage.bills.routeName,
                    (route) => route.settings.name == AppPage.home.routeName,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResidentMaintenanceData {
  const _ResidentMaintenanceData({
    required this.maintenanceBills,
    required this.maintenanceActivity,
  });

  final List<Map<String, dynamic>> maintenanceBills;
  final List<Map<String, dynamic>> maintenanceActivity;

  static Future<_ResidentMaintenanceData> load(AvenueRepository repository) async {
    final results = await Future.wait([
      repository.fetchCurrentUserMaintenanceBills(),
      repository.fetchCurrentUserPaymentActivity(),
    ]);

    final allActivity = List<Map<String, dynamic>>.from(results[1] as List);
    final maintenanceActivity = allActivity
        .where(
          (row) =>
              (row['activity_category']?.toString().toLowerCase() ?? '') ==
              'maintenance',
        )
        .toList();

    return _ResidentMaintenanceData(
      maintenanceBills: List<Map<String, dynamic>>.from(results[0] as List),
      maintenanceActivity: maintenanceActivity,
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AvenueColors.onSurfaceVariant),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AvenueColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? AvenueColors.primary
                : AvenueColors.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AvenueColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _FilterChip(label: label, selected: selected, onTap: onTap);
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.paid});

  final String label;
  final bool paid;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: paid ? const Color(0x1A1F8E5A) : const Color(0x1AD33B2C),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w800,
          color: paid ? const Color(0xFF1F8E5A) : const Color(0xFFD33B2C),
        ),
      ),
    );
  }
}

String _billStatus(Map<String, dynamic> row) {
  final state = (row['state']?.toString().toLowerCase() ?? 'due').trim();
  final dueDate = DateTime.tryParse(row['due_date']?.toString() ?? '');
  if (state == 'paid') {
    return 'paid';
  }
  if (dueDate != null && dueDate.isBefore(DateTime.now())) {
    return 'overdue';
  }

  return 'pending';
}

String _currencyLabel(dynamic amount) {
  final number = amount is num
      ? amount.toDouble()
      : double.tryParse(amount?.toString() ?? '') ?? 0;
  final absolute = number.abs();
  final isWhole = absolute == absolute.roundToDouble();
  final value = isWhole ? absolute.toStringAsFixed(0) : absolute.toStringAsFixed(2);
  return '₹$value';
}

String _dateLabel(dynamic value) {
  final parsed = DateTime.tryParse(value?.toString() ?? '');
  if (parsed == null) {
    return '-';
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
  final local = parsed.toLocal();
  return '${local.day.toString().padLeft(2, '0')} ${months[local.month - 1]} ${local.year}';
}

String _monthYearLabel(dynamic value) {
  final parsed = DateTime.tryParse(value?.toString() ?? '');
  if (parsed == null) {
    return 'Current Cycle';
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
  final local = parsed.toLocal();
  return '${months[local.month - 1]} ${local.year}';
}

String _dateTimeLabel(dynamic value) {
  final parsed = DateTime.tryParse(value?.toString() ?? '');
  if (parsed == null) {
    return '-';
  }
  final local = parsed.toLocal();
  final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
  final minute = local.minute.toString().padLeft(2, '0');
  final meridiem = local.hour >= 12 ? 'PM' : 'AM';
  return '${_dateLabel(local.toIso8601String())}, $hour:$minute $meridiem';
}
