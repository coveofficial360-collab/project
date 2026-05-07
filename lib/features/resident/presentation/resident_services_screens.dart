part of 'resident_screens.dart';

IconData _serviceCategoryIcon(String? category) {
  switch ((category ?? '').toLowerCase()) {
    case 'electrical':
      return Icons.electrical_services_rounded;
    case 'plumbing':
      return Icons.plumbing_rounded;
    case 'cleaning':
    case 'housekeeping':
      return Icons.cleaning_services_rounded;
    case 'chef':
    case 'culinary':
      return Icons.restaurant_menu_rounded;
    default:
      return Icons.handyman_rounded;
  }
}

String _residentInitialsFromName(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();
  if (parts.isEmpty) {
    return 'SP';
  }
  if (parts.length == 1) {
    return parts.first.substring(0, 1).toUpperCase();
  }
  return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
      .toUpperCase();
}

class ResidentServicesScreen extends StatefulWidget {
  const ResidentServicesScreen({super.key});

  @override
  State<ResidentServicesScreen> createState() => _ResidentServicesScreenState();
}

class _ResidentServicesScreenState extends State<ResidentServicesScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pushNamed(
                      AppPage.drawer.routeName,
                      arguments: AppPage.residentServices,
                    ),
                    icon: const Icon(Icons.menu_rounded),
                  ),
                  Expanded(
                    child: Text(
                      'Service Directory',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: AvenueRepository().fetchResidentServiceProviders(),
                builder: (context, snapshot) {
                  final rows = snapshot.data ?? const <Map<String, dynamic>>[];
                  final categories = <String>{
                    'All',
                    ...rows
                        .map(
                          (row) =>
                              row['service_category']?.toString().trim() ?? '',
                        )
                        .where((value) => value.isNotEmpty),
                  }.toList();
                  final filtered = _selectedCategory == 'All'
                      ? rows
                      : rows
                            .where(
                              (row) =>
                                  row['service_category']
                                      ?.toString()
                                      .toLowerCase() ==
                                  _selectedCategory.toLowerCase(),
                            )
                            .toList();

                  return _ResidentScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ServiceHeroCard(
                          title: 'Home Services',
                          subtitle:
                              'Electrician, plumber, carpenter, housekeeping and more.',
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 40,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 10),
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              final selected = category == _selectedCategory;
                              return ChoiceChip(
                                label: Text(category),
                                selected: selected,
                                onSelected: (_) {
                                  setState(() => _selectedCategory = category);
                                },
                                selectedColor: AvenueColors.primary,
                                labelStyle: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : AvenueColors.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                                side: BorderSide(
                                  color: selected
                                      ? AvenueColors.primary
                                      : const Color(0xFFD8E0EA),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'Top Specialists',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 14),
                        if (snapshot.connectionState != ConnectionState.done)
                          const _DataPlaceholderCard(
                            label: 'Loading service specialists...',
                          )
                        else if (filtered.isEmpty)
                          const _DataPlaceholderCard(
                            label:
                                'No specialists available in this category yet.',
                          )
                        else
                          ...filtered.map(
                            (provider) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _ServiceProviderCard(
                                provider: provider,
                                onTap: () => Navigator.of(context).pushNamed(
                                  AppPage.residentServiceProfile.routeName,
                                  arguments: {
                                    'providerId': provider['id']?.toString(),
                                  },
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigation: AvenueBottomNavigationBar(
        items: _visitorNavItems,
        currentPage: AppPage.residentServices,
      ),
    );
  }
}

class ResidentServiceProfileScreen extends StatelessWidget {
  const ResidentServiceProfileScreen({super.key, this.providerId});

  final String? providerId;

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: providerId == null
              ? Future<Map<String, dynamic>?>.value(null)
              : AvenueRepository().fetchResidentServiceProviderById(
                  providerId!,
                ),
          builder: (context, snapshot) {
            final provider = snapshot.data;
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(color: AvenueColors.primary),
              );
            }

            if (provider == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'This specialist is no longer available.',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final skills =
                (provider['skills'] as List?)
                    ?.map((skill) => skill.toString())
                    .toList() ??
                const <String>[];

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      Expanded(
                        child: Text(
                          'Specialist Profile',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: _ResidentScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ProfileHeroCard(provider: provider),
                        const SizedBox(height: 18),
                        _ProfileInfoCard(
                          title: 'About Specialist',
                          child: Text(
                            provider['bio']?.toString().trim().isNotEmpty ==
                                    true
                                ? provider['bio'].toString()
                                : provider['specialty']?.toString() ??
                                      'Trusted service specialist for your community needs.',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(height: 1.5),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _ProfileInfoCard(
                          title: 'Highlights',
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _ProfileStatPill(
                                icon: Icons.workspace_premium_rounded,
                                label:
                                    '${provider['years_experience'] ?? 0} yrs exp',
                              ),
                              _ProfileStatPill(
                                icon: Icons.star_rounded,
                                label: '${provider['rating'] ?? '--'} rating',
                              ),
                              _ProfileStatPill(
                                icon: Icons.task_alt_rounded,
                                label:
                                    '${provider['jobs_completed'] ?? '--'} jobs',
                              ),
                              if (provider['starting_price'] != null)
                                _ProfileStatPill(
                                  icon: Icons.currency_rupee_rounded,
                                  label:
                                      'Starts ${_currencyLabel(provider['starting_price'])}',
                                ),
                            ],
                          ),
                        ),
                        if (skills.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          _ProfileInfoCard(
                            title: 'Skills',
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: skills
                                  .map(
                                    (skill) => Chip(
                                      label: Text(skill),
                                      backgroundColor: const Color(0xFFEAF0FF),
                                      labelStyle: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AvenueColors.primary,
                                      ),
                                      side: BorderSide.none,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Scheduling flow for ${provider['full_name'] ?? 'this specialist'} can be added next.',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.calendar_month_rounded),
                            label: const Text('Schedule Service'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AvenueColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigation: AvenueBottomNavigationBar(
        items: _visitorNavItems,
        currentPage: AppPage.residentServiceProfile,
      ),
    );
  }
}

class _ServiceHeroCard extends StatelessWidget {
  const _ServiceHeroCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.86),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceProviderCard extends StatelessWidget {
  const _ServiceProviderCard({required this.provider, required this.onTap});

  final Map<String, dynamic> provider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = provider['avatar_url']?.toString() ?? '';
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvenueNetworkAvatar(
                imageUrl: avatarUrl,
                size: 64,
                fallbackLabel: _residentInitialsFromName(
                  provider['full_name']?.toString() ?? 'SP',
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider['full_name']?.toString() ?? 'Specialist',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      provider['short_tagline']?.toString().trim().isNotEmpty ==
                              true
                          ? provider['short_tagline'].toString()
                          : provider['specialty']?.toString() ??
                                'Community specialist',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AvenueColors.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        _ServiceMeta(
                          icon: _serviceCategoryIcon(
                            provider['service_category'] as String?,
                          ),
                          label:
                              provider['service_category']?.toString() ??
                              'General',
                        ),
                        _ServiceMeta(
                          icon: Icons.star_rounded,
                          label: '${provider['rating'] ?? '--'}',
                        ),
                        _ServiceMeta(
                          icon: Icons.task_alt_rounded,
                          label: '${provider['jobs_completed'] ?? '--'} jobs',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceMeta extends StatelessWidget {
  const _ServiceMeta({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AvenueColors.primary),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _ProfileHeroCard extends StatelessWidget {
  const _ProfileHeroCard({required this.provider});

  final Map<String, dynamic> provider;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = provider['avatar_url']?.toString() ?? '';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          AvenueNetworkAvatar(
            imageUrl: avatarUrl,
            size: 92,
            fallbackLabel: _residentInitialsFromName(
              provider['full_name']?.toString() ?? 'SP',
            ),
          ),
          const SizedBox(height: 14),
          Text(
            provider['full_name']?.toString() ?? 'Specialist',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            provider['short_tagline']?.toString().trim().isNotEmpty == true
                ? provider['short_tagline'].toString()
                : provider['specialty']?.toString() ??
                      'Trusted community specialist',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AvenueColors.primary,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              _ProfileStatPill(
                icon: Icons.phone_rounded,
                label: provider['phone']?.toString() ?? 'Call support',
              ),
              _ProfileStatPill(
                icon: Icons.verified_rounded,
                label:
                    provider['availability_status']?.toString() ?? 'Available',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  const _ProfileInfoCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              letterSpacing: 1,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _ProfileStatPill extends StatelessWidget {
  const _ProfileStatPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF0FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AvenueColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AvenueColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
