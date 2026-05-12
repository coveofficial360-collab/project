part of 'resident_screens.dart';

class MarketplaceHomeScreen extends StatefulWidget {
  const MarketplaceHomeScreen({super.key});

  @override
  State<MarketplaceHomeScreen> createState() => _MarketplaceHomeScreenState();
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

class MarketplaceListPropertyScreen extends StatefulWidget {
  const MarketplaceListPropertyScreen({super.key});

  @override
  State<MarketplaceListPropertyScreen> createState() =>
      _MarketplaceListPropertyScreenState();
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
