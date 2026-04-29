import 'package:flutter/material.dart';

import '../core/supabase/supabase_bootstrap.dart';
import '../features/admin/presentation/admin_screens.dart';
import '../features/guard/presentation/guard_screen.dart';
import '../features/login/presentation/login_screen.dart';
import '../features/resident/presentation/community_screens.dart';
import '../features/resident/presentation/resident_screens.dart';
import '../features/system/presentation/supabase_setup_screen.dart';
import '../theme/avenue_theme.dart';
import 'app_page.dart';

class AvenueApp extends StatelessWidget {
  const AvenueApp({required this.supabaseBootstrap, super.key});

  final SupabaseBootstrapResult supabaseBootstrap;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avenue360',
      debugShowCheckedModeBanner: false,
      theme: AvenueTheme.light(),
      initialRoute: supabaseBootstrap.isReady
          ? AppPage.login.routeName
          : SupabaseSetupScreen.routeName,
      onGenerateRoute: (settings) {
        if (settings.name == SupabaseSetupScreen.routeName) {
          return PageRouteBuilder<void>(
            settings: settings,
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            pageBuilder: (_, _, _) =>
                SupabaseSetupScreen(bootstrapResult: supabaseBootstrap),
          );
        }

        final page = AppPage.fromRoute(settings.name) ?? AppPage.login;

        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          pageBuilder: (_, _, _) {
            switch (page) {
              case AppPage.login:
                return const LoginScreen();
              case AppPage.home:
                return const HomeScreen();
              case AppPage.guardHome:
                return const GuardHomeScreen();
              case AppPage.amenities:
                return const AmenitiesScreen();
              case AppPage.amenityBooking:
                return const AmenityBookingScreen();
              case AppPage.amenityDetailsGym:
                return const AmenityDetailsGymScreen();
              case AppPage.notices:
                return const NoticesScreen();
              case AppPage.bills:
                return const BillsScreen();
              case AppPage.complaints:
                return const ComplaintsScreen();
              case AppPage.createComplaint:
                return const CreateComplaintScreen();
              case AppPage.complaintDetail:
                final arguments = settings.arguments is Map<String, dynamic>
                    ? settings.arguments! as Map<String, dynamic>
                    : const <String, dynamic>{};
                final row = arguments['complaint'] is Map
                    ? Map<String, dynamic>.from(arguments['complaint'] as Map)
                    : const <String, dynamic>{};
                return ComplaintDetailScreen(row: row);
              case AppPage.profile:
                return const ProfileScreen();
              case AppPage.notifications:
                return const NotificationsScreen();
              case AppPage.visitor:
                return const VisitorScreen();
              case AppPage.drawer:
                return const ResidentDrawerScreen();
              case AppPage.communityFeed:
                return const CommunityFeedScreen();
              case AppPage.communityShareIdea:
                return const ShareIdeaScreen();
              case AppPage.communitySuggestionDetail:
                final arguments = settings.arguments is Map<String, dynamic>
                    ? settings.arguments! as Map<String, dynamic>
                    : const <String, dynamic>{};
                return SuggestionDiscussionScreen(
                  suggestionId: arguments['suggestionId'] as String?,
                );
              case AppPage.communityMeetings:
                return const CommunityMeetingsScreen();
              case AppPage.communityMeetingDetail:
                final arguments = settings.arguments is Map<String, dynamic>
                    ? settings.arguments! as Map<String, dynamic>
                    : const <String, dynamic>{};
                return MeetingMinutesScreen(
                  meetingId: arguments['meetingId'] as String?,
                );
              case AppPage.communitySupport:
                return const SupportHelpScreen();
              case AppPage.adminMenu:
                return AdminDrawerScreen(
                  currentPage: settings.arguments is AppPage
                      ? settings.arguments! as AppPage
                      : AppPage.adminDrawer,
                );
              case AppPage.adminDrawer:
                return const AdminDashboardScreen();
              case AppPage.generateReports:
                return const GenerateReportsScreen();
              case AppPage.announcementsManagement:
                final arguments = settings.arguments is Map<String, dynamic>
                    ? settings.arguments! as Map<String, dynamic>
                    : const <String, dynamic>{};
                return AnnouncementsManagementScreen(
                  openComposerOnStart: arguments['openComposer'] == true,
                );
              case AppPage.addResident:
                return const AddResidentScreen();
              case AppPage.residentDirectory:
                return const ResidentDirectoryScreen();
              case AppPage.adminComplaints:
                return const AdminComplaintsScreen();
              case AppPage.adminComplaintDetail:
                final arguments = settings.arguments is Map<String, dynamic>
                    ? settings.arguments! as Map<String, dynamic>
                    : const <String, dynamic>{};
                final row = arguments['complaint'] is Map
                    ? Map<String, dynamic>.from(arguments['complaint'] as Map)
                    : const <String, dynamic>{};
                return AdminComplaintDetailScreen(row: row);
              case AppPage.adminCommunity:
                return const AdminCommunityScreen();
            }
          },
        );
      },
    );
  }
}
