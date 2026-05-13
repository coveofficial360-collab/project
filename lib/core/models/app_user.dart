enum AppRole {
  resident('Resident', 'resident'),
  admin('Admin', 'admin'),
  guard('Guard', 'guard'),
  superUser('Super User', 'super_user');

  const AppRole(this.label, this.dbValue);

  final String label;
  final String dbValue;

  static AppRole fromDbValue(String value) {
    return AppRole.values.firstWhere(
      (role) => role.dbValue == value,
      orElse: () => AppRole.resident,
    );
  }
}

class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.role,
    required this.fullName,
    required this.status,
    this.unitNumber,
    this.tower,
    this.phone,
    this.avatarUrl,
    this.jobTitle,
    this.societyId,
    this.societyName,
    this.featureKeys = const [],
  });

  final String id;
  final String email;
  final AppRole role;
  final String fullName;
  final String status;
  final String? unitNumber;
  final String? tower;
  final String? phone;
  final String? avatarUrl;
  final String? jobTitle;
  final String? societyId;
  final String? societyName;
  final List<String> featureKeys;

  bool hasFeature(String featureKey) {
    if (role == AppRole.superUser) {
      return true;
    }

    if (featureKeys.isEmpty) {
      return true;
    }

    return featureKeys.contains(featureKey);
  }

  String get subtitle {
    if (role == AppRole.guard && tower != null) {
      return tower!;
    }

    if (role == AppRole.superUser && societyName != null) {
      return societyName!;
    }

    if (unitNumber != null && unitNumber!.isNotEmpty) {
      return tower != null && tower!.isNotEmpty
          ? 'Unit $unitNumber • $tower'
          : 'Unit $unitNumber';
    }

    return jobTitle ?? role.label;
  }

  String get initials {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return 'A';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  factory AppUser.fromAuthRow(Map<String, dynamic> row) {
    return AppUser(
      id: row['user_id'] as String,
      email: row['email'] as String,
      role: AppRole.fromDbValue(row['role'] as String),
      fullName: row['full_name'] as String,
      status: row['status'] as String,
      unitNumber: row['unit_number'] as String?,
      tower: row['tower'] as String?,
      societyId: row['society_id'] as String?,
      societyName: row['society_name'] as String?,
      featureKeys:
          (row['feature_keys'] as List<dynamic>?)
              ?.map((value) => value.toString())
              .toList() ??
          const [],
    );
  }

  factory AppUser.fromProfileRow(Map<String, dynamic> row, AppRole role) {
    return AppUser(
      id: row['id'] as String,
      email: row['email'] as String,
      role: role,
      fullName: row['full_name'] as String,
      status: row['status'] as String,
      unitNumber: row['unit_number'] as String?,
      tower: row['tower'] as String?,
      phone: row['phone'] as String?,
      avatarUrl: row['avatar_url'] as String?,
      jobTitle: row['job_title'] as String?,
      societyId: row['society_id'] as String?,
      societyName: row['society_name'] as String?,
    );
  }
}
