part of 'admin_screens.dart';

class AdminAmenitiesScreen extends StatefulWidget {
  const AdminAmenitiesScreen({super.key});

  @override
  State<AdminAmenitiesScreen> createState() => _AdminAmenitiesScreenState();
}

class _AdminAmenitiesScreenState extends State<AdminAmenitiesScreen> {
  final AvenueRepository _repository = AvenueRepository();
  late Future<List<Map<String, dynamic>>> _amenitiesFuture;
  final Set<String> _updatingAmenityIds = <String>{};

  @override
  void initState() {
    super.initState();
    _amenitiesFuture = _repository.fetchAmenities();
  }

  void _refresh() {
    setState(() {
      _amenitiesFuture = _repository.fetchAmenities();
    });
  }

  Future<void> _openAmenityEditor(Map<String, dynamic> row) async {
    final updated = await Navigator.of(
      context,
    ).pushNamed(AppPage.editAmenity.routeName, arguments: {'amenity': row});

    if (updated == true && mounted) {
      _refresh();
    }
  }

  Future<void> _updateAmenityStatus(
    Map<String, dynamic> row,
    String statusLabel,
  ) async {
    final amenityId = row['id']?.toString();
    if (amenityId == null || _updatingAmenityIds.contains(amenityId)) {
      return;
    }

    setState(() {
      _updatingAmenityIds.add(amenityId);
    });

    try {
      final result = await _repository.updateAdminAmenityStatus(
        amenityId: amenityId,
        statusLabel: statusLabel,
      );

      if (!mounted) {
        return;
      }

      if (result == null) {
        showAvenueDialogMessage(
          context,
          message: 'Could not update amenity status right now.',
          type: AvenueMessageType.error,
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${result['name'] ?? row['name'] ?? 'Amenity'} marked ${result['status_label'] ?? statusLabel}.',
          ),
        ),
      );
      _refresh();
    } catch (error) {
      if (mounted) {
        showAvenueDialogMessage(
          context,
          message:
              'Could not update amenity status: ${_friendlyAmenityError(error)}',
          type: AvenueMessageType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _updatingAmenityIds.remove(amenityId);
        });
      }
    }
  }

  Widget _buildAmenityCard(
    Map<String, dynamic> row, {
    required double height,
    bool featured = false,
  }) {
    final amenityId = row['id']?.toString();
    return _AdminAmenityMosaicCard(
      row: row,
      height: height,
      featured: featured,
      isProcessing:
          amenityId != null && _updatingAmenityIds.contains(amenityId),
      onEdit: () => _openAmenityEditor(row),
      onSetOpen: () => _updateAmenityStatus(row, 'OPEN'),
      onSetMaintenance: () => _updateAmenityStatus(row, 'MAINTENANCE'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _AdminScaffold(
      currentPage: AppPage.adminAmenities,
      topBar: _AdminTopBar(
        title: 'Amenities',
        leadingIcon: Icons.menu_rounded,
        onLeadingTap: () => _openAdminMenu(context, AppPage.adminAmenities),
        trailing: IconButton(
          onPressed: _refresh,
          icon: const Icon(Icons.refresh_rounded),
          color: AvenueColors.primary,
        ),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _amenitiesFuture,
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          final openCount = rows
              .where((row) => row['available_now'] == true)
              .length;
          final maintenanceCount = rows
              .where(
                (row) => _normalize(
                  row['status_label']?.toString() ?? '',
                ).contains('maintenance'),
              )
              .length;
          final featuredRows = rows.take(5).toList();
          final remainingRows = rows.skip(5).toList();

          return _AdminBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _AdminSectionLabel(text: 'ADMINISTRATIVE OVERVIEW'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Amenity Status',
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(fontSize: 32, height: 1.05),
                      ),
                    ),
                    IconButton.filled(
                      onPressed: () async {
                        final created = await Navigator.of(
                          context,
                        ).pushNamed(AppPage.addAmenity.routeName);
                        if (created == true) {
                          _refresh();
                        }
                      },
                      icon: const Icon(Icons.add_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _AdminStatusPill(
                      label: '$openCount Open Now',
                      color: _AdminPalette.success,
                    ),
                    _AdminStatusPill(
                      label: '$maintenanceCount Maintenance',
                      color: _AdminPalette.warning,
                    ),
                    _AdminStatusPill(
                      label: '${rows.length} Total Spaces',
                      color: AvenueColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (snapshot.connectionState != ConnectionState.done &&
                    rows.isEmpty)
                  const _AdminEmptyState(label: 'Loading amenities...')
                else if (rows.isEmpty)
                  const _AdminEmptyState(label: 'No amenities found.')
                else ...[
                  _buildAmenityCard(
                    featuredRows.first,
                    height: 360,
                    featured: true,
                  ),
                  const SizedBox(height: 16),
                  if (featuredRows.length > 1)
                    _buildAmenityCard(featuredRows[1], height: 260),
                  const SizedBox(height: 16),
                  ...featuredRows
                      .skip(2)
                      .map(
                        (row) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildAmenityCard(row, height: 230),
                        ),
                      ),
                  ...remainingRows.map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildAmenityCard(row, height: 230),
                    ),
                  ),
                ],
                const SizedBox(height: 22),
                Text(
                  'Recent Log Activity',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                _AdminGlassCard(
                  radius: 24,
                  child: Column(
                    children: [
                      _AdminRecentAmenityAction(
                        icon: Icons.event_available_rounded,
                        tint: const Color(0xFFE8F1FF),
                        title: 'View booking feed',
                        subtitle: 'Upcoming and completed resident bookings',
                        onTap: () =>
                            goToPage(context, AppPage.adminAmenityBookings),
                      ),
                      Divider(
                        height: 1,
                        color: _AdminPalette.outline.withValues(alpha: 0.18),
                      ),
                      _AdminRecentAmenityAction(
                        icon: Icons.add_circle_outline_rounded,
                        tint: const Color(0xFFFFF0D8),
                        title: 'Add a new amenity',
                        subtitle: 'Publish a resident-facing amenity space',
                        onTap: () async {
                          final created = await Navigator.of(
                            context,
                          ).pushNamed(AppPage.addAmenity.routeName);
                          if (created == true) {
                            _refresh();
                          }
                        },
                      ),
                    ],
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

class _AdminStatusPill extends StatelessWidget {
  const _AdminStatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: _AdminPalette.surface,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: _AdminPalette.shadow,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _AdminAmenityMosaicCard extends StatelessWidget {
  const _AdminAmenityMosaicCard({
    required this.row,
    this.height = 240,
    this.featured = false,
    required this.onEdit,
    required this.onSetOpen,
    required this.onSetMaintenance,
    this.isProcessing = false,
  });

  final Map<String, dynamic> row;
  final double height;
  final bool featured;
  final VoidCallback onEdit;
  final VoidCallback onSetOpen;
  final VoidCallback onSetMaintenance;
  final bool isProcessing;

  @override
  Widget build(BuildContext context) {
    final status = row['status_label']?.toString() ?? 'OPEN';
    final capacity = row['capacity_percent'] is int
        ? row['capacity_percent'] as int
        : int.tryParse(row['capacity_percent']?.toString() ?? '0') ?? 0;
    final isOpen =
        _normalize(status).contains('open') ||
        _normalize(status).contains('active') ||
        row['available_now'] == true;
    final isMaintenance = _normalize(status).contains('maintenance');

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              row['image_url'] as String? ?? _adminPoolImageUrl,
              fit: BoxFit.cover,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xE6000000), Color(0x33000000)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              top: 18,
              left: 18,
              right: 18,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _AdminOverlayPill(
                    label: isOpen ? 'Open Now' : status,
                    icon: isOpen
                        ? Icons.circle_rounded
                        : Icons.construction_rounded,
                    foreground: isOpen
                        ? _AdminPalette.success
                        : _AdminPalette.warning,
                  ),
                  _AdminOverlayPill(
                    label: '$capacity% Capacity',
                    foreground: Colors.white,
                    dark: true,
                  ),
                ],
              ),
            ),
            Positioned(
              left: 22,
              right: 22,
              bottom: 22,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    row['name'] as String? ?? 'Amenity',
                    maxLines: featured ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontSize: featured ? 30 : 22,
                      height: 1.08,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${row['location_label'] ?? 'Avenue360'} • ${row['availability_text'] ?? row['occupancy_note'] ?? 'Resident access enabled'}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.82),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _AdminAmenityActionButton(
                        label: 'Open',
                        icon: Icons.circle_rounded,
                        onTap: isProcessing ? null : onSetOpen,
                        selected: isOpen,
                        foreground: _AdminPalette.success,
                      ),
                      _AdminAmenityActionButton(
                        label: 'Edit',
                        icon: Icons.edit_rounded,
                        onTap: isProcessing ? null : onEdit,
                        foreground: Colors.white,
                        dark: true,
                      ),
                      _AdminAmenityActionButton(
                        label: 'Maintenance',
                        icon: Icons.build_rounded,
                        onTap: isProcessing ? null : onSetMaintenance,
                        selected: isMaintenance,
                        foreground: _AdminPalette.warning,
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

class _AdminOverlayPill extends StatelessWidget {
  const _AdminOverlayPill({
    required this.label,
    required this.foreground,
    this.icon,
    this.dark = false,
  });

  final String label;
  final Color foreground;
  final IconData? icon;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: dark
            ? Colors.black.withValues(alpha: 0.26)
            : Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: foreground),
            const SizedBox(width: 7),
          ],
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w900,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminAmenityActionButton extends StatelessWidget {
  const _AdminAmenityActionButton({
    required this.label,
    required this.icon,
    required this.foreground,
    this.onTap,
    this.selected = false,
    this.dark = false,
  });

  final String label;
  final IconData icon;
  final Color foreground;
  final VoidCallback? onTap;
  final bool selected;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = dark
        ? Colors.black.withValues(alpha: 0.24)
        : selected
        ? foreground.withValues(alpha: 0.18)
        : Colors.white.withValues(alpha: 0.92);
    final effectiveForeground = dark ? Colors.white : foreground;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? foreground.withValues(alpha: 0.42)
                : Colors.white.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: effectiveForeground),
            const SizedBox(width: 6),
            Text(
              label.toUpperCase(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: effectiveForeground,
                fontWeight: FontWeight.w900,
                fontSize: 10,
                letterSpacing: 0.9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminRecentAmenityAction extends StatelessWidget {
  const _AdminRecentAmenityAction({
    required this.icon,
    required this.tint,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color tint;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
              child: Icon(icon, color: AvenueColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _AdminPalette.muted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: _AdminPalette.muted),
          ],
        ),
      ),
    );
  }
}

class AddAmenityScreen extends StatefulWidget {
  const AddAmenityScreen({super.key, this.initialAmenity});

  final Map<String, dynamic>? initialAmenity;

  @override
  State<AddAmenityScreen> createState() => _AddAmenityScreenState();
}

class _AddAmenityScreenState extends State<AddAmenityScreen> {
  final AvenueRepository _repository = AvenueRepository();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();
  final TextEditingController _occupancyController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController(
    text: '0',
  );
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _accessNoteController = TextEditingController();
  final TextEditingController _ruleOneController = TextEditingController(
    text: 'Carry your resident ID.',
  );
  final TextEditingController _ruleTwoController = TextEditingController(
    text: 'Keep the space clean for the next resident.',
  );

  String _status = 'OPEN';
  String _category = 'Wellness';
  bool _bookingRequired = true;
  bool _isSubmitting = false;
  bool _isLoadingAmenityData = false;
  String? _submitErrorMessage;
  final List<_AmenitySlotDraft> _slots = [
    _AmenitySlotDraft(start: '08:00', end: '10:00', capacity: '15'),
    _AmenitySlotDraft(start: '10:30', end: '12:30', capacity: '15'),
  ];

  bool get _isEditing => widget.initialAmenity != null;

  @override
  void initState() {
    super.initState();
    _applyInitialAmenity();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _availabilityController.dispose();
    _occupancyController.dispose();
    _capacityController.dispose();
    _imageUrlController.dispose();
    _accessNoteController.dispose();
    _ruleOneController.dispose();
    _ruleTwoController.dispose();
    for (final slot in _slots) {
      slot.dispose();
    }
    super.dispose();
  }

  void _addSlot() {
    setState(() {
      _slots.add(
        _AmenitySlotDraft(start: '09:00', end: '17:00', capacity: '10'),
      );
    });
  }

  void _removeSlot(int index) {
    setState(() {
      final slot = _slots.removeAt(index);
      slot.dispose();
    });
  }

  void _replaceSlots(List<_AmenitySlotDraft> nextSlots) {
    for (final slot in _slots) {
      slot.dispose();
    }
    _slots
      ..clear()
      ..addAll(nextSlots);
  }

  void _applyInitialAmenity() {
    final amenity = widget.initialAmenity;
    if (amenity == null) {
      return;
    }

    _nameController.text = amenity['name']?.toString() ?? '';
    _descriptionController.text = amenity['description']?.toString() ?? '';
    _locationController.text = amenity['location_label']?.toString() ?? '';
    _availabilityController.text =
        amenity['availability_text']?.toString() ?? '';
    _occupancyController.text = amenity['occupancy_note']?.toString() ?? '';
    _capacityController.text = '${amenity['capacity_percent'] ?? 0}';
    _imageUrlController.text = amenity['image_url']?.toString() ?? '';
    _accessNoteController.text = amenity['access_note']?.toString() ?? '';
    _status = amenity['status_label']?.toString().toUpperCase() ?? _status;
    _category = amenity['category']?.toString() ?? _category;
    _bookingRequired = amenity['booking_required'] != false;

    final rules = amenity['rules'];
    if (rules is List && rules.isNotEmpty) {
      _ruleOneController.text = rules.first?.toString() ?? '';
      _ruleTwoController.text = rules.length > 1
          ? rules[1]?.toString() ?? ''
          : '';
    }

    _loadAmenityTimeSlots();
  }

  Future<void> _loadAmenityTimeSlots() async {
    final amenityId = widget.initialAmenity?['id']?.toString();
    if (amenityId == null) {
      return;
    }

    setState(() {
      _isLoadingAmenityData = true;
    });

    try {
      final slotRows = await _repository.fetchAmenityTimeSlots(amenityId);
      final nextSlots = slotRows.isEmpty
          ? <_AmenitySlotDraft>[
              _AmenitySlotDraft(start: '09:00', end: '17:00', capacity: '10'),
            ]
          : slotRows
                .map(
                  (row) => _AmenitySlotDraft(
                    start: _formatAmenitySlotTime(row['start_time']),
                    end: _formatAmenitySlotTime(row['end_time']),
                    capacity: '${row['slot_capacity'] ?? 1}',
                  ),
                )
                .toList();

      if (!mounted) {
        for (final slot in nextSlots) {
          slot.dispose();
        }
        return;
      }

      setState(() {
        _replaceSlots(nextSlots);
        _isLoadingAmenityData = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoadingAmenityData = false;
        });
      }
    }
  }

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }
    if (_nameController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty ||
        _locationController.text.trim().isEmpty) {
      showAvenueDialogMessage(
        context,
        title: 'Missing details',
        message: 'Add name, category, description, and location.',
        type: AvenueMessageType.error,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      _submitErrorMessage = null;
    });

    final slotSummary = _slots
        .map(
          (slot) =>
              '${slot.startValue} - ${slot.endValue} (${slot.capacityValue})',
        )
        .join(', ');
    final availabilityText = _availabilityController.text.trim().isEmpty
        ? slotSummary
        : _availabilityController.text;

    Map<String, dynamic>? result;
    try {
      final rules = [
        _ruleOneController.text,
        _ruleTwoController.text,
      ].map((rule) => rule.trim()).where((rule) => rule.isNotEmpty).toList();
      final timeSlots = _slots.map((slot) => slot.toJson()).toList();

      if (_isEditing) {
        final amenityId = widget.initialAmenity?['id']?.toString();
        if (amenityId == null) {
          throw Exception('Amenity was not found.');
        }
        result = await _repository.updateAdminAmenity(
          amenityId: amenityId,
          name: _nameController.text,
          category: _category,
          description: _descriptionController.text,
          locationLabel: _locationController.text,
          statusLabel: _status,
          availabilityText: availabilityText,
          occupancyNote: _occupancyController.text,
          capacityPercent: int.tryParse(_capacityController.text.trim()) ?? 0,
          bookingRequired: _bookingRequired,
          imageUrl: _imageUrlController.text,
          accessNote: _accessNoteController.text,
          rules: rules,
          timeSlots: timeSlots,
        );
      } else {
        result = await _repository.createAdminAmenity(
          name: _nameController.text,
          category: _category,
          description: _descriptionController.text,
          locationLabel: _locationController.text,
          statusLabel: _status,
          availabilityText: availabilityText,
          occupancyNote: _occupancyController.text,
          capacityPercent: int.tryParse(_capacityController.text.trim()) ?? 0,
          bookingRequired: _bookingRequired,
          imageUrl: _imageUrlController.text,
          accessNote: _accessNoteController.text,
          rules: rules,
          timeSlots: timeSlots,
        );
      }
    } catch (error) {
      _submitErrorMessage = _friendlyAmenityError(error);
      result = null;
    }

    if (!mounted) {
      return;
    }
    if (result == null) {
      setState(() {
        _isSubmitting = false;
      });
      showAvenueDialogMessage(
        context,
        message: _submitErrorMessage == null
            ? (_isEditing
                  ? 'Could not update amenity right now.'
                  : 'Could not add amenity right now.')
            : (_isEditing
                  ? 'Could not update amenity: $_submitErrorMessage'
                  : 'Could not add amenity: $_submitErrorMessage'),
        type: AvenueMessageType.error,
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditing
              ? '${result['name']} updated.'
              : '${result['name']} added.',
        ),
      ),
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return _AdminScaffold(
      currentPage: AppPage.adminAmenities,
      showBottomNavigation: false,
      topBar: _AdminTopBar(
        title: _isEditing ? 'Edit Amenity' : 'Add Amenity',
        leadingIcon: Icons.arrow_back_rounded,
        onLeadingTap: () => Navigator.of(context).pop(),
      ),
      child: _AdminBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _AdminTag(
              label: 'AMENITY MODULE',
              background: Color(0x1A005BBF),
              foreground: AvenueColors.primary,
            ),
            const SizedBox(height: 14),
            Text(
              _isEditing ? 'Edit Amenity' : 'Create Amenity',
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(fontSize: 32, height: 1.05),
            ),
            const SizedBox(height: 8),
            Text(
              _isEditing
                  ? 'Update amenity details, slots, and access rules for residents.'
                  : 'Set up a new amenity with operations, availability, and booking rules.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: _AdminPalette.muted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoadingAmenityData) ...[
              const LinearProgressIndicator(),
              const SizedBox(height: 18),
            ],
            _AdminGlassCard(
              radius: 32,
              backgroundColor: _AdminPalette.surfaceLow.withValues(alpha: 0.74),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Visual Representation',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    height: 164,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _AdminPalette.surfaceLow,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: _imageUrlController.text.trim().isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 58,
                                height: 58,
                                decoration: BoxDecoration(
                                  color: AvenueColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add_photo_alternate_outlined,
                                  color: AvenueColors.primary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Paste an image URL below',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: _AdminPalette.muted,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Image.network(
                              _imageUrlController.text.trim(),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                    child: Icon(Icons.broken_image_outlined),
                                  ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 12),
                  _AdminFormField(
                    label: 'IMAGE URL',
                    hintText: 'https://...',
                    icon: Icons.link_rounded,
                    controller: _imageUrlController,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _AdminGlassCard(
              radius: 28,
              backgroundColor: _AdminPalette.surfaceLow.withValues(alpha: 0.74),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _AdminSectionLabel(text: 'AMENITY DETAILS'),
                  const SizedBox(height: 12),
                  _AdminFormField(
                    label: 'AMENITY NAME',
                    hintText: 'Skydeck Infinity Pool',
                    icon: Icons.apartment_rounded,
                    controller: _nameController,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'CATEGORY',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _AdminPalette.muted,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Wellness', 'Entertainment', 'Popular', 'Other']
                        .map(
                          (category) => _AdminSelectChip(
                            label: category,
                            selected: _category == category,
                            onTap: () => setState(() => _category = category),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  _AdminFormField(
                    label: 'LOCATION',
                    hintText: 'Level 42, North Tower',
                    icon: Icons.location_on_outlined,
                    controller: _locationController,
                  ),
                  const SizedBox(height: 12),
                  _AdminComposerField(
                    label: 'DESCRIPTION',
                    hintText: 'Describe the rules and features...',
                    controller: _descriptionController,
                    minLines: 3,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 20),
                  const _AdminSectionLabel(text: 'OPERATIONS'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: ['OPEN', 'BUSY', 'RESERVED', 'MAINTENANCE']
                        .map(
                          (status) => _AdminSelectChip(
                            label: status,
                            selected: _status == status,
                            onTap: () => setState(() => _status = status),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  _AdminFormField(
                    label: 'AVAILABILITY TEXT',
                    hintText: 'Open daily 6 AM to 10 PM',
                    icon: Icons.schedule_rounded,
                    controller: _availabilityController,
                  ),
                  const SizedBox(height: 12),
                  _AdminFormField(
                    label: 'OCCUPANCY NOTE',
                    hintText: '42% Capacity',
                    icon: Icons.groups_rounded,
                    controller: _occupancyController,
                  ),
                  const SizedBox(height: 12),
                  _AdminFormField(
                    label: 'CAPACITY PERCENT',
                    hintText: '42',
                    icon: Icons.percent_rounded,
                    controller: _capacityController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  _AdminFormField(
                    label: 'ACCESS NOTE',
                    hintText: 'Digital ID required at entrance.',
                    icon: Icons.badge_outlined,
                    controller: _accessNoteController,
                  ),
                  const SizedBox(height: 20),
                  const _AdminSectionLabel(text: 'AVAILABLE TIME SLOTS'),
                  const SizedBox(height: 12),
                  ..._slots.indexed.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _AmenitySlotEditor(
                        slot: entry.$2,
                        onDelete: _slots.length == 1
                            ? null
                            : () => _removeSlot(entry.$1),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _addSlot,
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: _AdminPalette.outline.withValues(alpha: 0.28),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_rounded,
                            color: AvenueColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Add Slot',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AvenueColors.primary,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const _AdminSectionLabel(text: 'RULES'),
                  const SizedBox(height: 12),
                  _AdminFormField(
                    label: 'RULE 1',
                    hintText: 'Carry your resident ID.',
                    icon: Icons.rule_rounded,
                    controller: _ruleOneController,
                  ),
                  const SizedBox(height: 12),
                  _AdminFormField(
                    label: 'RULE 2',
                    hintText: 'No food inside the space.',
                    icon: Icons.rule_folder_outlined,
                    controller: _ruleTwoController,
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: _bookingRequired,
                    onChanged: (value) {
                      setState(() => _bookingRequired = value);
                    },
                    title: const Text('Booking required'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                            side: BorderSide(
                              color: AvenueColors.primary.withValues(
                                alpha: 0.25,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AvenueColors.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: AvenuePrimaryButton(
                          label: _isSubmitting
                              ? (_isEditing ? 'Saving...' : 'Publishing...')
                              : (_isEditing
                                    ? 'Save Changes'
                                    : 'Publish Amenity'),
                          onPressed: _submit,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      _isEditing
                          ? 'Changes will be reflected for residents immediately after saving.'
                          : 'Amenity will be immediately visible to residents upon publishing.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _AdminPalette.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const _AdminInfoBanner(
              icon: Icons.schedule_rounded,
              title: 'SLOT MANAGEMENT',
              body:
                  'Time slots and capacity are used in booking validation to avoid duplicate reservations.',
            ),
            const SizedBox(height: 12),
            const _AdminInfoBanner(
              icon: Icons.visibility_rounded,
              title: 'RESIDENT VIEW',
              body:
                  'Published amenities are immediately visible on the resident amenities list and detail views.',
            ),
          ],
        ),
      ),
    );
  }
}

String _formatAmenitySlotTime(dynamic rawValue) {
  final value = rawValue?.toString().trim() ?? '';
  if (value.length >= 5 && value.contains(':')) {
    return value.substring(0, 5);
  }

  return value;
}

String _friendlyAmenityError(Object error) {
  final message = error.toString();
  final sanitized = message
      .replaceFirst('PostgrestException(message: ', '')
      .replaceFirst('Exception: ', '')
      .replaceFirst(RegExp(r', code:.*$'), '')
      .trim();

  if (sanitized.length <= 160) {
    return sanitized;
  }

  return '${sanitized.substring(0, 157)}...';
}

class _AmenitySlotDraft {
  _AmenitySlotDraft({
    required this.start,
    required this.end,
    required this.capacity,
  }) : startController = TextEditingController(text: start),
       endController = TextEditingController(text: end),
       capacityController = TextEditingController(text: capacity);

  final String start;
  final String end;
  final String capacity;
  final TextEditingController startController;
  final TextEditingController endController;
  final TextEditingController capacityController;

  String get startValue => startController.text.trim();
  String get endValue => endController.text.trim();
  String get capacityValue => capacityController.text.trim();

  void dispose() {
    startController.dispose();
    endController.dispose();
    capacityController.dispose();
  }

  Map<String, dynamic> toJson() {
    return {
      'start_time': startValue,
      'end_time': endValue,
      'capacity': int.tryParse(capacityValue) ?? 1,
    };
  }
}

class _AmenitySlotEditor extends StatelessWidget {
  const _AmenitySlotEditor({required this.slot, this.onDelete});

  final _AmenitySlotDraft slot;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: _AdminPalette.shadow,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _AmenitySlotField(
              label: 'Start Time',
              controller: slot.startController,
              hintText: '08:00',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _AmenitySlotField(
              label: 'End Time',
              controller: slot.endController,
              hintText: '10:00',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _AmenitySlotField(
              label: 'Capacity',
              controller: slot.capacityController,
              hintText: '15',
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: onDelete,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _AdminPalette.danger.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                color: onDelete == null
                    ? _AdminPalette.muted
                    : _AdminPalette.danger,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmenitySlotField extends StatelessWidget {
  const _AmenitySlotField({
    required this.label,
    required this.controller,
    required this.hintText,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: _AdminPalette.muted,
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w900),
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            filled: true,
            fillColor: _AdminPalette.surfaceLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: _AdminPalette.outline.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: _AdminPalette.outline.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AvenueColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class AdminAmenityBookingsScreen extends StatefulWidget {
  const AdminAmenityBookingsScreen({super.key});

  @override
  State<AdminAmenityBookingsScreen> createState() =>
      _AdminAmenityBookingsScreenState();
}

class _AdminAmenityBookingsScreenState
    extends State<AdminAmenityBookingsScreen> {
  bool _showCompleted = false;

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();

    return _AdminScaffold(
      currentPage: AppPage.adminAmenities,
      topBar: _AdminTopBar(
        title: 'Booking Logs',
        leadingIcon: Icons.arrow_back_rounded,
        onLeadingTap: () => Navigator.of(context).pop(),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: repository.fetchAdminAmenityBookings(),
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          final visibleRows = rows.where((row) {
            final status = _normalize(row['booking_status']?.toString() ?? '');
            final completed =
                status.contains('complete') || status.contains('cancel');
            return _showCompleted ? completed : !completed;
          }).toList();

          return _AdminBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Booking Logs',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 32,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Review upcoming reservations and completed amenity usage.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _AdminPalette.muted,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _AdminSegmentButton(
                        label: 'Upcoming',
                        selected: !_showCompleted,
                        onTap: () => setState(() => _showCompleted = false),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _AdminSegmentButton(
                        label: 'Completed',
                        selected: _showCompleted,
                        onTap: () => setState(() => _showCompleted = true),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                if (snapshot.connectionState != ConnectionState.done &&
                    rows.isEmpty)
                  const _AdminEmptyState(label: 'Loading booking logs...')
                else if (visibleRows.isEmpty)
                  const _AdminEmptyState(label: 'No booking logs yet.')
                else
                  ...visibleRows.map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _AdminBookingLogCard(row: row),
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

class _AdminSegmentButton extends StatelessWidget {
  const _AdminSegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Colors.white : _AdminPalette.surfaceLow,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: _AdminPalette.shadow,
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: selected ? AvenueColors.primary : _AdminPalette.muted,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminBookingLogCard extends StatelessWidget {
  const _AdminBookingLogCard({required this.row});

  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) {
    final status = (row['booking_status'] ?? 'confirmed').toString();
    return _AdminGlassCard(
      radius: 28,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                row['image_url'] as String? ?? _adminPoolImageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    row['amenity_name'] as String? ?? 'Amenity',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${row['resident_name'] ?? 'Resident'} • Unit ${row['unit_number'] ?? '--'}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: _AdminPalette.muted),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _AdminMiniInfo(
                        icon: Icons.schedule_rounded,
                        label:
                            '${row['booking_date'] ?? '--'} • ${row['time_slot'] ?? '--'}',
                      ),
                      _AdminMiniInfo(
                        icon: Icons.groups_rounded,
                        label: '${row['guest_count'] ?? 0} Guests',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _AdminTag(
              label: status.toUpperCase(),
              background: const Color(0x1A005BBF),
              foreground: AvenueColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class AdminServicesScreen extends StatefulWidget {
  const AdminServicesScreen({super.key});

  @override
  State<AdminServicesScreen> createState() => _AdminServicesScreenState();
}

class _AdminServicesScreenState extends State<AdminServicesScreen> {
  final AvenueRepository _repository = AvenueRepository();
  late Future<List<Map<String, dynamic>>> _providersFuture;

  @override
  void initState() {
    super.initState();
    _providersFuture = _repository.fetchServiceProviders();
  }

  void _refresh() {
    setState(() {
      _providersFuture = _repository.fetchServiceProviders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _AdminScaffold(
      currentPage: AppPage.adminServices,
      topBar: _AdminTopBar(
        title: 'Services',
        leadingIcon: Icons.menu_rounded,
        onLeadingTap: () => _openAdminMenu(context, AppPage.adminServices),
        trailing: IconButton(
          onPressed: _refresh,
          icon: const Icon(Icons.refresh_rounded),
          color: AvenueColors.primary,
        ),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _providersFuture,
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          return _AdminBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Home Services',
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(fontSize: 32, height: 1.05),
                      ),
                    ),
                    IconButton.filled(
                      onPressed: () async {
                        final created = await Navigator.of(
                          context,
                        ).pushNamed(AppPage.addServiceProvider.routeName);
                        if (created == true) {
                          _refresh();
                        }
                      },
                      icon: const Icon(Icons.add_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage verified electricians, plumbers, cleaners, and specialist providers.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _AdminPalette.muted,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 18),
                if (snapshot.connectionState != ConnectionState.done &&
                    rows.isEmpty)
                  const _AdminEmptyState(label: 'Loading services...')
                else if (rows.isEmpty)
                  const _AdminEmptyState(label: 'No services found.')
                else
                  ...rows.map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _AdminServiceProviderCard(row: row),
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

class AddServiceProviderScreen extends StatefulWidget {
  const AddServiceProviderScreen({super.key});

  @override
  State<AddServiceProviderScreen> createState() =>
      _AddServiceProviderScreenState();
}

class _AddServiceProviderScreenState extends State<AddServiceProviderScreen> {
  final AvenueRepository _repository = AvenueRepository();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String _status = 'available';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _phoneController.dispose();
    _experienceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }
    if (_nameController.text.trim().isEmpty ||
        _specialtyController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty) {
      showAvenueDialogMessage(
        context,
        title: 'Missing details',
        message: 'Add name, specialty, and phone.',
        type: AvenueMessageType.error,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    Map<String, dynamic>? result;
    try {
      result = await _repository.createServiceProvider(
        fullName: _nameController.text,
        specialty: _specialtyController.text,
        phone: _phoneController.text,
        experienceLabel: _experienceController.text,
        availabilityStatus: _status,
        notes: _notesController.text,
      );
    } catch (_) {
      result = null;
    }

    if (!mounted) {
      return;
    }
    if (result == null) {
      setState(() => _isSubmitting = false);
      showAvenueDialogMessage(
        context,
        message: 'Could not add service right now.',
        type: AvenueMessageType.error,
      );
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${result['full_name']} added.')));
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return _AdminScaffold(
      currentPage: AppPage.adminServices,
      showBottomNavigation: false,
      topBar: _AdminTopBar(
        title: 'Add Service',
        leadingIcon: Icons.arrow_back_rounded,
        onLeadingTap: () => Navigator.of(context).pop(),
      ),
      child: _AdminBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _AdminTag(
              label: 'SERVICE DIRECTORY',
              background: Color(0x1A005BBF),
              foreground: AvenueColors.primary,
            ),
            const SizedBox(height: 14),
            Text(
              'Add Specialist',
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(fontSize: 32, height: 1.05),
            ),
            const SizedBox(height: 8),
            Text(
              'Register a verified service partner with contact and availability details.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: _AdminPalette.muted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            _AdminGlassCard(
              radius: 28,
              backgroundColor: _AdminPalette.surfaceLow.withValues(alpha: 0.74),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _AdminSectionLabel(text: 'SERVICE DETAILS'),
                  const SizedBox(height: 12),
                  _AdminFormField(
                    label: 'FULL NAME',
                    hintText: 'Marcus Thorne',
                    icon: Icons.person_rounded,
                    controller: _nameController,
                  ),
                  const SizedBox(height: 12),
                  _AdminFormField(
                    label: 'SPECIALTY',
                    hintText: 'Electrician',
                    icon: Icons.handyman_rounded,
                    controller: _specialtyController,
                  ),
                  const SizedBox(height: 12),
                  _AdminFormField(
                    label: 'PHONE',
                    hintText: '+1 (555) 000-0000',
                    icon: Icons.call_rounded,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  _AdminFormField(
                    label: 'EXPERIENCE',
                    hintText: 'Certified • 8 yrs exp.',
                    icon: Icons.verified_rounded,
                    controller: _experienceController,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: ['available', 'busy', 'offline']
                        .map(
                          (status) => _AdminSelectChip(
                            label: status.toUpperCase(),
                            selected: _status == status,
                            onTap: () => setState(() => _status = status),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  _AdminFormField(
                    label: 'NOTES',
                    hintText: 'Preferred for electrical complaints',
                    icon: Icons.notes_rounded,
                    controller: _notesController,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                            side: BorderSide(
                              color: AvenueColors.primary.withValues(
                                alpha: 0.25,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AvenueColors.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: AvenuePrimaryButton(
                          label: _isSubmitting ? 'Adding...' : 'Add Service',
                          onPressed: _submit,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const _AdminInfoBanner(
              icon: Icons.support_agent_rounded,
              title: 'SERVICE FLOW',
              body:
                  'Added specialists appear in the admin services directory for quick assignment and resident support.',
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminServiceProviderCard extends StatelessWidget {
  const _AdminServiceProviderCard({required this.row});

  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) {
    final status = row['availability_status']?.toString() ?? 'available';
    return _AdminGlassCard(
      radius: 28,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            AvenueNetworkAvatar(
              imageUrl: row['image_url'] as String? ?? _adminAvatarUrl,
              size: 68,
              fallbackLabel: (row['full_name'] as String? ?? 'S')
                  .substring(0, 1)
                  .toUpperCase(),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    row['full_name'] as String? ?? 'Service Provider',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${row['specialty'] ?? 'Specialist'} • ${row['experience_label'] ?? 'Verified provider'}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _AdminPalette.muted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    row['phone'] as String? ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AvenueColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            _AdminTag(
              label: status.toUpperCase(),
              background: status == 'available'
                  ? const Color(0x1A2E9A53)
                  : const Color(0x1AFFB018),
              foreground: status == 'available'
                  ? _AdminPalette.success
                  : _AdminPalette.warning,
            ),
          ],
        ),
      ),
    );
  }
}
