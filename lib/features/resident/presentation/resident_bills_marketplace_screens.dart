part of 'resident_screens.dart';

String _marketplaceDateLabel(dynamic value) {
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

Color _marketplaceChipColor(String? value) {
  switch ((value ?? '').toLowerCase()) {
    case 'available':
    case 'open':
    case 'published':
      return const Color(0xFF0D7A92);
    case 'sold_out':
    case 'expired':
      return const Color(0xFFD6453A);
    default:
      return AvenueColors.primary;
  }
}

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

class _BillPaymentScreenState extends State<BillPaymentScreen> {
  String _paymentMethod = 'UPI';
  String _paymentRef = '';
  bool _processing = false;

  Future<void> _pay(Map<String, dynamic> bill) async {
    if (_processing) {
      return;
    }

    setState(() => _processing = true);
    try {
      final response = await AvenueRepository().payBill(
        billId: bill['id']?.toString() ?? '',
        paymentMethod: _paymentMethod,
        transactionRef: _paymentRef.trim().isEmpty ? null : _paymentRef.trim(),
      );
      if (!mounted) {
        return;
      }
      if (response == null) {
        throw Exception('Payment could not be completed.');
      }
      Navigator.of(context).pushReplacementNamed(
        AppPage.billPaymentSuccess.routeName,
        arguments: {
          'amount': response['amount_paid'],
          'billCode': response['bill_code']?.toString() ?? '-',
        },
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment failed: $error')));
    } finally {
      if (mounted) {
        setState(() => _processing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bill = widget.bill;
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Bill Payment',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
      ),
      body: bill == null
          ? const _DataPlaceholderCard(label: 'No bill selected.')
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AvenueCard(
                    radius: 28,
                    color: AvenueColors.primary,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bill['title']?.toString() ?? 'Bill',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          bill['provider']?.toString() ?? '',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.82),
                              ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _currencyLabel(
                            bill['amount_due'] ?? bill['amount_paid'],
                          ),
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Payment Method',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ChoiceChip(
                        label: const Text('UPI'),
                        selected: _paymentMethod == 'UPI',
                        onSelected: (_) =>
                            setState(() => _paymentMethod = 'UPI'),
                      ),
                      ChoiceChip(
                        label: const Text('Card'),
                        selected: _paymentMethod == 'Card',
                        onSelected: (_) =>
                            setState(() => _paymentMethod = 'Card'),
                      ),
                      ChoiceChip(
                        label: const Text('Net Banking'),
                        selected: _paymentMethod == 'Net Banking',
                        onSelected: (_) =>
                            setState(() => _paymentMethod = 'Net Banking'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    onChanged: (value) => _paymentRef = value,
                    decoration: InputDecoration(
                      labelText: 'Transaction Reference',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _processing ? null : () => _pay(bill),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AvenueColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(_processing ? 'Processing...' : 'Pay Bill'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
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

class MarketplaceHomeScreen extends StatefulWidget {
  const MarketplaceHomeScreen({super.key});

  @override
  State<MarketplaceHomeScreen> createState() => _MarketplaceHomeScreenState();
}

class _MarketplaceHomeScreenState extends State<MarketplaceHomeScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Marketplace',
        leading: AvenueIconButton(
          icon: Icons.menu_rounded,
          onPressed: () => Navigator.of(context).pushNamed(
            AppPage.drawer.routeName,
            arguments: AppPage.marketplaceHome,
          ),
          size: 40,
        ),
        actions: [
          AvenueIconButton(
            icon: Icons.shopping_bag_rounded,
            onPressed: () => goToPage(context, AppPage.marketplaceMyOrders),
            size: 40,
          ),
          const SizedBox(width: 12),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AvenueColors.primary,
        foregroundColor: Colors.white,
        onPressed: () => goToPage(context, AppPage.marketplaceSellItem),
        child: const Icon(Icons.add_rounded),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          repository.fetchMarketplaceStores(),
          repository.fetchMarketplaceProducts(),
          repository.fetchMarketplaceListings(),
          repository.fetchMarketplaceOrders(),
        ]),
        builder: (context, snapshot) {
          final stores = snapshot.data == null || snapshot.data!.isEmpty
              ? const <Map<String, dynamic>>[]
              : snapshot.data!.first as List<Map<String, dynamic>>;
          final products = snapshot.data == null || snapshot.data!.length < 2
              ? const <Map<String, dynamic>>[]
              : snapshot.data![1] as List<Map<String, dynamic>>;
          final categories = <String>{
            'All',
            ...products
                .map((row) => row['category']?.toString() ?? '')
                .where((e) => e.isNotEmpty),
          }.toList();
          final filteredProducts = _selectedCategory == 'All'
              ? products
              : products
                    .where(
                      (row) => row['category']?.toString() == _selectedCategory,
                    )
                    .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 96),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF083C94), Color(0xFF31C6B3)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cove Fresh Market',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Buy, sell, rent and discover local stores in the community.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.86),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final selected = category == _selectedCategory;
                      return ChoiceChip(
                        label: Text(category),
                        selected: selected,
                        onSelected: (_) =>
                            setState(() => _selectedCategory = category),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Featured Products',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          goToPage(context, AppPage.marketplaceStores),
                      child: const Text('Stores'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (snapshot.connectionState != ConnectionState.done &&
                    filteredProducts.isEmpty)
                  const _DataPlaceholderCard(label: 'Loading marketplace...')
                else if (filteredProducts.isEmpty)
                  const _DataPlaceholderCard(label: 'No products found.')
                else
                  ...filteredProducts
                      .take(4)
                      .map(
                        (product) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _MarketplaceProductCard(
                            product: product,
                            onTap: () => Navigator.of(context).pushNamed(
                              AppPage.marketplaceProductDetails.routeName,
                              arguments: {'productId': product['id']},
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            goToPage(context, AppPage.marketplaceListProperty),
                        child: const Text('List Property'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            goToPage(context, AppPage.marketplaceMyListings),
                        child: const Text('My Listings'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'Local Stores',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                ...stores
                    .take(3)
                    .map(
                      (store) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _MarketplaceStoreCard(
                          store: store,
                          onTap: () => Navigator.of(context).pushNamed(
                            AppPage.marketplaceStoreProducts.routeName,
                            arguments: {'storeId': store['id']},
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

class MarketplaceProductDetailsScreen extends StatelessWidget {
  const MarketplaceProductDetailsScreen({super.key, this.productId});

  final String? productId;

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Product Details',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: productId == null
            ? Future<Map<String, dynamic>?>.value(null)
            : repository.fetchMarketplaceProductById(productId!),
        builder: (context, snapshot) {
          final product = snapshot.data;
          if (snapshot.connectionState != ConnectionState.done) {
            return const _DataPlaceholderCard(label: 'Loading product...');
          }
          if (product == null) {
            return const _DataPlaceholderCard(label: 'Product not found.');
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvenueCard(
                  radius: 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['title']?.toString() ?? 'Product',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 8),
                      Text(product['description']?.toString() ?? ''),
                      const SizedBox(height: 12),
                      Text(
                        _currencyLabel(product['price']),
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              color: AvenueColors.primary,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Seller Profile',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                AvenueCard(
                  radius: 22,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['seller_name']?.toString() ??
                            product['store_name']?.toString() ??
                            'Seller',
                      ),
                      const SizedBox(height: 4),
                      Text(product['seller_phone']?.toString() ?? ''),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed(
                    AppPage.marketplaceCartCheckout.routeName,
                    arguments: {
                      'productIds': [product['id']],
                    },
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AvenueColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Contact Seller'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MarketplaceCartCheckoutScreen extends StatefulWidget {
  const MarketplaceCartCheckoutScreen({super.key, this.productIds});

  final List<String>? productIds;

  @override
  State<MarketplaceCartCheckoutScreen> createState() =>
      _MarketplaceCartCheckoutScreenState();
}

class _MarketplaceCartCheckoutScreenState
    extends State<MarketplaceCartCheckoutScreen> {
  final _addressController = TextEditingController(text: 'Tower A, 1204');
  final _phoneController = TextEditingController(text: '+91 90000 22101');
  final _slotController = TextEditingController(text: 'Today, 7 PM');
  bool _loading = false;

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _slotController.dispose();
    super.dispose();
  }

  Future<void> _checkout(List<Map<String, dynamic>> products) async {
    if (_loading) {
      return;
    }
    setState(() => _loading = true);
    try {
      final result = await AvenueRepository().placeMarketplaceOrder(
        productIds: products
            .map((product) => product['id'].toString())
            .toList(),
        deliveryAddress: _addressController.text,
        contactPhone: _phoneController.text,
        deliverySlot: _slotController.text,
      );
      if (!mounted) {
        return;
      }
      if (result == null) {
        throw Exception('Checkout failed.');
      }
      Navigator.of(context).pushReplacementNamed(
        AppPage.marketplaceOrderDetails.routeName,
        arguments: {'orderId': result['order_id']},
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Checkout failed: $error')));
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productIds = widget.productIds ?? const <String>[];
    final repository = AvenueRepository();
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Cart Checkout',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: repository.fetchMarketplaceProducts(),
        builder: (context, snapshot) {
          final products = snapshot.data ?? const <Map<String, dynamic>>[];
          final selected = productIds.isEmpty
              ? products.take(2).toList()
              : products
                    .where(
                      (product) =>
                          productIds.contains(product['id'].toString()),
                    )
                    .toList();
          final subtotal = selected.fold<double>(
            0,
            (sum, product) =>
                sum + (double.tryParse('${product['price'] ?? 0}') ?? 0),
          );
          final delivery = subtotal >= 1500 ? 0 : 49;
          final tax = subtotal * 0.05;
          final total = subtotal + delivery + tax;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...selected.map(
                  (product) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _MarketplaceProductCard(product: product),
                  ),
                ),
                const SizedBox(height: 8),
                AvenueCard(
                  radius: 22,
                  child: Column(
                    children: [
                      TextField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Delivery Address',
                        ),
                      ),
                      TextField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Contact Phone',
                        ),
                      ),
                      TextField(
                        controller: _slotController,
                        decoration: const InputDecoration(
                          labelText: 'Delivery Slot',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                AvenueCard(
                  radius: 22,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ReceiptRow(
                        label: 'Subtotal',
                        value: _currencyLabel(subtotal),
                      ),
                      _ReceiptRow(
                        label: 'Delivery',
                        value: _currencyLabel(delivery),
                      ),
                      _ReceiptRow(label: 'Tax', value: _currencyLabel(tax)),
                      const Divider(),
                      _ReceiptRow(label: 'Total', value: _currencyLabel(total)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: selected.isEmpty || _loading
                      ? null
                      : () => _checkout(selected),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AvenueColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: Text(_loading ? 'Placing Order...' : 'Place Order'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MarketplaceListPropertyScreen extends StatefulWidget {
  const MarketplaceListPropertyScreen({super.key});

  @override
  State<MarketplaceListPropertyScreen> createState() =>
      _MarketplaceListPropertyScreenState();
}

class _MarketplaceListPropertyScreenState
    extends State<MarketplaceListPropertyScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contactController = TextEditingController();
  String _listingType = 'rent';

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final result = await AvenueRepository().createMarketplaceListing(
      listingType: _listingType,
      title: _titleController.text,
      category: 'Property',
      price: double.tryParse(_priceController.text.trim()) ?? 0,
      locationLabel: _locationController.text,
      description: _descriptionController.text,
      contactPhone: _contactController.text,
      isFeatured: true,
    );
    if (!mounted) {
      return;
    }
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not create listing.')),
      );
      return;
    }
    Navigator.of(
      context,
    ).pushReplacementNamed(AppPage.marketplaceMyListings.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'List Property',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Rent'),
                    selected: _listingType == 'rent',
                    onSelected: (_) => setState(() => _listingType = 'rent'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Sell'),
                    selected: _listingType == 'sell',
                    onSelected: (_) => setState(() => _listingType = 'sell'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 4,
            ),
            TextField(
              controller: _contactController,
              decoration: const InputDecoration(labelText: 'Contact Phone'),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AvenueColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
              ),
              child: const Text('Post Listing'),
            ),
          ],
        ),
      ),
    );
  }
}

class MarketplaceStoresScreen extends StatelessWidget {
  const MarketplaceStoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Local Stores',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: repository.fetchMarketplaceStores(),
        builder: (context, snapshot) {
          final stores = snapshot.data ?? const <Map<String, dynamic>>[];
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
            child: Column(
              children: stores.map((store) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _MarketplaceStoreCard(
                    store: store,
                    onTap: () => Navigator.of(context).pushNamed(
                      AppPage.marketplaceStoreProducts.routeName,
                      arguments: {'storeId': store['id']},
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

class MarketplaceMyListingsScreen extends StatelessWidget {
  const MarketplaceMyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'My Listings',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => goToPage(context, AppPage.marketplaceSellItem),
        backgroundColor: AvenueColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Listing'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: repository.fetchMarketplaceListings(),
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 96),
            child: rows.isEmpty
                ? const _DataPlaceholderCard(label: 'No listings yet.')
                : Column(
                    children: rows.map((row) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AvenueCard(
                          radius: 18,
                          child: ListTile(
                            title: Text(row['title']?.toString() ?? 'Listing'),
                            subtitle: Text(
                              row['listing_type']?.toString() ?? '',
                            ),
                            trailing: Text(_currencyLabel(row['price'])),
                            onTap: () => Navigator.of(context).pushNamed(
                              AppPage.marketplaceListProperty.routeName,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          );
        },
      ),
    );
  }
}

class MarketplaceSellItemScreen extends StatelessWidget {
  const MarketplaceSellItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MarketplaceListPropertyScreen();
  }
}

class MarketplaceMyOrdersScreen extends StatelessWidget {
  const MarketplaceMyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'My Orders',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: repository.fetchMarketplaceOrders(),
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
            child: rows.isEmpty
                ? const _DataPlaceholderCard(label: 'No orders yet.')
                : Column(
                    children: rows.map((row) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AvenueCard(
                          radius: 18,
                          child: ListTile(
                            title: Text(
                              row['order_code']?.toString() ?? 'Order',
                            ),
                            subtitle: Text(row['store_name']?.toString() ?? ''),
                            trailing: Text(_currencyLabel(row['total_amount'])),
                            onTap: () => Navigator.of(context).pushNamed(
                              AppPage.marketplaceOrderDetails.routeName,
                              arguments: {'orderId': row['id']},
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          );
        },
      ),
    );
  }
}

class MarketplaceOrderDetailsScreen extends StatelessWidget {
  const MarketplaceOrderDetailsScreen({super.key, this.orderId});

  final String? orderId;

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Order Details',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          orderId == null
              ? Future.value(null)
              : repository.fetchMarketplaceOrderById(orderId!),
          orderId == null
              ? Future.value(const <Map<String, dynamic>>[])
              : repository.fetchMarketplaceOrderItems(orderId!),
        ]),
        builder: (context, snapshot) {
          final order = snapshot.data == null || snapshot.data!.isEmpty
              ? null
              : snapshot.data!.first as Map<String, dynamic>?;
          final items = snapshot.data == null || snapshot.data!.length < 2
              ? const <Map<String, dynamic>>[]
              : snapshot.data![1] as List<Map<String, dynamic>>;
          if (snapshot.connectionState != ConnectionState.done) {
            return const _DataPlaceholderCard(label: 'Loading order...');
          }
          if (order == null) {
            return const _DataPlaceholderCard(label: 'Order not found.');
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvenueCard(
                  radius: 28,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order['order_code']?.toString() ?? '-'),
                      Text(order['store_name']?.toString() ?? 'Marketplace'),
                      const SizedBox(height: 10),
                      _ReceiptRow(
                        label: 'Status',
                        value: order['status']?.toString() ?? '',
                      ),
                      _ReceiptRow(
                        label: 'Payment',
                        value: order['payment_status']?.toString() ?? '',
                      ),
                      _ReceiptRow(
                        label: 'Total',
                        value: _currencyLabel(order['total_amount']),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Items',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                ...items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AvenueCard(
                      radius: 18,
                      child: ListTile(
                        title: Text(item['title']?.toString() ?? 'Item'),
                        subtitle: Text('Qty ${item['quantity'] ?? 1}'),
                        trailing: Text(_currencyLabel(item['line_total'])),
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

class MarketplaceOrderHistoryScreen extends StatelessWidget {
  const MarketplaceOrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MarketplaceMyOrdersScreen();
  }
}

class MarketplaceStoreProductsScreen extends StatelessWidget {
  const MarketplaceStoreProductsScreen({super.key, this.storeId});

  final String? storeId;

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Store Products',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: repository.fetchMarketplaceProducts(),
        builder: (context, snapshot) {
          final products = snapshot.data ?? const <Map<String, dynamic>>[];
          final filtered = storeId == null
              ? products
              : products
                    .where((row) => row['store_id']?.toString() == storeId)
                    .toList();
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
            child: Column(
              children: filtered.map((product) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _MarketplaceProductCard(
                    product: product,
                    onTap: () => Navigator.of(context).pushNamed(
                      AppPage.marketplaceProductDetails.routeName,
                      arguments: {'productId': product['id']},
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

class MarketplaceStoreOrdersScreen extends StatelessWidget {
  const MarketplaceStoreOrdersScreen({super.key, this.storeId});

  final String? storeId;

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Store Orders',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: repository.fetchMarketplaceOrders(),
        builder: (context, snapshot) {
          final orders = snapshot.data ?? const <Map<String, dynamic>>[];
          final filtered = storeId == null
              ? orders
              : orders
                    .where((row) => row['store_id']?.toString() == storeId)
                    .toList();
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
            child: filtered.isEmpty
                ? const _DataPlaceholderCard(label: 'No orders for this store.')
                : Column(
                    children: filtered.map((order) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AvenueCard(
                          radius: 18,
                          child: ListTile(
                            title: Text(
                              order['order_code']?.toString() ?? 'Order',
                            ),
                            subtitle: Text(order['status']?.toString() ?? ''),
                            trailing: Text(
                              _currencyLabel(order['total_amount']),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          );
        },
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

class _MarketplaceProductCard extends StatelessWidget {
  const _MarketplaceProductCard({required this.product, this.onTap});

  final Map<String, dynamic> product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 22,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                product['image_url']?.toString() ?? '',
                width: 88,
                height: 88,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 88,
                  height: 88,
                  color: AvenueColors.surfaceHigh,
                  child: const Icon(Icons.image_rounded),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['title']?.toString() ?? 'Product',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(product['store_name']?.toString() ?? ''),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        _currencyLabel(product['price']),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AvenueColors.primary,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        product['category']?.toString() ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AvenueColors.onSurfaceVariant,
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
    );
  }
}

class _MarketplaceStoreCard extends StatelessWidget {
  const _MarketplaceStoreCard({required this.store, this.onTap});

  final Map<String, dynamic> store;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AvenueCard(
      radius: 22,
      child: ListTile(
        onTap: onTap,
        title: Text(store['name']?.toString() ?? 'Store'),
        subtitle: Text(store['description']?.toString() ?? ''),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              (store['rating']?.toString() ?? '--'),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            Text(store['open_status']?.toString() ?? ''),
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
