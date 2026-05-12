part of 'resident_screens.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class CreateComplaintScreen extends StatefulWidget {
  const CreateComplaintScreen({super.key});

  @override
  State<CreateComplaintScreen> createState() => _CreateComplaintScreenState();
}

class ComplaintDetailScreen extends StatelessWidget {
  const ComplaintDetailScreen({required this.row, super.key});

  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) {
    final state = row['state'] as String?;
    final accentColor = Color(
      int.parse(
        (row['accent_hex'] as String? ?? '#E2E3E8').replaceFirst('#', '0xFF'),
      ),
    );

    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Complaint Details',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => Navigator.of(context).pop(),
          size: 40,
        ),
      ),
      body: _ResidentScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AvenueCard(
              radius: 28,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.45),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _complaintIcon(row['icon_name'] as String?),
                          color: AvenueColors.onSurface,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '#${row['code'] ?? '--'}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              row['title'] as String? ?? 'Complaint',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ),
                      AvenuePill(
                        label: _complaintStatusLabel(state),
                        backgroundColor: _complaintStatusColor(
                          state,
                        ).withValues(alpha: 0.12),
                        foregroundColor: _complaintStatusColor(state),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    row['description'] as String? ?? '',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AvenueColors.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            AvenueCard(
              radius: 24,
              child: Column(
                children: [
                  _ComplaintDetailRow(
                    icon: Icons.category_outlined,
                    label: 'Category',
                    value: _complaintCategoryLabel(row['category'] as String?),
                  ),
                  _ComplaintDetailRow(
                    icon: Icons.priority_high_rounded,
                    label: 'Urgency',
                    value: _complaintUrgencyLabel(row['urgency'] as String?),
                  ),
                  _ComplaintDetailRow(
                    icon: Icons.location_on_outlined,
                    label: 'Location',
                    value: _optionalText(row['location_label']),
                  ),
                  _ComplaintDetailRow(
                    icon: Icons.schedule_rounded,
                    label: 'Preferred Access',
                    value: _optionalText(row['preferred_access_time']),
                  ),
                  _ComplaintDetailRow(
                    icon: Icons.engineering_outlined,
                    label: row['meta_label'] as String? ?? 'Status',
                    value: row['meta_value'] as String? ?? '-',
                  ),
                  _ComplaintDetailRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Created',
                    value: _dateTimeLabel(row['created_at']),
                    showDivider: false,
                  ),
                ],
              ),
            ),
            if ((row['admin_notes'] as String?)?.isNotEmpty ?? false) ...[
              const SizedBox(height: 14),
              _ComplaintInfoBanner(
                icon: Icons.admin_panel_settings_outlined,
                title: 'ADMIN NOTE',
                body: row['admin_notes'] as String,
              ),
            ],
            if ((row['resolution_note'] as String?)?.isNotEmpty ?? false) ...[
              const SizedBox(height: 14),
              _ComplaintInfoBanner(
                icon: Icons.verified_rounded,
                title: 'RESOLUTION',
                body: row['resolution_note'] as String,
              ),
            ],
            if ((row['photo_url'] as String?)?.isNotEmpty ?? false) ...[
              const SizedBox(height: 14),
              _ComplaintInfoBanner(
                icon: Icons.photo_outlined,
                title: 'PHOTO',
                body: row['photo_url'] as String,
              ),
            ],
          ],
        ),
      ),
      bottomNavigation: AvenueBottomNavigationBar(
        items: _residentNavItems,
        currentPage: AppPage.complaints,
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();

    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'My Profile',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
      ),
      body: FutureBuilder<_ResidentProfileData>(
        future: _ResidentProfileData.load(repository),
        builder: (context, snapshot) {
          final data = snapshot.data;
          final profile = data?.profile;
          final family = data?.familyMembers ?? const <Map<String, dynamic>>[];
          final vehicles = data?.vehicles ?? const <Map<String, dynamic>>[];

          return _ResidentScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvenueCard(
                  radius: 24,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 26,
                  ),
                  color: const Color(0xFFEAF0FF),
                  child: Center(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            AvenueNetworkAvatar(
                              imageUrl:
                                  profile?.avatarUrl ??
                                  AppSession.instance.currentUser?.avatarUrl ??
                                  _profileAvatarUrl,
                              size: 96,
                              borderWidth: 4,
                              fallbackLabel:
                                  profile?.initials ??
                                  AppSession.instance.currentUser?.initials ??
                                  'AS',
                            ),
                            Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AvenueColors.primaryGradient,
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          profile?.fullName ??
                              AppSession.instance.currentUser?.fullName ??
                              'Resident',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile?.subtitle ??
                              AppSession.instance.currentUser?.subtitle ??
                              '-',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: AvenueColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                AvenueCard(
                  radius: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal Info',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _ProfileFieldRow(
                        label: 'FULL NAME',
                        value: profile?.fullName ?? 'Not available',
                      ),
                      const SizedBox(height: 18),
                      _ProfileFieldRow(
                        label: 'EMAIL ADDRESS',
                        value: profile?.email ?? 'Not available',
                      ),
                      const SizedBox(height: 18),
                      _ProfileFieldRow(
                        label: 'PHONE NUMBER',
                        value: profile?.phone ?? 'Not available',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                AvenueCard(
                  radius: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Family Members',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (snapshot.connectionState != ConnectionState.done &&
                          family.isEmpty)
                        const _DataPlaceholderCard(label: 'Loading family...')
                      else
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            ...family.map(
                              (member) => SizedBox(
                                width: 132,
                                child: _FamilyMemberChip(
                                  imageUrl:
                                      member['avatar_url'] as String? ??
                                      _priyaAvatarUrl,
                                  name:
                                      member['full_name'] as String? ??
                                      'Member',
                                  relation: member['relation'] as String? ?? '',
                                ),
                              ),
                            ),
                            Container(
                              width: 132,
                              height: 62,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: AvenueColors.outlineVariant,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '+  Add Member',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: AvenueColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                AvenueCard(
                  radius: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Vehicles',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.add_rounded,
                            color: AvenueColors.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (snapshot.connectionState != ConnectionState.done &&
                          vehicles.isEmpty)
                        const _DataPlaceholderCard(label: 'Loading vehicle...')
                      else if (vehicles.isEmpty)
                        const _DataPlaceholderCard(
                          label: 'No vehicles added yet.',
                        )
                      else
                        ...vehicles.map(
                          (vehicle) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AvenueColors.surfaceLow,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: const Icon(
                                      Icons.directions_car_filled_outlined,
                                      color: AvenueColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          vehicle['registration_number']
                                                  as String? ??
                                              '-',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          vehicle['vehicle_name'] as String? ??
                                              '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: AvenueColors
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.copy_outlined,
                                    color: AvenueColors.outline,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      AppSession.instance.clear();
                      goToPage(context, AppPage.login, replace: true);
                    },
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Logout'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEB4B3D),
                      side: const BorderSide(color: Color(0xFFEB4B3D)),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      textStyle: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
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
        currentPage: null,
      ),
    );
  }
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class VisitorScreen extends StatefulWidget {
  const VisitorScreen({super.key});

  @override
  State<VisitorScreen> createState() => _VisitorScreenState();
}
