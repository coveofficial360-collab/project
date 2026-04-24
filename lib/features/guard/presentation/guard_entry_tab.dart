part of 'guard_screen.dart';

class _GuardEntryTab extends StatelessWidget {
  const _GuardEntryTab({
    required this.visitorNameController,
    required this.flatNumberController,
    required this.contactNumberController,
    required this.selectedPurpose,
    required this.onPurposeChanged,
    required this.onApprove,
    required this.onDeny,
    required this.onScanQr,
    required this.onOpenCamera,
    required this.onPanicAlert,
    required this.onCallManager,
  });

  final TextEditingController visitorNameController;
  final TextEditingController flatNumberController;
  final TextEditingController contactNumberController;
  final String selectedPurpose;
  final ValueChanged<String?> onPurposeChanged;
  final VoidCallback onApprove;
  final VoidCallback onDeny;
  final VoidCallback onScanQr;
  final VoidCallback onOpenCamera;
  final VoidCallback onPanicAlert;
  final VoidCallback onCallManager;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 560;
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _GuardPhotoCard(onOpenCamera: onOpenCamera),
                        const SizedBox(height: 16),
                        _GuardExpressPassCard(onScanQr: onScanQr),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: _GuardEntryFormCard(
                      visitorNameController: visitorNameController,
                      flatNumberController: flatNumberController,
                      contactNumberController: contactNumberController,
                      selectedPurpose: selectedPurpose,
                      onPurposeChanged: onPurposeChanged,
                      onApprove: onApprove,
                      onDeny: onDeny,
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                _GuardPhotoCard(onOpenCamera: onOpenCamera),
                const SizedBox(height: 16),
                _GuardExpressPassCard(onScanQr: onScanQr),
                const SizedBox(height: 16),
                _GuardEntryFormCard(
                  visitorNameController: visitorNameController,
                  flatNumberController: flatNumberController,
                  contactNumberController: contactNumberController,
                  selectedPurpose: selectedPurpose,
                  onPurposeChanged: onPurposeChanged,
                  onApprove: onApprove,
                  onDeny: onDeny,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 560;
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _GuardLiveFeedCard()),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _GuardEmergencyCard(
                      onPanicAlert: onPanicAlert,
                      onCallManager: onCallManager,
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                _GuardLiveFeedCard(),
                const SizedBox(height: 16),
                _GuardEmergencyCard(
                  onPanicAlert: onPanicAlert,
                  onCallManager: onCallManager,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _GuardPhotoCard extends StatelessWidget {
  const _GuardPhotoCard({required this.onOpenCamera});

  final VoidCallback onOpenCamera;

  @override
  Widget build(BuildContext context) {
    return _GuardGlassCard(
      child: Container(
        constraints: const BoxConstraints(minHeight: 290),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: _GuardPalette.surfaceMid,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Icon(
                Icons.add_a_photo_outlined,
                size: 42,
                color: _GuardPalette.muted,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Visitor Photo',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Capture image for digital logs',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: _GuardPalette.muted),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onOpenCamera,
                icon: const Icon(Icons.photo_camera_outlined),
                label: const Text('Open Camera'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  foregroundColor: AvenueColors.primary,
                  side: BorderSide(
                    color: _GuardPalette.outline.withValues(alpha: 0.6),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuardExpressPassCard extends StatelessWidget {
  const _GuardExpressPassCard({required this.onScanQr});

  final VoidCallback onScanQr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AvenueColors.primaryGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33005BBF),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EXPRESS PASS',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.75),
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onScanQr,
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: const Text('Scan QR Code'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(54),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.25)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Supports invited guests and delivery passes',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.72),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _GuardEntryFormCard extends StatelessWidget {
  const _GuardEntryFormCard({
    required this.visitorNameController,
    required this.flatNumberController,
    required this.contactNumberController,
    required this.selectedPurpose,
    required this.onPurposeChanged,
    required this.onApprove,
    required this.onDeny,
  });

  final TextEditingController visitorNameController;
  final TextEditingController flatNumberController;
  final TextEditingController contactNumberController;
  final String selectedPurpose;
  final ValueChanged<String?> onPurposeChanged;
  final VoidCallback onApprove;
  final VoidCallback onDeny;

  @override
  Widget build(BuildContext context) {
    return _GuardGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Visitor Entry',
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(
                              color: AvenueColors.primary,
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Fill in details for manual entry log',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _GuardPalette.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF3FF),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'MANUAL ENTRY',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AvenueColors.primary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 420;
                if (isWide) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _GuardTextField(
                              label: 'Visitor Name',
                              hintText: 'e.g. John Doe',
                              controller: visitorNameController,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _GuardTextField(
                              label: 'Flat Number',
                              hintText: 'e.g. B-402',
                              controller: flatNumberController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _GuardDropdownField(
                        label: 'Purpose of Visit',
                        value: selectedPurpose,
                        items: const [
                          'Delivery / Courier',
                          'Personal Guest',
                          'Maintenance / Service',
                          'Utility Bill / Collection',
                          'Other',
                        ],
                        onChanged: onPurposeChanged,
                      ),
                      const SizedBox(height: 14),
                      _GuardTextField(
                        label: 'Contact Number (Optional)',
                        hintText: '+91 00000 00000',
                        controller: contactNumberController,
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    _GuardTextField(
                      label: 'Visitor Name',
                      hintText: 'e.g. John Doe',
                      controller: visitorNameController,
                    ),
                    const SizedBox(height: 14),
                    _GuardTextField(
                      label: 'Flat Number',
                      hintText: 'e.g. B-402',
                      controller: flatNumberController,
                    ),
                    const SizedBox(height: 14),
                    _GuardDropdownField(
                      label: 'Purpose of Visit',
                      value: selectedPurpose,
                      items: const [
                        'Delivery / Courier',
                        'Personal Guest',
                        'Maintenance / Service',
                        'Utility Bill / Collection',
                        'Other',
                      ],
                      onChanged: onPurposeChanged,
                    ),
                    const SizedBox(height: 14),
                    _GuardTextField(
                      label: 'Contact Number (Optional)',
                      hintText: '+91 00000 00000',
                      controller: contactNumberController,
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 420;
                if (isWide) {
                  return Row(
                    children: [
                      Expanded(
                        child: _GuardPrimaryButton(
                          label: 'Approve Entry',
                          icon: Icons.check_circle_rounded,
                          onTap: onApprove,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _GuardSecondaryDangerButton(
                          label: 'Deny Entry',
                          icon: Icons.cancel_rounded,
                          onTap: onDeny,
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    _GuardPrimaryButton(
                      label: 'Approve Entry',
                      icon: Icons.check_circle_rounded,
                      onTap: onApprove,
                    ),
                    const SizedBox(height: 12),
                    _GuardSecondaryDangerButton(
                      label: 'Deny Entry',
                      icon: Icons.cancel_rounded,
                      onTap: onDeny,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _GuardLiveFeedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _GuardGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Live Gate Feed',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AvenueColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE1DD),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _GuardPalette.error,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'LIVE',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _GuardPalette.error,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      _guardGateFeedUrl,
                      fit: BoxFit.cover,
                      opacity: const AlwaysStoppedAnimation(0.84),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.38),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'CAM_01_NORTH_DRIVEWAY',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
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

class _GuardEmergencyCard extends StatelessWidget {
  const _GuardEmergencyCard({
    required this.onPanicAlert,
    required this.onCallManager,
  });

  final VoidCallback onPanicAlert;
  final VoidCallback onCallManager;

  @override
  Widget build(BuildContext context) {
    return _GuardGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Emergency',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AvenueColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Contact society management or emergency services immediately.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _GuardPalette.muted,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 18),
            _GuardSolidActionButton(
              label: 'Panic Alert',
              icon: Icons.emergency_rounded,
              color: _GuardPalette.error,
              onTap: onPanicAlert,
            ),
            const SizedBox(height: 10),
            _GuardOutlinedActionButton(
              label: 'Call Manager',
              icon: Icons.phone_in_talk_rounded,
              onTap: onCallManager,
            ),
          ],
        ),
      ),
    );
  }
}
