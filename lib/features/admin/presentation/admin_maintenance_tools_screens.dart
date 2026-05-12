part of 'admin_screens.dart';

class AdminMaintenanceForcedAlertScreen extends StatefulWidget {
  const AdminMaintenanceForcedAlertScreen({
    super.key,
    this.preselectedResidentIds = const [],
  });

  final List<String> preselectedResidentIds;

  @override
  State<AdminMaintenanceForcedAlertScreen> createState() =>
      _AdminMaintenanceForcedAlertScreenState();
}

class AdminMaintenanceNotificationSettingsScreen extends StatefulWidget {
  const AdminMaintenanceNotificationSettingsScreen({super.key});

  @override
  State<AdminMaintenanceNotificationSettingsScreen> createState() =>
      _AdminMaintenanceNotificationSettingsScreenState();
}

class AdminMaintenanceExportOptionsScreen extends StatelessWidget {
  const AdminMaintenanceExportOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AvenueRepository();
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Export Options',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: const [SizedBox(width: 12)],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: repository.fetchAdminMaintenanceResidentLog(),
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          final csvRows = [
            'Resident,Unit,Bill Code,Amount,Due Date,Status',
            ...rows.map(
              (row) =>
                  '"${row['resident_name'] ?? ''}","${row['unit_number'] ?? ''}","${row['code'] ?? ''}","${_maintenanceDisplayAmount(row)}","${_date(row['due_date'])}","${_status(row)}"',
            ),
          ];
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
            child: AvenueCard(
              radius: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Export as CSV/PDF',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(label: 'Rows', value: '${rows.length}'),
                  const SizedBox(height: 14),
                  AvenuePrimaryButton(
                    label: 'Export CSV',
                    icon: Icons.table_chart_rounded,
                    onPressed: () => showAvenueDialogMessage(
                      context,
                      type: AvenueMessageType.success,
                      message:
                          'CSV prepared with ${rows.length} resident records.\n\nPreview:\n${csvRows.take(4).join('\n')}',
                    ),
                  ),
                  const SizedBox(height: 10),
                  AvenueSecondaryButton(
                    label: 'Export PDF',
                    icon: Icons.picture_as_pdf_rounded,
                    onPressed: () => showAvenueDialogMessage(
                      context,
                      type: AvenueMessageType.info,
                      message:
                          'PDF export template is ready. Connect your file service for download.',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AdminMaintenanceSecurePaymentScreen extends StatelessWidget {
  const AdminMaintenanceSecurePaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AvenueScaffold(
      topBar: AvenueTopBar(
        title: 'Secure Payment',
        leading: AvenueIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: const [SizedBox(width: 12)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AvenueCard(
              radius: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pay with UPI',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: const [
                      _BrandTile(label: 'GPay'),
                      _BrandTile(label: 'PhonePe'),
                      _BrandTile(label: 'Paytm'),
                      _BrandTile(label: 'BHIM'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AvenuePrimaryButton(
                    label: 'Proceed Securely',
                    icon: Icons.lock_rounded,
                    onPressed: () => showAvenueDialogMessage(
                      context,
                      type: AvenueMessageType.info,
                      message:
                          'Secure payment gateway can be linked to your PSP credentials.',
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
