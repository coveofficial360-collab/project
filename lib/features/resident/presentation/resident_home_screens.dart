part of 'resident_screens.dart';

class ResidentDrawerScreen extends StatelessWidget {
  const ResidentDrawerScreen({super.key, this.currentPage = AppPage.home});

  final AppPage currentPage;

  bool get _isCommunitySection =>
      currentPage == AppPage.communityFeed ||
      currentPage == AppPage.communityShareIdea ||
      currentPage == AppPage.communitySuggestionDetail ||
      currentPage == AppPage.communityMeetings ||
      currentPage == AppPage.communityMeetingDetail ||
      currentPage == AppPage.communitySupport;

  bool get _isMarketplaceSection =>
      currentPage == AppPage.marketplaceHome ||
      currentPage == AppPage.marketplaceProductDetails ||
      currentPage == AppPage.marketplaceCartCheckout ||
      currentPage == AppPage.marketplaceListProperty ||
      currentPage == AppPage.marketplaceStores ||
      currentPage == AppPage.marketplaceMyListings ||
      currentPage == AppPage.marketplaceMyOrders ||
      currentPage == AppPage.marketplaceOrderDetails ||
      currentPage == AppPage.marketplaceOrderHistory ||
      currentPage == AppPage.marketplaceSellItem ||
      currentPage == AppPage.marketplaceStoreProducts ||
      currentPage == AppPage.marketplaceStoreOrders;

  bool get _isPetSection =>
      currentPage == AppPage.petHub ||
      currentPage == AppPage.petSocialFeed ||
      currentPage == AppPage.petProfile ||
      currentPage == AppPage.addPetBasicDetails ||
      currentPage == AppPage.addPetHealthInfo ||
      currentPage == AppPage.addPetPhotoUpload ||
      currentPage == AppPage.addPetPreview ||
      currentPage == AppPage.vaccinationDashboard ||
      currentPage == AppPage.addVaccination ||
      currentPage == AppPage.vaccinationHistory ||
      currentPage == AppPage.petMeetups ||
      currentPage == AppPage.createPetMeetup ||
      currentPage == AppPage.createPetPost ||
      currentPage == AppPage.bookPetZone ||
      currentPage == AppPage.petStores ||
      currentPage == AppPage.petAdoptionCenter ||
      currentPage == AppPage.vetDirectory;

