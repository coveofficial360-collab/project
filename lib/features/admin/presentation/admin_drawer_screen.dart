part of 'admin_screens.dart';

class AdminDrawerScreen extends StatelessWidget {
  const AdminDrawerScreen({super.key, this.currentPage = AppPage.adminDrawer});

  final AppPage currentPage;

  @override
  Widget build(BuildContext context) {
    final currentUser = AppSession.instance.currentUser;
    final avatarUrl = currentUser?.avatarUrl ?? _adminAvatarUrl;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.black.withValues(alpha: 0.32)),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: SafeArea(
              child: Container(
                width: 320,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: _AdminPalette.surface,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x26000000),
                      blurRadius: 36,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 18, 18),
                      child: Row(
                        children: [
                          Text(
                            'Avenue360',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: AvenueColors.primary,
                                ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close_rounded),
                            color: _AdminPalette.muted,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _AdminPalette.surfaceLow,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: _AdminPalette.outline.withValues(alpha: 0.45),
                          ),
                        ),
                        child: Row(
                          children: [
                            AvenueNetworkAvatar(
                              imageUrl: avatarUrl,
                              size: 56,
                              borderWidth: 2,
                              fallbackLabel: currentUser?.initials ?? 'M',
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentUser?.fullName ?? 'Marcus Sterling',
                                    style: Theme.of(context).textTheme.titleLarge
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    currentUser?.subtitle ?? 'Estate Manager',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: _AdminPalette.muted,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  const _AdminTag(
                                    label: 'ADMIN ACCESS',
                                    background: Color(0x1A005BBF),
                                    foreground: AvenueColors.primary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        children: [
                          _AdminDrawerNavItem(
                            label: 'Dashboard',
                            icon: Icons.dashboard_rounded,
                            selected: currentPage == AppPage.adminDrawer,
                            onTap: () => goToPage(
                              context,
                              AppPage.adminDrawer,
                              replace: true,
                            ),
                          ),
                          _AdminDrawerNavItem(
                            label: 'Resident Directory',
                            icon: Icons.group_rounded,
                            selected: currentPage == AppPage.residentDirectory,
                            onTap: () => goToPage(
                              context,
                              AppPage.residentDirectory,
                              replace: true,
                            ),
                          ),
                          _AdminDrawerNavItem(
                            label: 'Announcements',
                            icon: Icons.campaign_rounded,
                            selected:
                                currentPage ==
                                AppPage.announcementsManagement,
                            onTap: () => goToPage(
                              context,
                              AppPage.announcementsManagement,
                              replace: true,
                            ),
                          ),
                          _AdminDrawerNavItem(
                            label: 'Generate Reports',
                            icon: Icons.summarize_rounded,
                            selected: currentPage == AppPage.generateReports,
                            onTap: () => goToPage(
                              context,
                              AppPage.generateReports,
                              replace: true,
                            ),
                          ),
                          _AdminDrawerNavItem(
                            label: 'Add Resident',
                            icon: Icons.person_add_alt_1_rounded,
                            selected: false,
                            onTap: () => goToPage(context, AppPage.addResident),
                          ),
                          const SizedBox(height: 20),
                          const _AdminSupportCard(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
                      child: TextButton.icon(
                        onPressed: () {
                          AppSession.instance.clear();
                          goToPage(context, AppPage.login, replace: true);
                        },
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: _AdminPalette.danger,
                        ),
                        label: Text(
                          'Logout',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: _AdminPalette.danger,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        style: TextButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
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
