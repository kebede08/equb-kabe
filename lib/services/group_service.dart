import '../core/network/api_client.dart';
import '../models/group_model.dart';

class GroupService {
  final ApiClient _api = ApiClient.instance;

  /// Create a new Equb group
  Future<GroupModel> createGroup({
    required String groupName,
    required double contributionAmount,
    required int cycleDuration,
    int? maxMembers,
    String? description,
    DateTime? startDate,
  }) async {
    final response = await _api.post('/groups', data: {
      'group_name': groupName,
      'contribution_amount': contributionAmount,
      'cycle_duration': cycleDuration,
      if (maxMembers != null) 'max_members': maxMembers,
      if (description != null) 'description': description,
      if (startDate != null) 'start_date': startDate.toIso8601String(),
    });
    return GroupModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Get all groups (with pagination)
  Future<List<GroupModel>> getGroups({int page = 1, int limit = 20}) async {
    final response = await _api.get('/groups', queryParams: {
      'page': page,
      'limit': limit,
    });
    final list = response.data['data'] as List;
    return list.map((e) => GroupModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Get group by ID
  Future<GroupModel> getGroupById(String groupId) async {
    final response = await _api.get('/groups/$groupId');
    return GroupModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Update group
  Future<GroupModel> updateGroup(String groupId, Map<String, dynamic> data) async {
    final response = await _api.put('/groups/$groupId', data: data);
    return GroupModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Delete group
  Future<void> deleteGroup(String groupId) async {
    await _api.delete('/groups/$groupId');
  }

  /// Join group with code
  Future<void> joinGroup(String groupId, {String? inviteCode}) async {
    await _api.post('/groups/$groupId/join', data: {
      if (inviteCode != null) 'invite_code': inviteCode,
    });
  }

  /// Leave group
  Future<void> leaveGroup(String groupId) async {
    await _api.post('/groups/$groupId/leave');
  }

  /// Get group members
  Future<List<Map<String, dynamic>>> getGroupMembers(String groupId) async {
    final response = await _api.get('/groups/$groupId/members');
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  /// Invite member
  Future<void> inviteMember(String groupId, String phoneNumber) async {
    await _api.post('/groups/$groupId/invite', data: {
      'phone_number': phoneNumber,
    });
  }

  /// Remove member
  Future<void> removeMember(String groupId, String memberId) async {
    await _api.delete('/groups/$groupId/members/$memberId');
  }

  /// Get group dashboard stats
  Future<Map<String, dynamic>> getGroupDashboard(String groupId) async {
    final response = await _api.get('/groups/$groupId/dashboard');
    return response.data as Map<String, dynamic>;
  }

  /// Start group cycle
  Future<void> startGroup(String groupId) async {
    await _api.post('/groups/$groupId/start');
  }

  /// End group cycle
  Future<void> endGroup(String groupId) async {
    await _api.post('/groups/$groupId/end');
  }

  /// Get user's groups
  Future<List<GroupModel>> getMyGroups(String userId) async {
    final response = await _api.get('/users/$userId/groups');
    final list = response.data['data'] as List;
    return list.map((e) => GroupModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
