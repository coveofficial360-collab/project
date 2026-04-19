import 'package:flutter/material.dart';

import '../features/admin/presentation/admin_screens.dart';
import '../features/resident/presentation/resident_screens.dart';
import '../features/login/presentation/login_screen.dart';
import '../theme/avenue_theme.dart';
import 'app_page.dart';

class AvenueApp extends StatelessWidget {
  const AvenueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avenue360',
      debugShowCheckedModeBanner: false,
      theme: AvenueTheme.light(),
      initialRoute: AppPage.login.routeName,
      onGenerateRoute: (settings) {
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
              case AppPage.profile:
                return const ProfileScreen();
              case AppPage.notifications:
                return const NotificationsScreen();
              case AppPage.visitor:
                return const VisitorScreen();
              case AppPage.drawer:
                return const ResidentDrawerScreen();
              case AppPage.adminDrawer:
                return const AdminDashboardScreen();
              case AppPage.generateReports:
                return const GenerateReportsScreen();
              case AppPage.announcementsManagement:
                return const AnnouncementsManagementScreen();
              case AppPage.addResident:
                return const AddResidentScreen();
              case AppPage.residentDirectory:
                return const ResidentDirectoryScreen();
            }
          },
        );
      },
    );
  }
}
