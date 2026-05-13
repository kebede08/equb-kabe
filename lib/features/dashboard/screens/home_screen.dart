import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../models/contribution_model.dart';
import '../../../models/group_model.dart';
import '../../../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data
    final groups = [
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
        totalPool: 40000,
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
        totalPool: 24000,
      ),
    ];

    final contributions = [
      ContributionModel(
        contributionId: 'c1',
        memberId: 'u1',
        groupId: '1',
        amount: 5000,
        dueDate: DateTime.now().add(const Duration(days: 3)),
        status: 'pending',
        groupName: 'Family Savings',
      ),
      ContributionModel(
        contributionId: 'c2',
        memberId: 'u1',
        groupId: '2',
        amount: 2000,
        dueDate: DateTime.now().subtract(const Duration(days: 2)),
        status: 'late',
        groupName: 'Office Equb',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Good morning 👋',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Kebede Deleleg',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.notifications_outlined,
                                  color: Colors.white, size: 28),
                              onPressed: () => context.go(AppRoutes.notifications),
                            ),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary cards
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          title: 'Total Saved',
                          value: Formatters.formatBirr(64000),
                          icon: Icons.savings_outlined,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(
                          title: 'Active Groups',
                          value: '${groups.length}',
                          icon: Icons.group_outlined,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          title: 'Pending',
                          value: Formatters.formatBirr(5000),
                          icon: Icons.pending_outlined,
                          color: AppColors.warning,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(
                          title: 'Active Loans',
                          value: '0',
                          icon: Icons.account_balance_outlined,
                          color: AppColors.info,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Quick actions
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _QuickAction(
                        icon: Icons.add_circle_outline,
                        label: 'Create\nGroup',
                        onTap: () => context.go(AppRoutes.createGroup),
                      ),
                      _QuickAction(
                        icon: Icons.group_add_outlined,
                        label: 'Join\nGroup',
                        onTap: () => context.go(AppRoutes.joinGroup),
                      ),
                      _QuickAction(
                        icon: Icons.payments_outlined,
                        label: 'Contribute',
                        onTap: () => context.go(AppRoutes.contributions),
                      ),
                      _QuickAction(
                        icon: Icons.bar_chart_outlined,
                        label: 'Reports',
                        onTap: () => context.go(AppRoutes.reports),
                      ),
                      _QuickAction(
                        icon: Icons.monetization_on_outlined,
                        label: 'Revenue',
                        onTap: () => context.go(AppRoutes.revenue),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Upcoming contributions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Upcoming Contributions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.contributions),
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...contributions.map((c) => _ContributionTile(contribution: c)),

                  const SizedBox(height: 24),

                  // My groups
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My Groups',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.groups),
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...groups.map(
                    (g) => _GroupTile(
                      group: g,
                      onTap: () => context.go('/groups/${g.groupId}'),
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 11, color: AppColors.textGray),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColors.primary, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textGray,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ContributionTile extends StatelessWidget {
  final ContributionModel contribution;

  const _ContributionTile({required this.contribution});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: contribution.isLate
                  ? AppColors.errorLight
                  : AppColors.warningLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.payments_outlined,
              color: contribution.isLate ? AppColors.error : AppColors.warning,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contribution.groupName ?? 'Group',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textDark,
                  ),
                ),
                if (contribution.dueDate != null)
                  Text(
                    'Due ${Formatters.formatDate(contribution.dueDate!)}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textGray),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formatters.formatBirr(contribution.amount),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              StatusBadge(status: contribution.status, fontSize: 10),
            ],
          ),
        ],
      ),
    );
  }
}

class _GroupTile extends StatelessWidget {
  final GroupModel group;
  final VoidCallback onTap;

  const _GroupTile({required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.group, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.groupName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    '${group.currentMembers ?? 0}/${group.maxMembers ?? '?'} members · ${Formatters.formatBirr(group.contributionAmount)}/cycle',
                    style: const TextStyle(fontSize: 12, color: AppColors.textGray),
                  ),
                ],
              ),
            ),
            if (group.totalPool != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Formatters.formatBirr(group.totalPool!),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppColors.secondary,
                    ),
                  ),
                  const Text(
                    'pool',
                    style: TextStyle(fontSize: 11, color: AppColors.textGray),
                  ),
                ],
              ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppColors.textGray, size: 20),
          ],
        ),
      ),
    );
  }
}
