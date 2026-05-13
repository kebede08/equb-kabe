import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../models/loan_model.dart';
import '../../../routes/app_routes.dart';

class LoanDashboardScreen extends StatefulWidget {
  const LoanDashboardScreen({super.key});

  @override
  State<LoanDashboardScreen> createState() => _LoanDashboardScreenState();
}

class _LoanDashboardScreenState extends State<LoanDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<LoanModel> _loans = [
    LoanModel(
      loanId: 'l1', memberId: 'u1', groupId: '1',
      amount: 10000, interestRate: 5,
      requestDate: DateTime.now().subtract(const Duration(days: 10)),
      approvalDate: DateTime.now().subtract(const Duration(days: 8)),
      status: 'approved', memberName: 'Kebede Deleleg',
      groupName: 'Family Savings', remainingBalance: 10500,
    ),
    LoanModel(
      loanId: 'l2', memberId: 'u1', groupId: '2',
      amount: 5000, interestRate: 5,
      requestDate: DateTime.now().subtract(const Duration(days: 2)),
      status: 'pending', memberName: 'Kebede Deleleg',
      groupName: 'Office Equb',
    ),
    LoanModel(
      loanId: 'l3', memberId: 'u1', groupId: '1',
      amount: 8000, interestRate: 5,
      requestDate: DateTime.now().subtract(const Duration(days: 60)),
      approvalDate: DateTime.now().subtract(const Duration(days: 58)),
      status: 'paid', memberName: 'Kebede Deleleg',
      groupName: 'Family Savings', remainingBalance: 0,
    ),
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

  List<LoanModel> get _active => _loans.where((l) => l.isApproved).toList();
  List<LoanModel> get _pending => _loans.where((l) => l.isPending).toList();
  List<LoanModel> get _history => _loans.where((l) => l.isPaid || l.isRejected).toList();

  @override
  Widget build(BuildContext context) {
    final totalBorrowed = _active.fold(0.0, (s, l) => s + l.amount);
    final totalRemaining = _active.fold(0.0, (s, l) => s + (l.remainingBalance ?? 0));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Loans'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textGray,
          indicatorColor: AppColors.primary,
          tabs: [
            Tab(text: 'Active (${_active.length})'),
            Tab(text: 'Pending (${_pending.length})'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Summary
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _LoanStat(
                    label: 'Total Borrowed',
                    value: Formatters.formatBirr(totalBorrowed),
                    icon: Icons.account_balance_outlined,
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.white30),
                Expanded(
                  child: _LoanStat(
                    label: 'Remaining',
                    value: Formatters.formatBirr(totalRemaining),
                    icon: Icons.pending_actions_outlined,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLoanList(_active),
                _buildLoanList(_pending),
                _buildLoanList(_history),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(AppRoutes.requestLoan),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Request Loan', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildLoanList(List<LoanModel> loans) {
    if (loans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80, height: 80,
              decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
              child: const Icon(Icons.account_balance_outlined, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            const Text('No loans here', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 8),
            const Text('Your loans will appear here', style: TextStyle(color: AppColors.textGray)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      itemCount: loans.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _LoanCard(
        loan: loans[index],
        onTap: () => context.go('/loans/${loans[index].loanId}'),
      ),
    );
  }
}

class _LoanStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _LoanStat({required this.label, required this.value, required this.icon});

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

class _LoanCard extends StatelessWidget {
  final LoanModel loan;
  final VoidCallback onTap;
  const _LoanCard({required this.loan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
          boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.account_balance_outlined, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loan.groupName ?? 'Group',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textDark)),
                      Text('Requested ${Formatters.formatDate(loan.requestDate)}',
                          style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
                    ],
                  ),
                ),
                StatusBadge(status: loan.status),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _LoanDetail(label: 'Amount', value: Formatters.formatBirr(loan.amount)),
                _LoanDetail(label: 'Interest', value: Formatters.formatPercent(loan.interestRate)),
                _LoanDetail(label: 'Total', value: Formatters.formatBirr(loan.totalWithInterest)),
              ],
            ),
            if (loan.isApproved && loan.remainingBalance != null) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Remaining Balance',
                      style: TextStyle(fontSize: 12, color: AppColors.textGray)),
                  Text(Formatters.formatBirr(loan.remainingBalance!),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.error)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LoanDetail extends StatelessWidget {
  final String label;
  final String value;
  const _LoanDetail({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textGray)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark)),
      ],
    );
  }
}
