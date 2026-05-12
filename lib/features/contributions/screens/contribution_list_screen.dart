import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../models/contribution_model.dart';

class ContributionListScreen extends StatefulWidget {
  const ContributionListScreen({super.key});

  @override
  State<ContributionListScreen> createState() => _ContributionListScreenState();
}

class _ContributionListScreenState extends State<ContributionListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<ContributionModel> _all = [
    ContributionModel(contributionId: 'c1', memberId: 'u1', groupId: '1', amount: 5000,
        dueDate: DateTime.now().add(const Duration(days: 3)), status: 'pending', groupName: 'Family Savings'),
    ContributionModel(contributionId: 'c2', memberId: 'u1', groupId: '2', amount: 2000,
        dueDate: DateTime.now().subtract(const Duration(days: 2)), status: 'late', groupName: 'Office Equb'),
    ContributionModel(contributionId: 'c3', memberId: 'u1', groupId: '1', amount: 5000,
        dueDate: DateTime.now().subtract(const Duration(days: 30)),
        paidDate: DateTime.now().subtract(const Duration(days: 29)), status: 'paid', groupName: 'Family Savings'),
    ContributionModel(contributionId: 'c4', memberId: 'u1', groupId: '3', amount: 3000,
        dueDate: DateTime.now().subtract(const Duration(days: 60)),
        paidDate: DateTime.now().subtract(const Duration(days: 59)), status: 'paid', groupName: 'Friends Circle'),
    ContributionModel(contributionId: 'c5', memberId: 'u1', groupId: '2', amount: 2000,
        dueDate: DateTime.now().add(const Duration(days: 15)), status: 'pending', groupName: 'Office Equb'),
  ];

  List<ContributionModel> get _pending => _all.where((c) => c.isPending || c.isLate).toList();
  List<ContributionModel> get _paid => _all.where((c) => c.isPaid).toList();

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

  @override
  Widget build(BuildContext context) {
    final totalPending = _pending.fold(0.0, (sum, c) => sum + c.amount);
    final totalPaid = _paid.fold(0.0, (sum, c) => sum + c.amount);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Contributions'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textGray,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Paid'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Summary banner
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    label: 'Pending',
                    value: Formatters.formatBirr(totalPending),
                    icon: Icons.pending_outlined,
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.white30),
                Expanded(
                  child: _SummaryItem(
                    label: 'Paid',
                    value: Formatters.formatBirr(totalPaid),
                    icon: Icons.check_circle_outline,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(_all),
                _buildList(_pending),
                _buildList(_paid),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<ContributionModel> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
              child: const Icon(Icons.payments_outlined, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            const Text('No contributions here', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 8),
            const Text('Your contributions will appear here', style: TextStyle(color: AppColors.textGray)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final c = items[index];
        return _ContributionCard(
          contribution: c,
          onPay: c.isPending || c.isLate
              ? () => context.go('/contributions/pay/${c.contributionId}')
              : null,
        );
      },
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _SummaryItem({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

class _ContributionCard extends StatelessWidget {
  final ContributionModel contribution;
  final VoidCallback? onPay;
  const _ContributionCard({required this.contribution, this.onPay});

  @override
  Widget build(BuildContext context) {
    final isOverdue = contribution.isLate;
    final iconColor = contribution.isPaid
        ? AppColors.secondary
        : isOverdue
            ? AppColors.error
            : AppColors.warning;
    final bgColor = contribution.isPaid
        ? AppColors.successLight
        : isOverdue
            ? AppColors.errorLight
            : AppColors.warningLight;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.payments_outlined, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contribution.groupName ?? 'Group',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textDark),
                ),
                const SizedBox(height: 2),
                if (contribution.isPaid && contribution.paidDate != null)
                  Text('Paid ${Formatters.formatDate(contribution.paidDate!)}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textGray))
                else if (contribution.dueDate != null)
                  Text(
                    isOverdue
                        ? 'Overdue since ${Formatters.formatDate(contribution.dueDate!)}'
                        : 'Due ${Formatters.formatDate(contribution.dueDate!)}',
                    style: TextStyle(fontSize: 12, color: isOverdue ? AppColors.error : AppColors.textGray),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formatters.formatBirr(contribution.amount),
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark),
              ),
              const SizedBox(height: 4),
              if (onPay != null)
                GestureDetector(
                  onTap: onPay,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Pay Now', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                )
              else
                StatusBadge(status: contribution.status, fontSize: 10),
            ],
          ),
        ],
      ),
    );
  }
}
