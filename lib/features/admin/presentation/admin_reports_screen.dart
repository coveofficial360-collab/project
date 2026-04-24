part of 'admin_screens.dart';

class GenerateReportsScreen extends StatefulWidget {
  const GenerateReportsScreen({super.key});

  @override
  State<GenerateReportsScreen> createState() => _GenerateReportsScreenState();
}

class _GenerateReportsScreenState extends State<GenerateReportsScreen> {
  String _reportType = 'financial';
  String _dateRange = 'today';
  String _format = 'pdf';

  @override
  Widget build(BuildContext context) {
    return _AdminScaffold(
      currentPage: AppPage.generateReports,
      topBar: _AdminTopBar(
        title: 'Generate Reports',
        leadingIcon: Icons.arrow_back_rounded,
        onLeadingTap: () => _goBackOrAdminHome(context),
      ),
      child: _AdminBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _AdminTag(
              label: 'INTELLIGENCE SUITE',
              background: Color(0x1A005BBF),
              foreground: AvenueColors.primary,
            ),
            const SizedBox(height: 14),
            Text(
              'Configure Your Intelligence',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: 32,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select the parameters that shape a polished document for finance, occupancy, amenities, or maintenance.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: _AdminPalette.muted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const _AdminSectionLabel(text: '1. SELECT REPORT TYPE'),
            const SizedBox(height: 12),
            _ReportOptionCard(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Financial Summary',
              subtitle:
                  'Revenue, dues collection, and expense allocation for the selected period.',
              selected: _reportType == 'financial',
              onTap: () => setState(() => _reportType = 'financial'),
            ),
            const SizedBox(height: 10),
            _ReportOptionCard(
              icon: Icons.group_outlined,
              title: 'Resident Directory',
              subtitle:
                  'Occupancy, contact verification, and ownership distribution across the community.',
              selected: _reportType == 'residents',
              onTap: () => setState(() => _reportType = 'residents'),
            ),
            const SizedBox(height: 10),
            _ReportOptionCard(
              icon: Icons.pool_outlined,
              title: 'Amenity Usage',
              subtitle:
                  'Space bookings, demand peaks, and utilization patterns for premium facilities.',
              selected: _reportType == 'amenities',
              onTap: () => setState(() => _reportType = 'amenities'),
            ),
            const SizedBox(height: 10),
            _ReportOptionCard(
              icon: Icons.build_circle_outlined,
              title: 'Maintenance Logs',
              subtitle:
                  'Complaint lifecycle, pending issue count, and resolution timelines.',
              selected: _reportType == 'maintenance',
              onTap: () => setState(() => _reportType = 'maintenance'),
            ),
            const SizedBox(height: 24),
            const _AdminSectionLabel(text: '2. DATE RANGE'),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _ReportDateChip(
                    label: 'Today',
                    selected: _dateRange == 'today',
                    onTap: () => setState(() => _dateRange = 'today'),
                  ),
                  const SizedBox(width: 8),
                  _ReportDateChip(
                    label: 'This Month',
                    selected: _dateRange == 'month',
                    onTap: () => setState(() => _dateRange = 'month'),
                  ),
                  const SizedBox(width: 8),
                  _ReportDateChip(
                    label: 'Last Quarter',
                    selected: _dateRange == 'quarter',
                    onTap: () => setState(() => _dateRange = 'quarter'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const _AdminFormField(
              label: 'CUSTOM RANGE',
              hintText: '01 Oct 2023 - 31 Oct 2023',
              icon: Icons.calendar_today_rounded,
            ),
            const SizedBox(height: 24),
            const _AdminSectionLabel(text: '3. OUTPUT FORMAT'),
            const SizedBox(height: 12),
            _AdminGlassCard(
              child: Column(
                children: [
                  _ReportFormatRow(
                    icon: Icons.picture_as_pdf_rounded,
                    title: 'PDF Document',
                    iconColor: const Color(0xFFE04C3B),
                    selected: _format == 'pdf',
                    onTap: () => setState(() => _format = 'pdf'),
                  ),
                  const Divider(height: 1),
                  _ReportFormatRow(
                    icon: Icons.table_chart_rounded,
                    title: 'Excel Spreadsheet',
                    iconColor: const Color(0xFF1E8E5A),
                    selected: _format == 'xlsx',
                    onTap: () => setState(() => _format = 'xlsx'),
                  ),
                  const Divider(height: 1),
                  _ReportFormatRow(
                    icon: Icons.description_outlined,
                    title: 'CSV File',
                    iconColor: AvenueColors.primary,
                    selected: _format == 'csv',
                    onTap: () => setState(() => _format = 'csv'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const _AdminInfoBanner(
              icon: Icons.auto_awesome_rounded,
              title: 'REPORT INTELLIGENCE',
              body:
                  'Generating this document compiles live estate records into a presentation-ready export for management review.',
            ),
            const SizedBox(height: 24),
            AvenuePrimaryButton(
              label: 'Generate Report',
              icon: Icons.auto_awesome_rounded,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Report generation UI is ready. Export logic can be connected next.',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
