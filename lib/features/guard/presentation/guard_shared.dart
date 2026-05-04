part of 'guard_screen.dart';

const _guardPortraitUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBfjHegZ49Lc5rAhhkRVVMhIo7oT_ADl-ZhDaMc-Feg4LygY7GHjgxcX4JRGBYLX43qEUdhUQfLZUCXkhgZLBswuq1fvoXkJQbyx5RioR7Y9UVi0mB4UFAe7pUDdyWh8J49U-ItlpzZ5VFXyN5OHmHf9TGUDJsBNTIEk1JsuUokK5QGA6oXYilrGS0V0lQEfzdZKTYh5LlM7KrWVSt59zASNk6oOSYSAGsjVexDFm-_T8FfX8SRd9BITDwrbBidPqmOzi87lHVGy8o';
const _guardGateFeedUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCVWrFLWKnS0ul9ygTprUPOjHtuThxm-Tej-YUDEX6P9fh4hCaLaAy_tAiZW1G1ktPTpdRkOpoYWLWAG0oJ4hMNaPbL7IzvcCEG78Q_2cMnzRAKHLGcQjWRp5VhTWrNxLg4mKYwKyZcN6Ah-3c6v0x0dAVw6EAtRKe5qbsZZh_rFcAq2hFb34_4e87lDu2gWFmzFT5gjq9aMhMvu1NsPS0fijeUuo4BuCQMsEorIOWqMg10fynRq3-qVIQSwpiBFLfuUhQ-S2abm2I';

class _GuardPalette {
  static const background = Color(0xFFF4FAFF);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMid = Color(0xFFE2E9EE);
  static const ink = Color(0xFF151D20);
  static const muted = Color(0xFF5C6772);
  static const outline = Color(0xFFC1C7D2);
  static const shadow = Color(0x14005EA3);
  static const secondary = Color(0xFF006686);
  static const error = Color(0xFFBA1A1A);
  static const success = Color(0xFF1F8E5A);
  static const warning = Color(0xFF946200);
}

class _GuardDashboardData {
  const _GuardDashboardData({
    required this.upcomingVisitors,
    required this.logs,
    required this.visitorLogs,
  });

  final List<Map<String, dynamic>> upcomingVisitors;
  final List<Map<String, dynamic>> logs;
  final List<Map<String, dynamic>> visitorLogs;

  static Future<_GuardDashboardData> load(AvenueRepository repository) async {
    final results = await Future.wait([
      repository.fetchGuardGateActivities(),
      repository.fetchGuardDutyLogs(),
      repository.fetchGuardVisitorLogs(),
    ]);

    return _GuardDashboardData(
      upcomingVisitors: results[0],
      logs: results[1],
      visitorLogs: results[2],
    );
  }
}

class _GuardGlassCard extends StatelessWidget {
  const _GuardGlassCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _GuardPalette.surface.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _GuardPalette.outline.withValues(alpha: 0.16),
        ),
        boxShadow: const [
          BoxShadow(
            color: _GuardPalette.shadow,
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _GuardTextField extends StatelessWidget {
  const _GuardTextField({
    required this.label,
    required this.hintText,
    required this.controller,
    this.keyboardType,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: _GuardPalette.muted,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _GuardPalette.outline.withValues(alpha: 0.7),
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _GuardPalette.muted.withValues(alpha: 0.72),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _GuardDropdownField extends StatelessWidget {
  const _GuardDropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: _GuardPalette.muted,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _GuardPalette.outline.withValues(alpha: 0.7),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              items: items
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _GuardPrimaryButton extends StatelessWidget {
  const _GuardPrimaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: AvenueColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _GuardSecondaryDangerButton extends StatelessWidget {
  const _GuardSecondaryDangerButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: _GuardPalette.error,
          minimumSize: const Size.fromHeight(54),
          side: BorderSide(
            color: _GuardPalette.error.withValues(alpha: 0.25),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _GuardSolidActionButton extends StatelessWidget {
  const _GuardSolidActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _GuardOutlinedActionButton extends StatelessWidget {
  const _GuardOutlinedActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: _GuardPalette.ink,
          minimumSize: const Size.fromHeight(50),
          side: BorderSide(color: _GuardPalette.outline.withValues(alpha: 0.7)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _GuardMessageCard extends StatelessWidget {
  const _GuardMessageCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final isLoading = title.trim().toLowerCase().startsWith('loading');
    if (isLoading) {
      return _GuardGlassCard(
        child: const Padding(
          padding: EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvenueSkeletonBlock(width: 170, height: 16, radius: 999),
              SizedBox(height: 12),
              AvenueSkeletonBlock(
                width: double.infinity,
                height: 12,
                radius: 999,
              ),
              SizedBox(height: 8),
              AvenueSkeletonBlock(width: 210, height: 12, radius: 999),
            ],
          ),
        ),
      );
    }

    return _GuardGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _GuardPalette.muted,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _normalize(dynamic value) =>
    value?.toString().trim().toLowerCase() ?? '';

String _titleCase(String value) {
  if (value.isEmpty) {
    return value;
  }

  return value
      .split(RegExp(r'[_\s]+'))
      .where((part) => part.isNotEmpty)
      .map(
        (part) =>
            '${part.substring(0, 1).toUpperCase()}${part.substring(1).toLowerCase()}',
      )
      .join(' ');
}

Color _guardStatusColor(String status) {
  switch (_normalize(status)) {
    case 'approved':
    case 'completed':
      return _GuardPalette.success;
    case 'expected':
    case 'watch':
      return _GuardPalette.warning;
    case 'denied':
      return _GuardPalette.error;
    default:
      return AvenueColors.primary;
  }
}

String _guardArrivalLabel(dynamic value) {
  if (value == null) {
    return 'Unknown';
  }

  final parsed = DateTime.tryParse(value.toString());
  if (parsed == null) {
    return value.toString();
  }

  final local = parsed.toLocal();
  final hour = local.hour == 0
      ? 12
      : local.hour > 12
      ? local.hour - 12
      : local.hour;
  final minute = local.minute.toString().padLeft(2, '0');
  final meridiem = local.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $meridiem';
}
