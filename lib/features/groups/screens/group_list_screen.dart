import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../models/group_model.dart';
import '../../../routes/app_routes.dart';

class GroupListScreen extends StatefulWidget {
  const GroupListScreen({super.key});

  @override
  State<GroupListScreen> createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data
  final List<GroupModel> _activeGroups = [
    GroupModel(
      groupId: '1',
      groupName: 'Family Savings',
      adminId: 'u1',
      contributionAmount: 5000,
      cycleDuration: 10,
      maxMembers: 10,
      status: 'active',
      createdAt: DateTime.now(),
      currentMembers: 8,
      description: 'Monthly family savings group',
    ),
    GroupModel(
      groupId: '2',
      groupName: 'Office Equb',
      adminId: 'u1',
      contributionAmount: 2000,
      cycleDuration: 12,
      maxMembers: 12,
      status: 'active',
      createdAt: DateTime.now(),
      currentMembers: 12,
      description: 'Office colleagues savings',
    ),
    GroupModel(
      groupId: '3',
      groupName: 'Friends Circle',
      adminId: 'u2',
      contributionAmount: 3000,
      cycleDuration: 8,
      maxMembers: 8,
      status: 'active',
      createdAt: DateTime.now(),
      currentMembers: 6,
      description: 'Close friends savings group',
    ),
  ];

  final List<GroupModel> _completedGroups = [
    GroupModel(
      groupId: '4',
      groupName: 'Neighbors Equb',
      adminId: 'u1',
      contributionAmount: 1000,
      cycleDuration: 6,
      maxMembers: 6,
      status: 'completed',
      createdAt: DateTime(2024, 1, 1),
      currentMembers: 6,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textGray,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGroupList(_activeGroups),
          _buildGroupList(_completedGroups),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(AppRoutes.createGroup),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Create Group', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildGroupList(List<GroupModel> groups) {
    if (groups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.group_outlined, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            const Text(
              'No groups yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create or join an Equb group\nto start saving together',
              style: TextStyle(color: AppColors.textGray, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => context.go(AppRoutes.createGroup),
                  icon: const Icon(Icons.add),
                  label: const Text('Create'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => context.go(AppRoutes.joinGroup),
                  icon: const Icon(Icons.group_add),
                  label: const Text('Join'),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: groups.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final group = groups[index];
        return _GroupCard(
          group: group,
          onTap: () => context.go('/groups/${group.groupId}'),
        );
      },
    );
  }
}

class _GroupCard extends StatelessWidget {
  final GroupModel group;
  final VoidCallback onTap;
  const _GroupCard({required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final progress = group.maxMembers != null && group.currentMembers != null
        ? group.currentMembers! / group.maxMembers!
        : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.group, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.groupName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: AppColors.textDark,
                        ),
                      ),
                      if (group.description != null)
                        Text(
                          group.description!,
                          style: const TextStyle(fontSize: 12, color: AppColors.textGray),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                StatusBadge(status: group.status),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _InfoChip(
                  icon: Icons.payments_outlined,
                  label: Formatters.formatBirr(group.contributionAmount),
                ),
                const SizedBox(width: 8),
                _InfoChip(
                  icon: Icons.calendar_today_outlined,
                  label: Formatters.formatCycleDuration(group.cycleDuration),
                ),
                const SizedBox(width: 8),
                _InfoChip(
                  icon: Icons.people_outline,
                  label: '${group.currentMembers ?? 0}/${group.maxMembers ?? '?'}',
                ),
              ],
            ),
            if (group.maxMembers != null) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Members',
                    style: const TextStyle(fontSize: 12, color: AppColors.textGray),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.border,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 6,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textGray),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textGray)),
        ],
      ),
    );
  }
}
