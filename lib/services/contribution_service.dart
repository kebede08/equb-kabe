import '../core/network/api_client.dart';
import '../models/contribution_model.dart';

class ContributionService {
  final ApiClient _api = ApiClient.instance;

  /// Record a contribution
  Future<ContributionModel> recordContribution({
    required String memberId,
    required String groupId,
    required double amount,
    required String paymentMethod,
    DateTime? dueDate,
  }) async {
    final response = await _api.post('/contributions', data: {
      'member_id': memberId,
      'group_id': groupId,
      'amount': amount,
      'payment_method': paymentMethod,
      if (dueDate != null) 'due_date': dueDate.toIso8601String(),
    });
    return ContributionModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Pay a contribution
  Future<ContributionModel> payContribution(
    String contributionId, {
    required String paymentMethod,
    String? referenceNumber,
  }) async {
    final response = await _api.post('/contributions/$contributionId/pay', data: {
      'payment_method': paymentMethod,
      if (referenceNumber != null) 'reference_number': referenceNumber,
    });
    return ContributionModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Get contributions for a group
  Future<List<ContributionModel>> getGroupContributions(
    String groupId, {
    String? status,
    int page = 1,
  }) async {
    final response = await _api.get(
      '/groups/$groupId/contributions',
      queryParams: {
        'page': page,
        if (status != null) 'status': status,
      },
    );
    final list = response.data['data'] as List;
    return list.map((e) => ContributionModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Get member contributions
  Future<List<ContributionModel>> getMemberContributions(String memberId) async {
    final response = await _api.get('/members/$memberId/contributions');
    final list = response.data['data'] as List;
    return list.map((e) => ContributionModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Get pending contributions
  Future<List<ContributionModel>> getPendingContributions() async {
    final response = await _api.get('/contributions/pending');
    final list = response.data['data'] as List;
    return list.map((e) => ContributionModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Get overdue contributions
  Future<List<ContributionModel>> getOverdueContributions() async {
    final response = await _api.get('/contributions/overdue');
    final list = response.data['data'] as List;
    return list.map((e) => ContributionModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Get contribution stats
  Future<Map<String, dynamic>> getContributionStats(String groupId) async {
    final response = await _api.get('/contributions/stats', queryParams: {
      'group_id': groupId,
    });
    return response.data as Map<String, dynamic>;
  }
}
