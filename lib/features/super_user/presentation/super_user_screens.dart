import 'package:flutter/material.dart';

import '../../../app/app_page.dart';
import '../../../core/access/app_features.dart';
import '../../../core/models/app_user.dart';
import '../../../core/session/app_session.dart';
import '../../../core/supabase/avenue_repository.dart';
import '../../../theme/avenue_theme.dart';

class SuperUserDashboardScreen extends StatefulWidget {
  const SuperUserDashboardScreen({super.key});

  @override
  State<SuperUserDashboardScreen> createState() =>
      _SuperUserDashboardScreenState();
}

class _SuperUserDashboardScreenState extends State<SuperUserDashboardScreen> {
  final AvenueRepository _repository = AvenueRepository();
  Future<List<Map<String, dynamic>>>? _societiesFuture;
  Future<List<Map<String, dynamic>>>? _featuresFuture;
  String? _selectedSocietyId;
  Map<String, dynamic>? _selectedSociety;
  bool _isSaving = false;
  bool _isCreatingSociety = false;

  @override
  void initState() {
    super.initState();
    _refreshSocieties();
  }

  void _refreshSocieties({String? preserveSocietyId}) {
    final future = _repository.fetchSocieties();
    setState(() {
      _societiesFuture = future;
      if (preserveSocietyId != null) {
        _selectedSocietyId = preserveSocietyId;
      }
    });
    future.then((rows) {
      if (!mounted || rows.isEmpty) {
        return;
      }

      final nextSelected =
          _selectedSocietyId != null &&
              rows.any((row) => row['id']?.toString() == _selectedSocietyId)
          ? _selectedSocietyId
          : rows.first['id']?.toString();

      if (nextSelected != null) {
        _selectSocietyById(rows, nextSelected);
      }
    });
  }

  void _selectSocietyById(
    List<Map<String, dynamic>> societies,
    String societyId,
  ) {
    final selected = societies.firstWhere(
      (row) => row['id']?.toString() == societyId,
      orElse: () => societies.first,
    );
    setState(() {
      _selectedSocietyId = selected['id']?.toString();
      _selectedSociety = selected;
      _featuresFuture = _repository.fetchSocietyFeatureRows(
        _selectedSocietyId!,
      );
    });
  }

