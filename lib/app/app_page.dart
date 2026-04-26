enum AppPage {
  login(slug: 'login'),
  home(slug: 'home'),
  guardHome(slug: 'guard-home'),
  amenities(slug: 'amenities'),
  amenityBooking(slug: 'amenity-booking'),
  amenityDetailsGym(slug: 'amenity-details-gym'),
  notices(slug: 'notices'),
  bills(slug: 'bills'),
  complaints(slug: 'complaints'),
  profile(slug: 'profile'),
  notifications(slug: 'notifications'),
  visitor(slug: 'visitor'),
  drawer(slug: 'drawer'),
  communityFeed(slug: 'community'),
  communityShareIdea(slug: 'community-share-idea'),
  communitySuggestionDetail(slug: 'community-suggestion'),
  communityMeetings(slug: 'community-meetings'),
  communityMeetingDetail(slug: 'community-meeting-detail'),
  communitySupport(slug: 'community-support'),
  adminMenu(slug: 'admin-menu'),
  adminDrawer(slug: 'admin-drawer'),
  generateReports(slug: 'generate-reports'),
  announcementsManagement(slug: 'announcements-management'),
  addResident(slug: 'add-resident'),
  residentDirectory(slug: 'resident-directory'),
  adminComplaints(slug: 'admin-complaints'),
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
