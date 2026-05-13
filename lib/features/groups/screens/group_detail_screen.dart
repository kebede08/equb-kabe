import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../models/group_model.dart';
import '../../../services/group_service.dart';

class GroupDetailScreen extends StatefulWidget {
  final String groupId;
  const GroupDetailScreen({super.key, required this.groupId});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _groupService = GroupService();

  // Mock data
  final GroupModel _group = GroupModel(
    groupId: '1',
    groupName: 'Family Savings',
    description: 'Monthly family savings group for big purchases',
    adminId: 'u1',
    contributionAmount: 5000,
    cycleDuration: 10,
    maxMembers: 10,
    status: 'active',
    createdAt: DateTime(2024, 1, 1),
    currentMembers: 8,
    totalPool: 40000,
    startDate: DateTime(2024, 2, 1),
  );

  final List<Map<String, dynamic>> _members = [
    {'name': 'Kebede Deleleg', 'phone': '+251947642560', 'status': 'paid', 'isAdmin': true, 'round': 1},
    {'name': 'Tigist Alemu', 'phone': '+251922345678', 'status': 'paid', 'isAdmin': false, 'round': 2},
    {'name': 'Dawit Haile', 'phone': '+251933456789', 'status': 'pending', 'isAdmin': false, 'round': 3},
    {'name': 'Meron Tadesse', 'phone': '+251944567890', 'status': 'late', 'isAdmin': false, 'round': 4},
    {'name': 'Yonas Bekele', 'phone': '+251955678901', 'status': 'paid', 'isAdmin': false, 'round': 5},
    {'name': 'Hana Girma', 'phone': '+251966789012', 'status': 'pending', 'isAdmin': false, 'round': 6},
    {'name': 'Samuel Tesfaye', 'phone': '+251977890123', 'status': 'paid', 'isAdmin': false, 'round': 7},
    {'name': 'Liya Worku', 'phone': '+251988901234', 'status': 'pending', 'isAdmin': false, 'round': 8},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showInviteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Invite Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Share this code with people you want to invite:',
                style: TextStyle(color: AppColors.textGray)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'EQB-FAM-2024',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(ctx),
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('Copy'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _group.maxMembers != null && _group.currentMembers != null
        ? _group.currentMembers! / _group.maxMembers!
        : 0.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_add_outlined, color: Colors.white),
                onPressed: _showInviteDialog,
                tooltip: 'Invite Member',
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.group, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _group.groupName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (_group.description != null)
                                Text(
                                  _group.description!,
                                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                        StatusBadge(status: _group.status),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              indicatorColor: Colors.white,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Members'),
                Tab(text: 'Activity'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverview(progress),
            _buildMembers(),
            _buildActivity(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverview(double progress) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats row
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Total Pool',
                  value: Formatters.formatBirr(_group.totalPool ?? 0),
                  icon: Icons.savings_outlined,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'Per Cycle',
                  value: Formatters.formatBirr(_group.contributionAmount),
                  icon: Icons.payments_outlined,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Duration',
                  value: Formatters.formatCycleDuration(_group.cycleDuration),
                  icon: Icons.calendar_month_outlined,
                  color: AppColors.info,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'Members',
                  value: '${_group.currentMembers ?? 0}/${_group.maxMembers ?? '?'}',
                  icon: Icons.people_outline,
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Member progress
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Member Capacity',
                        style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark)),
                    Text('${(progress * 100).toInt()}%',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_group.currentMembers} of ${_group.maxMembers} spots filled',
                  style: const TextStyle(fontSize: 12, color: AppColors.textGray),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Group details
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Group Details',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textDark)),
                const SizedBox(height: 16),
                _DetailRow(label: 'Start Date',
                    value: _group.startDate != null ? Formatters.formatDate(_group.startDate!) : 'Not set'),
                const Divider(height: 20),
                _DetailRow(label: 'Created',
                    value: Formatters.formatDate(_group.createdAt)),
                const Divider(height: 20),
                _DetailRow(label: 'Status', value: _group.status.toUpperCase()),
                const Divider(height: 20),
                _DetailRow(label: 'Admin', value: 'Kebede Deleleg'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Actions
          AppButton(
            label: 'Make Contribution',
            onPressed: () => context.go('/contributions/pay/${_group.groupId}'),
            icon: Icons.payments_outlined,
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Invite Member',
            variant: ButtonVariant.outline,
            onPressed: _showInviteDialog,
            icon: Icons.person_add_outlined,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMembers() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _members.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final member = _members[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  (member['name'] as String)[0],
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          member['name'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.textDark,
                          ),
                        ),
                        if (member['isAdmin'] == true) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('Admin',
                                style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      Formatters.formatPhone(member['phone'] as String),
                      style: const TextStyle(fontSize: 12, color: AppColors.textGray),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StatusBadge(status: member['status'] as String, fontSize: 10),
                  const SizedBox(height: 4),
                  Text(
                    'Round ${member['round']}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textGray),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActivity() {
    final activities = [
      {'icon': Icons.payments, 'color': AppColors.secondary, 'title': 'Kebede paid contribution', 'time': '2 hours ago', 'amount': '+ETB 5,000'},
      {'icon': Icons.payments, 'color': AppColors.secondary, 'title': 'Tigist paid contribution', 'time': '5 hours ago', 'amount': '+ETB 5,000'},
      {'icon': Icons.person_add, 'color': AppColors.info, 'title': 'Liya Worku joined the group', 'time': '1 day ago', 'amount': null},
      {'icon': Icons.warning_amber, 'color': AppColors.warning, 'title': 'Meron payment overdue', 'time': '2 days ago', 'amount': null},
      {'icon': Icons.payments, 'color': AppColors.secondary, 'title': 'Yonas paid contribution', 'time': '3 days ago', 'amount': '+ETB 5,000'},
      {'icon': Icons.group, 'color': AppColors.primary, 'title': 'Group was created', 'time': 'Jan 1, 2024', 'amount': null},
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: activities.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final a = activities[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (a['color'] as Color).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(a['icon'] as IconData, color: a['color'] as Color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a['title'] as String,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                    Text(a['time'] as String,
                        style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
                  ],
                ),
              ),
              if (a['amount'] != null)
                Text(
                  a['amount'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.secondary,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textGray)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textGray)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
      ],
    );
  }
}
