class ContributionModel {
  final String contributionId;
  final String memberId;
  final String groupId;
  final double amount;
  final DateTime? dueDate;
  final DateTime? paidDate;
  final String status;
  final String? memberName;
  final String? groupName;

  const ContributionModel({
    required this.contributionId,
    required this.memberId,
    required this.groupId,
    required this.amount,
    this.dueDate,
    this.paidDate,
    required this.status,
    this.memberName,
    this.groupName,
  });

  factory ContributionModel.fromJson(Map<String, dynamic> json) {
    return ContributionModel(
      contributionId: json['contribution_id'] as String,
      memberId: json['member_id'] as String,
      groupId: json['group_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      dueDate: json['due_date'] != null 
          ? DateTime.parse(json['due_date'] as String) 
          : null,
      paidDate: json['paid_date'] != null 
          ? DateTime.parse(json['paid_date'] as String) 
          : null,
      status: json['status'] as String? ?? 'pending',
      memberName: json['member_name'] as String?,
      groupName: json['group_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contribution_id': contributionId,
      'member_id': memberId,
      'group_id': groupId,
      'amount': amount,
      'due_date': dueDate?.toIso8601String(),
      'paid_date': paidDate?.toIso8601String(),
      'status': status,
    };
  }

  bool get isPaid => status == 'paid';
  bool get isPending => status == 'pending';
  bool get isLate => status == 'late';

  bool get isOverdue {
    if (dueDate == null || isPaid) return false;
    return DateTime.now().isAfter(dueDate!);
  }
}
