class GroupModel {
  final String groupId;
  final String groupName;
  final String? description;
  final String adminId;
  final double contributionAmount;
  final int cycleDuration;
  final int? maxMembers;
  final DateTime? startDate;
  final DateTime? endDate;
  final String status;
  final DateTime createdAt;
  final int? currentMembers;
  final double? totalPool;

  const GroupModel({
    required this.groupId,
    required this.groupName,
    this.description,
    required this.adminId,
    required this.contributionAmount,
    required this.cycleDuration,
    this.maxMembers,
    this.startDate,
    this.endDate,
    required this.status,
    required this.createdAt,
    this.currentMembers,
    this.totalPool,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      groupId: json['group_id'] as String,
      groupName: json['group_name'] as String,
      description: json['description'] as String?,
      adminId: json['admin_id'] as String,
      contributionAmount: (json['contribution_amount'] as num).toDouble(),
      cycleDuration: json['cycle_duration'] as int,
      maxMembers: json['max_members'] as int?,
      startDate: json['start_date'] != null 
          ? DateTime.parse(json['start_date'] as String) 
          : null,
      endDate: json['end_date'] != null 
          ? DateTime.parse(json['end_date'] as String) 
          : null,
      status: json['status'] as String? ?? 'active',
      createdAt: DateTime.parse(json['created_at'] as String),
      currentMembers: json['current_members'] as int?,
      totalPool: json['total_pool'] != null 
          ? (json['total_pool'] as num).toDouble() 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'group_name': groupName,
      'description': description,
      'admin_id': adminId,
      'contribution_amount': contributionAmount,
      'cycle_duration': cycleDuration,
      'max_members': maxMembers,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'current_members': currentMembers,
      'total_pool': totalPool,
    };
  }

  bool get isActive => status == 'active';
  bool get isCompleted => status == 'completed';
  bool get isFull => maxMembers != null && currentMembers != null && currentMembers! >= maxMembers!;
}
