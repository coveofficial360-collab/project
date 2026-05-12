part of 'resident_screens.dart';

class BillQuickPayScreen extends StatelessWidget {
  const BillQuickPayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Quick Pay',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
        actions: [
          AvenueIconButton(
            icon: Icons.history_rounded,
            onPressed: () => goToPage(context, AppPage.billTransactionHistory),
            size: 40,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: FutureBuilder<_BillsData>(
        future: _BillsData.load(repository),
        builder: (context, snapshot) {
          final bills = snapshot.data?.bills ?? const <Map<String, dynamic>>[];
          final unpaid = bills
              .where(
                (bill) =>
                    (bill['state']?.toString().toLowerCase() ?? '') != 'paid',
              )
              .toList();
          final totalDue = unpaid.fold<double>(
            0,
            (sum, bill) =>
                sum + (double.tryParse('${bill['amount_due'] ?? 0}') ?? 0),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0E4AAD), Color(0xFF2BB3C3)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Due',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _currencyLabel(totalDue),
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton.icon(
                        onPressed: unpaid.isEmpty
                            ? null
                            : () => Navigator.of(context).pushNamed(
                                AppPage.billPayment.routeName,
                                arguments: {'bill': unpaid.first},
                              ),
                        icon: const Icon(Icons.credit_card_rounded),
                        label: const Text('Pay Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AvenueColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Pending Dues',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                if (snapshot.connectionState != ConnectionState.done &&
                    unpaid.isEmpty)
                  const _DataPlaceholderCard(label: 'Loading bills...')
                else if (unpaid.isEmpty)
                  const _DataPlaceholderCard(
                    label: 'No pending dues right now.',
                  )
                else
                  ...unpaid.map(
                    (bill) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _BillQuickPayCard(
                        bill: bill,
                        onTap: () => Navigator.of(context).pushNamed(
                          AppPage.billPayment.routeName,
                          arguments: {'bill': bill},
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

class BillPaymentScreen extends StatefulWidget {
  const BillPaymentScreen({super.key, this.bill});

  final Map<String, dynamic>? bill;

  @override
  State<BillPaymentScreen> createState() => _BillPaymentScreenState();
}

class BillReceiptScreen extends StatelessWidget {
  const BillReceiptScreen({super.key, this.billCode});

  final String? billCode;

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Receipt',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
        child: AvenueCard(
          radius: 28,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'COVE BILLS PAYMENT',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AvenueColors.primary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                billCode ?? 'Receipt',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Payment received and recorded successfully.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AvenueColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 18),
              const Divider(),
              const SizedBox(height: 12),
              _ReceiptRow(label: 'Status', value: 'Paid'),
              _ReceiptRow(label: 'Reference', value: billCode ?? '-'),
              _ReceiptRow(label: 'Method', value: 'UPI'),
              _ReceiptRow(
                label: 'Date',
                value: _marketplaceDateLabel(DateTime.now()),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: () => Navigator.of(
                  context,
                ).pushNamed(AppPage.billTransactionHistory.routeName),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AvenueColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('View Transaction History'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BillTransactionHistoryScreen extends StatelessWidget {
  const BillTransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Transaction History',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
      ),
      body: FutureBuilder<_BillsData>(
        future: _BillsData.load(repository),
        builder: (context, snapshot) {
          final rows =
              snapshot.data?.paymentActivity ?? const <Map<String, dynamic>>[];
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (snapshot.connectionState != ConnectionState.done &&
                    rows.isEmpty)
                  const _DataPlaceholderCard(label: 'Loading transactions...')
                else if (rows.isEmpty)
                  const _DataPlaceholderCard(label: 'No transactions yet.')
                else
                  ...rows.map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AvenueCard(
                        radius: 18,
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0x14005BBF),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.receipt_long_rounded,
                                color: AvenueColors.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    row['activity_title']?.toString() ??
                                        'Transaction',
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _marketplaceDateLabel(row['activity_at']),
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: AvenueColors.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              _currencyLabel(row['amount'], signed: true),
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
    );
  }
}

class BillPaymentSuccessScreen extends StatelessWidget {
  const BillPaymentSuccessScreen({super.key, this.amount, this.billCode});

  final dynamic amount;
  final String? billCode;

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AvenueCard(
            radius: 28,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  size: 72,
                  color: Color(0xFF1E8E5A),
                ),
                const SizedBox(height: 16),
                Text(
                  'Payment Successful',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${billCode ?? 'Bill'} has been paid successfully.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  _currencyLabel(amount),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AvenueColors.primary,
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed(
                    AppPage.billReceipt.routeName,
                    arguments: {'billCode': billCode},
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AvenueColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text('View Receipt'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BillQuickPayCard extends StatelessWidget {
  const _BillQuickPayCard({required this.bill, this.onTap});

  final Map<String, dynamic> bill;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final state = bill['state']?.toString().toLowerCase();
    return AvenueCard(
      radius: 18,
      child: ListTile(
        onTap: onTap,
        title: Text(bill['title']?.toString() ?? 'Bill'),
        subtitle: Text(
          '${bill['provider']?.toString() ?? ''} • Due ${_calendarDateLabel(bill['due_date'])}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _currencyLabel(bill['amount_due'] ?? bill['amount_paid']),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            Text(
              (state ?? 'due').toUpperCase(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _marketplaceChipColor(state),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
