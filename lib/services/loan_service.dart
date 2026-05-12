import '../core/network/api_client.dart';
import '../models/loan_model.dart';

class LoanService {
  final ApiClient _api = ApiClient.instance;

  /// Request a loan
  Future<LoanModel> requestLoan({
    required String memberId,
    required String groupId,
    required double amount,
    String? reason,
  }) async {
    final response = await _api.post('/loans', data: {
      'member_id': memberId,
      'group_id': groupId,
      'amount': amount,
      if (reason != null) 'reason': reason,
    });
    return LoanModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Approve a loan (admin only)
  Future<LoanModel> approveLoan(String loanId) async {
    final response = await _api.post('/loans/$loanId/approve');
    return LoanModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Reject a loan (admin only)
  Future<LoanModel> rejectLoan(String loanId, {String? reason}) async {
    final response = await _api.post('/loans/$loanId/reject', data: {
      if (reason != null) 'reason': reason,
    });
    return LoanModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Repay a loan
  Future<Map<String, dynamic>> repayLoan(
    String loanId, {
    required double amount,
    required String paymentMethod,
  }) async {
    final response = await _api.post('/loans/$loanId/repay', data: {
      'amount': amount,
      'payment_method': paymentMethod,
    });
    return response.data as Map<String, dynamic>;
  }

  /// Get loan repayments
  Future<List<Map<String, dynamic>>> getLoanRepayments(String loanId) async {
    final response = await _api.get('/loans/$loanId/repayments');
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  /// Get group loans
  Future<List<LoanModel>> getGroupLoans(String groupId, {String? status}) async {
    final response = await _api.get('/groups/$groupId/loans', queryParams: {
      if (status != null) 'status': status,
    });
    final list = response.data['data'] as List;
    return list.map((e) => LoanModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Get member loans
  Future<List<LoanModel>> getMemberLoans(String memberId) async {
    final response = await _api.get('/members/$memberId/loans');
    final list = response.data['data'] as List;
    return list.map((e) => LoanModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Get pending loans
  Future<List<LoanModel>> getPendingLoans() async {
    final response = await _api.get('/loans/pending');
    final list = response.data['data'] as List;
    return list.map((e) => LoanModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Get active loans
  Future<List<LoanModel>> getActiveLoans() async {
    final response = await _api.get('/loans/active');
    final list = response.data['data'] as List;
    return list.map((e) => LoanModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Get loan stats
  Future<Map<String, dynamic>> getLoanStats() async {
    final response = await _api.get('/loans/stats');
    return response.data as Map<String, dynamic>;
  }
}
