class LoanModel {
  final String loanId;
  final String memberId;
  final String groupId;
  final double amount;
  final double interestRate;
  final DateTime requestDate;
  final DateTime? approvalDate;
  final String status;
  final String? memberName;
  final String? groupName;
  final double? remainingBalance;
  final String? reason;

  const LoanModel({
    required this.loanId,
    required this.memberId,
    required this.groupId,
    required this.amount,
    required this.interestRate,
    required this.requestDate,
    this.approvalDate,
    required this.status,
    this.memberName,
    this.groupName,
    this.remainingBalance,
    this.reason,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      loanId: json['loan_id'] as String,
      memberId: json['member_id'] as String,
      groupId: json['group_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      interestRate: (json['interest_rate'] as num?)?.toDouble() ?? 0.0,
      requestDate: DateTime.parse(json['request_date'] as String),
      approvalDate: json['approval_date'] != null 
          ? DateTime.parse(json['approval_date'] as String) 
          : null,
      status: json['status'] as String? ?? 'pending',
      memberName: json['member_name'] as String?,
      groupName: json['group_name'] as String?,
      remainingBalance: json['remaining_balance'] != null 
          ? (json['remaining_balance'] as num).toDouble() 
          : null,
      reason: json['reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loan_id': loanId,
      'member_id': memberId,
      'group_id': groupId,
      'amount': amount,
      'interest_rate': interestRate,
      'request_date': requestDate.toIso8601String(),
      'approval_date': approvalDate?.toIso8601String(),
      'status': status,
      'reason': reason,
    };
  }

  double get totalWithInterest => amount + (amount * interestRate / 100);
  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
  bool get isPaid => status == 'paid';
}
