part of 'resident_screens.dart';

class AmenitiesScreen extends StatefulWidget {
  const AmenitiesScreen({super.key});

  @override
  State<AmenitiesScreen> createState() => _AmenitiesScreenState();
}

class AmenityReservationsScreen extends StatelessWidget {
  const AmenityReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();

    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Reservations',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: repository.fetchCurrentUserAmenityBookings(),
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];

          return _ResidentScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Reservations',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Track upcoming and completed amenity bookings.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AvenueColors.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                if (snapshot.connectionState != ConnectionState.done &&
                    rows.isEmpty)
                  const _DataPlaceholderCard(label: 'Loading reservations...')
                else if (rows.isEmpty)
                  const _DataPlaceholderCard(
                    label: 'No amenity reservations yet.',
                  )
                else
                  ...rows.map((row) {
                    final amenity = row['amenities'] is Map
                        ? row['amenities'] as Map
                        : {};
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: AvenueCard(
                        radius: 24,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.network(
                                amenity['image_url'] as String? ??
                                    _poolImageUrl,
                                width: 78,
                                height: 78,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    amenity['name'] as String? ?? 'Amenity',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.w900),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${_calendarDateLabel(row['booking_date'])} • ${row['time_slot'] ?? '--'}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AvenueColors.onSurfaceVariant,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  AvenuePill(
                                    label:
                                        (row['booking_status'] ?? 'confirmed')
                                            .toString()
                                            .toUpperCase(),
                                    backgroundColor: const Color(0x1A005BBF),
                                    foregroundColor: AvenueColors.primary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          );
        },
      ),
      bottomNavigation: AvenueBottomNavigationBar(
        items: _residentNavItems,
        currentPage: AppPage.amenities,
      ),
    );
  }
}

class AmenityBookingScreen extends StatefulWidget {
  const AmenityBookingScreen({super.key, this.initialAmenity});

  final Map<String, dynamic>? initialAmenity;

  @override
  State<AmenityBookingScreen> createState() => _AmenityBookingScreenState();
}

class AmenityDetailsGymScreen extends StatelessWidget {
  const AmenityDetailsGymScreen({super.key, this.initialAmenity});

