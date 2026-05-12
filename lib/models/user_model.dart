class UserModel {
  final String userId;
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String? profileImage;
  final String role;
  final String status;
  final DateTime createdAt;

  const UserModel({
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    this.email,
    this.profileImage,
    required this.role,
    required this.status,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String,
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String?,
      profileImage: json['profile_image'] as String?,
      role: json['role'] as String? ?? 'member',
      status: json['status'] as String? ?? 'active',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'email': email,
      'profile_image': profileImage,
      'role': role,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? userId,
    String? fullName,
    String? phoneNumber,
    String? email,
    String? profileImage,
    String? role,
    String? status,
    DateTime? createdAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isAdmin => role == 'admin' || role == 'system_admin';
}