  Future<void> _toggleFeature(
    Map<String, dynamic> featureRow,
    bool isEnabled,
  ) async {
    final societyId = _selectedSocietyId;
    if (societyId == null || _isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _repository.updateSocietyFeature(
        societyId: societyId,
        featureKey: featureRow['feature_key'].toString(),
        isEnabled: isEnabled,
      );
      if (!mounted) {
        return;
      }
      _refreshSocieties(preserveSocietyId: societyId);
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not update feature access: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _createSociety() async {
    if (_isCreatingSociety) {
      return;
    }

    final nameController = TextEditingController();
    final codeController = TextEditingController();
    final addressController = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final pinController = TextEditingController();
    final notesController = TextEditingController();

    final shouldCreate = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.88,
          minChildSize: 0.65,
          maxChildSize: 0.96,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: ListView(
                controller: scrollController,
                children: [
                  Text(
                    'Create Society',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SocietyField(
                    controller: nameController,
                    label: 'Society Name',
                  ),
                  const SizedBox(height: 12),
                  _SocietyField(
                    controller: codeController,
                    label: 'Society Code',
                    hintText: 'cove-east',
                  ),
                  const SizedBox(height: 12),
                  _SocietyField(
                    controller: addressController,
                    label: 'Address',
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _SocietyField(
                          controller: cityController,
                          label: 'City',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SocietyField(
                          controller: stateController,
                          label: 'State',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _SocietyField(
                          controller: pinController,
                          label: 'PIN Code',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SocietyField(
                          controller: notesController,
                          label: 'Notes',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () {
                      if (nameController.text.trim().isEmpty) {
                        return;
                      }
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Create Society'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (shouldCreate != true) {
      return;
    }

    setState(() {
      _isCreatingSociety = true;
    });

    try {
      await _repository.createSociety(
        name: nameController.text.trim(),
        code: codeController.text.trim().isEmpty
            ? null
            : codeController.text.trim(),
        address: addressController.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        pinCode: pinController.text.trim(),
        notes: notesController.text.trim(),
      );
      if (!mounted) {
        return;
      }
      _refreshSocieties();
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingSociety = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = AppSession.instance.currentUser;

    return Scaffold(
      backgroundColor: AvenueColors.surface,
      appBar: AppBar(
        title: const Text('Super User Console'),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: _isCreatingSociety ? null : _createSociety,
            icon: const Icon(Icons.add_business_rounded),
            label: const Text('Add Society'),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushReplacementNamed(AppPage.login.routeName);
            },
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _societiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final societies = snapshot.data ?? const [];
          if (societies.isNotEmpty && _selectedSocietyId == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && _selectedSocietyId == null) {
                _selectSocietyById(societies, societies.first['id'].toString());
              }
            });
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 980;
              final selected = _selectedSociety;

              return Padding(
                padding: const EdgeInsets.all(20),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 340,
                            child: _SocietyListPanel(
                              societies: societies,
                              selectedSocietyId: _selectedSocietyId,
                              onSelected: (society) {
                                _selectSocietyById(
                                  societies,
                                  society['id'].toString(),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _SocietyDetailPanel(
                              society: selected,
                              featuresFuture: _featuresFuture,
                              isSaving: _isSaving,
                              onToggleFeature: _toggleFeature,
                              currentUser: currentUser,
                            ),
                          ),
                        ],
                      )
                    : ListView(
                        children: [
                          _SocietyListPanel(
                            societies: societies,
                            selectedSocietyId: _selectedSocietyId,
                            onSelected: (society) {
                              _selectSocietyById(
                                societies,
                                society['id'].toString(),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          _SocietyDetailPanel(
                            society: selected,
                            featuresFuture: _featuresFuture,
                            isSaving: _isSaving,
                            onToggleFeature: _toggleFeature,
                            currentUser: currentUser,
                          ),
                        ],
                      ),
              );
            },
          );
        },
      ),
    );
  }
}

class _SocietyListPanel extends StatelessWidget {
  const _SocietyListPanel({
    required this.societies,
    required this.selectedSocietyId,
    required this.onSelected,
  });

  final List<Map<String, dynamic>> societies;
  final String? selectedSocietyId;
  final ValueChanged<Map<String, dynamic>> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 30,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Societies',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          ...societies.map((society) {
            final isSelected = society['id'].toString() == selectedSocietyId;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () => onSelected(society),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AvenueColors.primary.withValues(alpha: 0.08)
                        : AvenueColors.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isSelected
                          ? AvenueColors.primary.withValues(alpha: 0.3)
                          : Colors.transparent,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              society['name']?.toString() ?? 'Society',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _StatusChip(
                            label: society['status']?.toString() ?? 'active',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        society['code']?.toString() ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AvenueColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${society['resident_count'] ?? 0} residents · ${society['enabled_feature_count'] ?? 0}/${society['total_feature_count'] ?? 0} features',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AvenueColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SocietyDetailPanel extends StatelessWidget {
  const _SocietyDetailPanel({
    required this.society,
    required this.featuresFuture,
    required this.isSaving,
    required this.onToggleFeature,
    required this.currentUser,
  });

  final Map<String, dynamic>? society;
  final Future<List<Map<String, dynamic>>>? featuresFuture;
  final bool isSaving;
  final Future<void> Function(Map<String, dynamic> featureRow, bool isEnabled)
  onToggleFeature;
  final AppUser? currentUser;

  @override
  Widget build(BuildContext context) {
    if (society == null) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Text(
          'Pick a society to manage its feature access.',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AvenueColors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    final enabledCount = society?['enabled_feature_count'] ?? 0;
    final totalCount = society?['total_feature_count'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 30,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      society!['name']?.toString() ?? 'Society',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${society!['address'] ?? 'No address'} · ${society!['city'] ?? ''}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AvenueColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusChip(label: '$enabledCount/$totalCount enabled'),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  label: 'Residents',
                  value: '${society!['resident_count'] ?? 0}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricCard(
                  label: 'Admins',
                  value: '${society!['admin_count'] ?? 0}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricCard(
                  label: 'Guards',
                  value: '${society!['guard_count'] ?? 0}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: featuresFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !snapshot.hasData) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final rows = snapshot.data ?? const [];
              if (rows.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'No features are configured yet.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              }

              String? currentGroup;
              final widgets = <Widget>[];
              for (final row in rows) {
                final group = row['feature_group']?.toString() ?? 'Features';
                if (group != currentGroup) {
                  currentGroup = group;
                  widgets.add(
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12, top: 4),
                      child: Text(
                        group,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AvenueColors.primary,
                            ),
                      ),
                    ),
                  );
                }
                widgets.add(
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _FeatureSwitchTile(
                      row: row,
                      isSaving: isSaving,
                      onChanged:
                          row['feature_key']?.toString() ==
                              AppFeatureKeys.superUserConsole
                          ? null
                          : (value) => onToggleFeature(row, value),
                    ),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widgets,
              );
            },
          ),
          const SizedBox(height: 12),
          Text(
            'Signed in as ${currentUser?.fullName ?? 'super user'}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AvenueColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureSwitchTile extends StatelessWidget {
  const _FeatureSwitchTile({
    required this.row,
    required this.onChanged,
    required this.isSaving,
  });

  final Map<String, dynamic> row;
  final ValueChanged<bool>? onChanged;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    final isEnabled = row['is_enabled'] as bool? ?? false;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AvenueColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AvenueColors.outline.withValues(alpha: 0.35)),
      ),
      child: SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        value: isEnabled,
        onChanged: isSaving ? null : onChanged,
        title: Text(
          row['label']?.toString() ?? 'Feature',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            row['description']?.toString() ?? '',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AvenueColors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AvenueColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AvenueColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AvenueColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AvenueColors.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _SocietyField extends StatelessWidget {
  const _SocietyField({
    required this.controller,
    required this.label,
    this.hintText,
  });

  final TextEditingController controller;
  final String label;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label, hintText: hintText),
    );
  }
}