  void _navigateFromDrawer(BuildContext context, AppPage targetPage) {
    Navigator.of(context).pop();
    if (targetPage == currentPage) {
      return;
    }
    Navigator.of(context).pushReplacementNamed(targetPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = AppSession.instance.currentUser;
    final hasPayments =
        currentUser?.hasFeature(AppFeatureKeys.residentPayments) ?? true;
    final hasComplaints =
        currentUser?.hasFeature(AppFeatureKeys.residentComplaints) ?? true;
    final hasNotices =
        currentUser?.hasFeature(AppFeatureKeys.residentNotices) ?? true;
    final hasCommunity =
        currentUser?.hasFeature(AppFeatureKeys.residentCommunity) ?? true;
    final hasAmenities =
        currentUser?.hasFeature(AppFeatureKeys.residentAmenities) ?? true;
    final hasServices =
        currentUser?.hasFeature(AppFeatureKeys.residentServices) ?? true;
    final hasPets = currentUser?.hasFeature(AppFeatureKeys.residentPets) ?? true;
    final hasMarketplace =
        currentUser?.hasFeature(AppFeatureKeys.residentMarketplace) ?? true;
    final hasVisitors =
        currentUser?.hasFeature(AppFeatureKeys.residentVisitors) ?? true;

    return AvenueScaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              color: AvenueColors.primary.withValues(alpha: 0.12),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 310,
                height: double.infinity,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(34),
                    bottomRight: Radius.circular(34),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AvenueNetworkAvatar(
                          imageUrl: _drawerAvatarUrl,
                          size: 64,
                          fallbackLabel: 'AS',
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                          color: AvenueColors.onSurfaceVariant,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Aditya Sharma',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Flat B-204',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AvenueColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const AvenuePill(
                      label: 'ACTIVE MEMBER',
                      backgroundColor: Color(0x1AFFBA43),
                      foregroundColor: Color(0xFFE29B00),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          _DrawerItem(
                            label: 'Dashboard',
                            icon: Icons.dashboard_customize_rounded,
                            selected: currentPage == AppPage.home,
                            onTap: () =>
                                _navigateFromDrawer(context, AppPage.home),
                          ),
                          const SizedBox(height: 8),
                          if (hasPayments) ...[
                            _DrawerItem(
                              label: 'Payments',
                              icon: Icons.payments_outlined,
                              selected: currentPage == AppPage.bills,
                              onTap: () =>
                                  _navigateFromDrawer(context, AppPage.bills),
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (hasComplaints) ...[
                            _DrawerItem(
                              label: 'My Complaints',
                              icon: Icons.info_outline_rounded,
                              selected: currentPage == AppPage.complaints,
                              onTap: () => _navigateFromDrawer(
                                context,
                                AppPage.complaints,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (hasNotices) ...[
                            _DrawerItem(
                              label: 'Notice Board',
                              icon: Icons.campaign_outlined,
                              selected: currentPage == AppPage.notices,
                              onTap: () =>
                                  _navigateFromDrawer(context, AppPage.notices),
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (hasCommunity) ...[
                            _DrawerItem(
                              label: 'Community',
                              icon: Icons.groups_rounded,
                              selected: _isCommunitySection,
                              onTap: () => _navigateFromDrawer(
                                context,
                                AppPage.communityFeed,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (hasAmenities) ...[
                            _DrawerItem(
                              label: 'Amenities',
                              icon: Icons.pool_rounded,
                              selected: currentPage == AppPage.amenities,
                              onTap: () => _navigateFromDrawer(
                                context,
                                AppPage.amenities,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (hasServices) ...[
                            _DrawerItem(
                              label: 'Services',
                              icon: Icons.grid_view_rounded,
                              selected:
                                  currentPage == AppPage.residentServices ||
                                  currentPage == AppPage.residentServiceProfile,
                              onTap: () => _navigateFromDrawer(
                                context,
                                AppPage.residentServices,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (hasPets) ...[
                            _DrawerItem(
                              label: 'Pets Community',
                              icon: Icons.pets_rounded,
                              selected: _isPetSection,
                              onTap: () =>
                                  _navigateFromDrawer(context, AppPage.petHub),
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (hasMarketplace) ...[
                            _DrawerItem(
                              label: 'Marketplace',
                              icon: Icons.storefront_outlined,
                              selected: _isMarketplaceSection,
                              onTap: () => _navigateFromDrawer(
                                context,
                                AppPage.marketplaceHome,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (hasVisitors || hasComplaints || hasCommunity) ...[
                            _DrawerItem(
                              label: 'Support',
                              icon: Icons.help_outline,
                              selected: currentPage == AppPage.communitySupport,
                              onTap: () => _navigateFromDrawer(
                                context,
                                AppPage.communitySupport,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          const SizedBox(height: 8),
                          const _DrawerItem(
                            label: 'Settings',
                            icon: Icons.settings,
                          ),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () =>
                          goToPage(context, AppPage.login, replace: true),
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: Color(0xFFD32F2F),
                      ),
                      label: Text(
                        'Logout',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: const Color(0xFFD32F2F),
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = AppSession.instance.currentUser;
    final repository = AvenueRepository();

    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Cove',
        centerTitle: false,
        leading: AvenueIconButton(
          icon: Icons.menu_rounded,
          onPressed: () => Navigator.of(
            context,
          ).pushNamed(AppPage.drawer.routeName, arguments: AppPage.home),
        ),
        titleWidget: Row(
          children: [
            const Icon(
              Icons.apartment_rounded,
              color: AvenueColors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Cove',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        actions: [
          const _ResidentNotificationBellButton(),
          Padding(
            padding: const EdgeInsets.only(right: 18, left: 6),
            child: GestureDetector(
              onTap: () => goToPage(context, AppPage.profile),
              child: AvenueNetworkAvatar(
                imageUrl: currentUser?.avatarUrl ?? _residentAvatarUrl,
                size: 36,
                fallbackLabel: currentUser?.initials ?? 'A',
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<_ResidentHomeData>(
        future: _ResidentHomeData.load(repository),
        builder: (context, snapshot) {
          final data = snapshot.data;
          final bills = data?.bills ?? const <Map<String, dynamic>>[];
          final notices = data?.notices ?? const <Map<String, dynamic>>[];
          final maintenanceBill = bills
              .cast<Map<String, dynamic>?>()
              .firstWhere(
                (bill) =>
                    (bill?['category']?.toString().toLowerCase() ==
                        'maintenance') &&
                    (bill?['state']?.toString().toLowerCase() != 'paid'),
                orElse: () => null,
              );

          return _ResidentScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MaintenanceCard(
                  onPayTap: maintenanceBill == null
                      ? null
                      : () => goToPage(context, AppPage.bills),
                  amount: maintenanceBill?['amount_due']?.toString(),
                  dueDate: maintenanceBill?['due_date']?.toString(),
                ),
                const SizedBox(height: 20),
                AvenueSectionHeader(
                  title: 'Bills & recharges',
                  actionLabel: 'Manage',
                  onActionTap: () => goToPage(context, AppPage.bills),
                ),
                const SizedBox(height: 16),
                const _QuickBillsRow(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _FeatureActionCard(
                        icon: Icons.group_add_rounded,
                        iconBackground: const Color(0xFFE8EFFF),
                        iconColor: AvenueColors.primary,
                        title: 'Pre-Approve\nVisitor',
                        onTap: () => goToPage(context, AppPage.visitor),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _FeatureActionCard(
                        icon: Icons.campaign_rounded,
                        iconBackground: const Color(0xFFFFE8E6),
                        iconColor: const Color(0xFFE04A3F),
                        title: 'Raise\nComplaint',
                        onTap: () => goToPage(context, AppPage.complaints),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                AvenueSectionHeader(
                  title: 'Essential Notifications',
                  actionLabel: 'View All',
                  onActionTap: () => goToPage(context, AppPage.notifications),
                ),
                const SizedBox(height: 14),
                if (snapshot.connectionState != ConnectionState.done)
                  const _DataPlaceholderCard(label: 'Loading home data...')
                else if (notices.isEmpty)
                  const _DataPlaceholderCard(
                    label: 'No notifications available right now.',
                  )
                else
                  ...notices.map(
                    (notice) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _NotificationPreviewTile(
                        icon: (notice['kind'] == 'urgent')
                            ? Icons.receipt_long_rounded
                            : Icons.water_drop_rounded,
                        iconColor: (notice['kind'] == 'urgent')
                            ? const Color(0xFFC7483D)
                            : AvenueColors.onSurface,
                        iconBackground: (notice['kind'] == 'urgent')
                            ? const Color(0xFFFFE7E5)
                            : const Color(0xFFE9EEFF),
                        title: notice['title'] as String? ?? 'Notice',
                        subtitle: notice['body'] as String? ?? '',
                        timeLabel: _relativeTimeLabel(notice['posted_at']),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigation: AvenueBottomNavigationBar(
        items: _residentNavItems,
        currentPage: AppPage.home,
      ),
    );
  }
}
