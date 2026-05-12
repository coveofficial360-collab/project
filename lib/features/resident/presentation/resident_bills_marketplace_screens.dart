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
