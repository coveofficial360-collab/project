part of 'admin_screens.dart';

class AddResidentScreen extends StatefulWidget {
  const AddResidentScreen({super.key});

  @override
  State<AddResidentScreen> createState() => _AddResidentScreenState();
}

class _AddResidentScreenState extends State<AddResidentScreen> {
  static const String _temporaryPassword = 'welcome123';

  final AvenueRepository _repository = AvenueRepository();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _moveInDateController = TextEditingController();

  String _residentKind = 'owner';
  DateTime? _moveInDate;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _unitController.dispose();
    _moveInDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AdminScaffold(
      currentPage: AppPage.residentDirectory,
      showBottomNavigation: false,
      topBar: _AdminTopBar(
        title: 'Add Resident',
        leadingIcon: Icons.arrow_back_rounded,
        onLeadingTap: () => _goBackOrAdminHome(context),
      ),
      child: _AdminBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _AdminTag(
              label: 'ONBOARDING MODULE',
              background: Color(0x1A005BBF),
              foreground: AvenueColors.primary,
            ),
            const SizedBox(height: 14),
            Text(
              'Resident Registration',
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(fontSize: 32, height: 1.05),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter the official details to welcome a new member to the community.',
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
                  const _AdminSectionLabel(text: 'CONTACT DETAILS'),
                  const SizedBox(height: 12),
                  _AdminFormField(
                    label: 'FULL NAME',
                    hintText: 'e.g. Jonathan Doe',
                    icon: Icons.person_rounded,
                    controller: _fullNameController,
                  ),
                  const SizedBox(height: 12),
                  _AdminFormField(
                    label: 'EMAIL ADDRESS',
                    hintText: 'j.doe@example.com',
                    icon: Icons.mail_outline_rounded,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  _AdminFormField(
                    label: 'PHONE NUMBER',
                    hintText: '+1 (555) 000-0000',
                    icon: Icons.call_rounded,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  const _AdminSectionLabel(text: 'LEASE & UNIT'),
                  const SizedBox(height: 12),
                  _AdminFormField(
                    label: 'UNIT NUMBER',
                    hintText: 'e.g. B-204',
                    icon: Icons.apartment_rounded,
                    controller: _unitController,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'RESIDENT TYPE',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _AdminPalette.muted,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _AdminSelectChip(
                        label: 'Owner',
                        selected: _residentKind == 'owner',
                        onTap: () => setState(() => _residentKind = 'owner'),
                      ),
                      _AdminSelectChip(
                        label: 'Tenant',
                        selected: _residentKind == 'tenant',
                        onTap: () => setState(() => _residentKind = 'tenant'),
                      ),
                      _AdminSelectChip(
                        label: 'Family',
                        selected: _residentKind == 'family',
                        onTap: () => setState(() => _residentKind = 'family'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _AdminFormField(
                    label: 'MOVE-IN DATE',
                    hintText: 'Select date',
                    icon: Icons.calendar_today_rounded,
                    controller: _moveInDateController,
                    readOnly: true,
                    onTap: _pickMoveInDate,
                  ),
                  const SizedBox(height: 20),
                  const _AdminSectionLabel(text: 'RESIDENT ID / PORTRAIT'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                          color: _AdminPalette.surfaceLow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.add_a_photo_outlined,
                          color: _AdminPalette.muted,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upload a profile picture',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Recommended for verification and quicker gate approval. Max file size 5MB.',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: _AdminPalette.muted,
                                    height: 1.45,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _goBackOrAdminHome(context),
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
                              ? 'Adding Resident...'
                              : 'Add Resident',
                          onPressed: _createResident,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const _AdminInfoBanner(
              icon: Icons.verified_user_rounded,
              title: 'SECURITY',
              body:
                  'The resident profile is created as an active access record ready for verification.',
            ),
            const SizedBox(height: 12),
            const _AdminInfoBanner(
              icon: Icons.mail_rounded,
              title: 'WELCOME',
              body:
                  'A temporary password is generated so the resident can sign in immediately.',
            ),
            const SizedBox(height: 12),
            const _AdminInfoBanner(
              icon: Icons.key_rounded,
              title: 'ACCESS',
              body:
                  'Once onboarded, the resident appears in the directory and admin oversight views.',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickMoveInDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _moveInDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _moveInDate = pickedDate;
      _moveInDateController.text =
          '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
    });
  }

  Future<void> _createResident() async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final unitNumber = _unitController.text.trim();

    if (fullName.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        unitNumber.isEmpty) {
      showAvenueDialogMessage(
        context,
        title: 'Missing details',
        message: 'Enter name, email, phone, and unit number.',
        type: AvenueMessageType.error,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    Map<String, dynamic>? result;
    try {
      result = await _repository.createResident(
        email: email,
        fullName: fullName,
        phone: phone,
        unitNumber: unitNumber,
        residentKind: _residentKind,
        tempPassword: _temporaryPassword,
      );
    } catch (_) {
      result = null;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
    });

    if (result == null) {
      showAvenueDialogMessage(
        context,
        message: 'Could not add resident.',
        type: AvenueMessageType.error,
      );
      return;
    }

    final createdEmail = result['email'] as String? ?? email;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Resident Added'),
          content: Text(
            'Temporary password for $createdEmail: $_temporaryPassword',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );

    if (!mounted) {
      return;
    }

    goToPage(context, AppPage.residentDirectory, replace: true);
  }
}
