class TransactionModel {
  final String transactionId;
  final String userId;
  final String groupId;
  final String type;
  final double amount;
  final String? paymentMethod;
  final String? referenceNumber;
  final String status;
  final DateTime createdAt;

  const TransactionModel({
    required this.transactionId,
    required this.userId,
    required this.groupId,
    required this.type,
    required this.amount,
    this.paymentMethod,
    this.referenceNumber,
    required this.status,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionId: json['transaction_id'] as String,
      userId: json['user_id'] as String,
      groupId: json['group_id'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['payment_method'] as String?,
      referenceNumber: json['reference_number'] as String?,
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'user_id': userId,
      'group_id': groupId,
      'type': type,
      'amount': amount,
      'payment_method': paymentMethod,
      'reference_number': referenceNumber,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool get isCredit => type == 'payout';
  bool get isDebit => type == 'contribution' || type == 'repayment';
}
