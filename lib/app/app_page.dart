enum AppPage {
  login(slug: 'login'),
  home(slug: 'home'),
  guardHome(slug: 'guard-home'),
  amenities(slug: 'amenities'),
  amenityBooking(slug: 'amenity-booking'),
  amenityDetailsGym(slug: 'amenity-details-gym'),
  amenityReservations(slug: 'amenity-reservations'),
  notices(slug: 'notices'),
  bills(slug: 'bills'),
  billQuickPay(slug: 'bill-quick-pay'),
  billPayment(slug: 'bill-payment'),
  billReceipt(slug: 'bill-receipt'),
  billTransactionHistory(slug: 'bill-transaction-history'),
  billPaymentSuccess(slug: 'bill-payment-success'),
  maintenanceInvoice(slug: 'maintenance-invoice'),
  maintenancePay(slug: 'maintenance-pay'),
  maintenanceHistory(slug: 'maintenance-history'),
  maintenancePaymentSuccess(slug: 'maintenance-payment-success'),
  complaints(slug: 'complaints'),
  createComplaint(slug: 'create-complaint'),
  complaintDetail(slug: 'complaint-detail'),
  profile(slug: 'profile'),
  notifications(slug: 'notifications'),
  visitor(slug: 'visitor'),
  drawer(slug: 'drawer'),
  residentServices(slug: 'resident-services'),
  residentServiceProfile(slug: 'resident-service-profile'),
  marketplaceHome(slug: 'marketplace-home'),
  marketplaceProductDetails(slug: 'marketplace-product-details'),
  marketplaceCartCheckout(slug: 'marketplace-cart-checkout'),
  marketplaceListProperty(slug: 'marketplace-list-property'),
  marketplaceStores(slug: 'marketplace-stores'),
  marketplaceMyListings(slug: 'marketplace-my-listings'),
  marketplaceMyOrders(slug: 'marketplace-my-orders'),
  marketplaceOrderDetails(slug: 'marketplace-order-details'),
  marketplaceOrderHistory(slug: 'marketplace-order-history'),
  marketplaceSellItem(slug: 'marketplace-sell-item'),
  marketplaceStoreProducts(slug: 'marketplace-store-products'),
  marketplaceStoreOrders(slug: 'marketplace-store-orders'),
  communityFeed(slug: 'community'),
  communityShareIdea(slug: 'community-share-idea'),
  communitySelectResidents(slug: 'community-select-residents'),
  communitySuggestionDetail(slug: 'community-suggestion'),
  communityMeetings(slug: 'community-meetings'),
  communityMeetingDetail(slug: 'community-meeting-detail'),
  communitySupport(slug: 'community-support'),
  adminMenu(slug: 'admin-menu'),
  adminDrawer(slug: 'admin-drawer'),
  adminAmenities(slug: 'admin-amenities'),
  adminAmenityBookings(slug: 'admin-amenity-bookings'),
  addAmenity(slug: 'add-amenity'),
  editAmenity(slug: 'edit-amenity'),
  adminServices(slug: 'admin-services'),
  addServiceProvider(slug: 'add-service-provider'),
  generateReports(slug: 'generate-reports'),
  announcementsManagement(slug: 'announcements-management'),
  addAnnouncement(slug: 'add-announcement'),
  addResident(slug: 'add-resident'),
  residentDirectory(slug: 'resident-directory'),
  adminMaintenance(slug: 'admin-maintenance'),
  adminMaintenanceResidentLog(slug: 'admin-maintenance-resident-log'),
  adminMaintenanceResidentDetail(slug: 'admin-maintenance-resident-detail'),
  adminMaintenanceForcedAlert(slug: 'admin-maintenance-forced-alert'),
  adminMaintenanceNotificationSettings(
    slug: 'admin-maintenance-notification-settings',
  ),
  adminMaintenanceExport(slug: 'admin-maintenance-export'),
  adminMaintenanceSecurePayment(slug: 'admin-maintenance-secure-payment'),
  adminTreasurerDashboard(slug: 'admin-treasurer-dashboard'),
  adminTreasurerVendors(slug: 'admin-treasurer-vendors'),
  adminTreasurerAddVendor(slug: 'admin-treasurer-add-vendor'),
  adminTreasurerExpenses(slug: 'admin-treasurer-expenses'),
  adminTreasurerAnalysis(slug: 'admin-treasurer-analysis'),
  adminTreasurerQuotationRequest(slug: 'admin-treasurer-quotation-request'),
  adminTreasurerVendorComparison(slug: 'admin-treasurer-vendor-comparison'),
  adminTreasurerContractRenewal(slug: 'admin-treasurer-contract-renewal'),
  adminComplaints(slug: 'admin-complaints'),
  adminComplaintDetail(slug: 'admin-complaint-detail'),
  adminCommunity(slug: 'admin-community');

  const AppPage({required this.slug});

  final String slug;

  String get routeName => '/$slug';

  static AppPage? fromSlug(String? slug) {
    if (slug == null) {
      return null;
    }

    for (final page in values) {
      if (page.slug == slug) {
        return page;
      }
    }

    return null;
  }

  static AppPage? fromRoute(String? routeName) {
    if (routeName == null || routeName.isEmpty || routeName == '/') {
      return login;
    }

    return fromSlug(routeName.replaceFirst('/', ''));
  }
}