  final Map<String, dynamic>? initialAmenity;

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();

    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Amenity Details',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
        actions: [
          AvenueIconButton(icon: Icons.share_outlined, onPressed: () {}),
          const SizedBox(width: 12),
        ],
      ),
      body: FutureBuilder<_AmenitiesData>(
        future: _AmenitiesData.load(repository),
        builder: (context, snapshot) {
          final amenity = initialAmenity ?? snapshot.data?.gymAmenity;
          final capacityPercent =
              int.tryParse('${amenity?['capacity_percent'] ?? 0}') ?? 0;
          final occupancyValue =
              (capacityPercent.clamp(0, 100) as num).toDouble() / 100;
          final bookingRequired = amenity?['booking_required'] != false;
          final availableNow = amenity?['available_now'] == true;
          final rules = _amenityRules(amenity);

          return _ResidentScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              children: [
                _HeroImageCard(
                  imageUrl:
                      amenity?['image_url'] as String? ??
                      (amenity == null
                          ? _gymDetailImageUrl
                          : _amenityFallbackImage(amenity)),
                  height: 260,
                  borderRadius: 32,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            AvenuePill(
                              label:
                                  amenity?['status_label'] as String? ??
                                  'AVAILABLE',
                              backgroundColor: _amenityStatusBackground(
                                amenity?['status_label'] as String?,
                              ),
                              foregroundColor: _amenityStatusForeground(
                                amenity?['status_label'] as String?,
                              ),
                            ),
                            AvenuePill(
                              label:
                                  amenity?['location_label'] as String? ??
                                  'Cove',
                              backgroundColor: const Color(0x33000000),
                              foregroundColor: Colors.white,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          amenity?['name'] as String? ?? 'Modern Gym',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(color: Colors.white, fontSize: 22),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -8),
                  child: AvenueCard(
                    radius: 32,
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          amenity?['description'] as String? ??
                              'Elevate your wellness journey in our state-of-the-art fitness center.',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: AvenueColors.onSurfaceVariant,
                                height: 1.55,
                              ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Live Occupancy',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                amenity?['occupancy_note'] as String? ??
                                    (capacityPercent > 0
                                        ? '$capacityPercent% Full'
                                        : 'Open Now'),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: AvenueColors.primary,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: occupancyValue,
                            minHeight: 8,
                            backgroundColor: AvenueColors.surfaceHigh,
                            valueColor: const AlwaysStoppedAnimation(
                              AvenueColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          amenity?['availability_text'] as String? ??
                              'Peak hours expected until 8:00 PM',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: _InfoMiniCard(
                                icon: Icons.schedule_rounded,
                                title: 'Availability',
                                subtitle:
                                    amenity?['availability_text'] as String? ??
                                    'Daily access',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _InfoMiniCard(
                                icon: Icons.place_rounded,
                                title: 'Location',
                                subtitle:
                                    amenity?['location_label'] as String? ??
                                    'Cove',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Access & Rules',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _EquipmentChip(
                              icon: _amenityIconForCategory(
                                amenity?['category'] as String?,
                              ),
                              label:
                                  (amenity?['category'] as String? ?? 'Amenity')
                                      .toUpperCase(),
                            ),
                            _EquipmentChip(
                              icon: bookingRequired
                                  ? Icons.event_available_rounded
                                  : Icons.verified_rounded,
                              label: bookingRequired
                                  ? 'BOOKING'
                                  : 'OPEN ACCESS',
                            ),
                            if ((amenity?['access_note'] as String?)
                                    ?.isNotEmpty ==
                                true)
                              const _EquipmentChip(
                                icon: Icons.badge_rounded,
                                label: 'ACCESS NOTE',
                              ),
                          ],
                        ),
                        if ((amenity?['access_note'] as String?)?.isNotEmpty ==
                            true) ...[
                          const SizedBox(height: 14),
                          Text(
                            amenity!['access_note'] as String,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AvenueColors.onSurfaceVariant,
                                  height: 1.45,
                                ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        ...rules.map(
                          (rule) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _BulletLine(text: rule),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          bookingRequired ? 'Book a Slot' : 'Access Details',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        AvenuePill(
                          label: bookingRequired
                              ? 'BOOKING AVAILABLE'
                              : 'NO BOOKING REQUIRED',
                          backgroundColor: const Color(0x1A8FA8FF),
                          foregroundColor: const Color(0xFF6E82FF),
                        ),
                        const SizedBox(height: 14),
                        AvenuePrimaryButton(
                          label: bookingRequired ? 'Book Now' : 'View Access',
                          onPressed: () {
                            if (amenity == null) {
                              return;
                            }
                            if (!bookingRequired) {
                              showAvenueDialogMessage(
                                context,
                                message:
                                    'This amenity is open access and does not need a booking.',
                                type: AvenueMessageType.info,
                              );
                              return;
                            }
                            if (!availableNow) {
                              showAvenueDialogMessage(
                                context,
                                message:
                                    'This amenity is not available for booking right now.',
                                type: AvenueMessageType.error,
                              );
                              return;
                            }
                            _openAmenityBooking(context, amenity);
                          },
                        ),
                      ],
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
        currentPage: AppPage.amenities,
      ),
    );
  }
}

class NoticesScreen extends StatefulWidget {
  const NoticesScreen({super.key});

  @override
  State<NoticesScreen> createState() => _NoticesScreenState();
}

class BillsScreen extends StatelessWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();

    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Manage Bills',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => goBackOrHome(context),
          size: 40,
        ),
        actions: [
          AvenueIconButton(icon: Icons.history_rounded, onPressed: () {}),
          const SizedBox(width: 12),
        ],
      ),
      body: FutureBuilder<_BillsData>(
        future: _BillsData.load(repository),
        builder: (context, snapshot) {
          final bills = snapshot.data?.bills ?? const <Map<String, dynamic>>[];
          final methods =
              snapshot.data?.paymentMethods ?? const <Map<String, dynamic>>[];
          final activity =
              snapshot.data?.paymentActivity ?? const <Map<String, dynamic>>[];

          return _ResidentScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Accounts',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 14),
                if (snapshot.connectionState != ConnectionState.done &&
                    bills.isEmpty)
                  const _DataPlaceholderCard(label: 'Loading bills...')
                else
                  ...bills.map(
                    (bill) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _BillAccountCard(
                        icon: _billIconForCategory(bill['category'] as String?),
                        title: bill['title'] as String? ?? 'Bill',
                        subtitle: bill['provider'] as String? ?? '',
                        badgeText: bill['badge_text'] as String? ?? '',
                        badgeColor: _billBadgeColor(bill['state'] as String?),
                        badgeTextColor: _billBadgeTextColor(
                          bill['state'] as String?,
                        ),
                        metaLabel: _billMetaLabel(bill['state'] as String?),
                        amount: _currencyLabel(
                          bill['amount_due'] ?? bill['amount_paid'],
                        ),
                        amountColor: _billAmountColor(bill['state'] as String?),
                        buttonLabel: bill['action_label'] as String?,
                      ),
                    ),
                  ),
                const SizedBox(height: 14),
                AvenueCard(
                  radius: 0,
                  padding: const EdgeInsets.symmetric(vertical: 26),
                  border: Border.all(
                    color: AvenueColors.outlineVariant.withValues(alpha: 0.65),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: const BoxDecoration(
                          color: AvenueColors.surfaceLow,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: AvenueColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Add New Bill',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Link a new utility account',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Quick Pay',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 14),
                if (methods.isEmpty)
                  const _DataPlaceholderCard(label: 'No saved payment methods.')
                else
                  Row(
                    children: methods.take(2).map((method) {
                      final isPrimary = method['is_primary'] == true;
                      final icon = method['method_type'] == 'card'
                          ? Icons.credit_card_rounded
                          : Icons.account_balance_rounded;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: method == methods.first && methods.length > 1
                                ? 12
                                : 0,
                          ),
                          child: _QuickPayCard(
                            dark: isPrimary,
                            title: method['method_name'] as String? ?? 'Method',
                            subtitle:
                                method['masked_value'] as String? ?? 'Saved',
                            trailing: icon,
                            note: method['note'] as String? ?? '',
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 20),
                const AvenueSectionHeader(
                  title: 'Recent Activity',
                  actionLabel: 'View All',
                ),
                const SizedBox(height: 12),
                if (activity.isEmpty)
                  const _DataPlaceholderCard(label: 'No payment activity yet.')
                else
                  ...activity.map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _PaymentActivityTile(
                        icon: _activityIconForCategory(
                          row['activity_category'] as String?,
                        ),
                        title: row['activity_title'] as String? ?? 'Activity',
                        date: _dateTimeLabel(row['activity_at']),
                        amount: _currencyLabel(row['amount'], signed: true),
                        status: row['status'] as String? ?? '',
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigation: AvenueBottomNavigationBar(
        items: _billingNavItems,
        currentPage: AppPage.bills,
      ),
    );
  }
}
