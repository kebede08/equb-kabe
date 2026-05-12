import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../models/contribution_model.dart';
import '../../../models/loan_model.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'This Month';
  final List<String> _periods = ['This Month', 'Last 3 Months', 'This Year', 'All Time'];

  // Mock data
  final List<ContributionModel> _contributions = [
    ContributionModel(contributionId: 'c1', memberId: 'u1', groupId: '1', amount: 5000, paidDate: DateTime(2026, 5, 1), status: 'paid', groupName: 'Family Savings'),
    ContributionModel(contributionId: 'c2', memberId: 'u1', groupId: '2', amount: 2000, paidDate: DateTime(2026, 5, 5), status: 'paid', groupName: 'Office Equb'),
    ContributionModel(contributionId: 'c3', memberId: 'u1', groupId: '1', amount: 5000, paidDate: DateTime(2026, 4, 1), status: 'paid', groupName: 'Family Savings'),
    ContributionModel(contributionId: 'c4', memberId: 'u1', groupId: '2', amount: 2000, paidDate: DateTime(2026, 4, 5), status: 'paid', groupName: 'Office Equb'),
    ContributionModel(contributionId: 'c5', memberId: 'u1', groupId: '1', amount: 5000, paidDate: DateTime(2026, 3, 1), status: 'paid', groupName: 'Family Savings'),
    ContributionModel(contributionId: 'c6', memberId: 'u1', groupId: '2', amount: 2000, dueDate: DateTime(2026, 5, 20), status: 'pending', groupName: 'Office Equb'),
  ];

  final List<LoanModel> _loans = [
    LoanModel(loanId: 'l1', memberId: 'u1', groupId: '1', amount: 10000, interestRate: 5, requestDate: DateTime(2026, 4, 10), approvalDate: DateTime(2026, 4, 12), status: 'approved', groupName: 'Family Savings', remainingBalance: 10500),
    LoanModel(loanId: 'l2', memberId: 'u1', groupId: '1', amount: 8000, interestRate: 5, requestDate: DateTime(2026, 2, 1), approvalDate: DateTime(2026, 2, 3), status: 'paid', groupName: 'Family Savings', remainingBalance: 0),
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

  double get _totalSaved => _contributions.where((c) => c.isPaid).fold(0, (s, c) => s + c.amount);
  double get _totalPending => _contributions.where((c) => c.isPending).fold(0, (s, c) => s + c.amount);
  double get _totalLoaned => _loans.fold(0, (s, l) => s + l.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined),
            tooltip: 'Export PDF',
            onPressed: _exportPdf,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textGray,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Contributions'),
            Tab(text: 'Loans'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Period selector
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _periods.map((p) {
                  final selected = p == _selectedPeriod;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedPeriod = p),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: selected ? AppColors.primary : AppColors.border),
                      ),
                      child: Text(
                        p,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : AppColors.textGray,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildContributionsTab(),
                _buildLoansTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary cards
          Row(
            children: [
              Expanded(child: _SummaryCard(title: 'Total Saved', value: Formatters.formatBirr(_totalSaved), icon: Icons.savings_outlined, color: AppColors.secondary)),
              const SizedBox(width: 12),
              Expanded(child: _SummaryCard(title: 'Pending', value: Formatters.formatBirr(_totalPending), icon: Icons.pending_outlined, color: AppColors.warning)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _SummaryCard(title: 'Total Loaned', value: Formatters.formatBirr(_totalLoaned), icon: Icons.account_balance_outlined, color: AppColors.info)),
              const SizedBox(width: 12),
              Expanded(child: _SummaryCard(title: 'Groups', value: '2', icon: Icons.group_outlined, color: AppColors.primary)),
            ],
          ),

          const SizedBox(height: 24),

          // Monthly savings chart
          const Text('Monthly Savings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 12),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 10000,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        '${(value / 1000).toStringAsFixed(0)}k',
                        style: const TextStyle(fontSize: 10, color: AppColors.textGray),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                        final idx = value.toInt();
                        if (idx < 0 || idx >= months.length) return const SizedBox.shrink();
                        return Text(months[idx], style: const TextStyle(fontSize: 10, color: AppColors.textGray));
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(color: AppColors.border, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _barGroup(0, 7000),
                  _barGroup(1, 7000),
                  _barGroup(2, 7000),
                  _barGroup(3, 7000),
                  _barGroup(4, 7000),
                  _barGroup(5, 0),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Contribution breakdown pie chart
          const Text('Contribution Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 140,
                  width: 140,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: [
                        PieChartSectionData(value: 71.4, color: AppColors.secondary, title: '71%', radius: 30, titleStyle: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700)),
                        PieChartSectionData(value: 14.3, color: AppColors.warning, title: '14%', radius: 30, titleStyle: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700)),
                        PieChartSectionData(value: 14.3, color: AppColors.error, title: '14%', radius: 30, titleStyle: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LegendItem(color: AppColors.secondary, label: 'Paid', value: Formatters.formatBirr(_totalSaved)),
                      const SizedBox(height: 12),
                      _LegendItem(color: AppColors.warning, label: 'Pending', value: Formatters.formatBirr(_totalPending)),
                      const SizedBox(height: 12),
                      _LegendItem(color: AppColors.error, label: 'Late', value: 'ETB 0.00'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildContributionsTab() {
    final paid = _contributions.where((c) => c.isPaid).toList();
    final pending = _contributions.where((c) => c.isPending || c.isLate).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (paid.isNotEmpty) ...[
          _SectionHeader(title: 'Paid', count: paid.length),
          const SizedBox(height: 8),
          ...paid.map((c) => _ContributionRow(contribution: c)),
          const SizedBox(height: 20),
        ],
        if (pending.isNotEmpty) ...[
          _SectionHeader(title: 'Pending / Late', count: pending.length),
          const SizedBox(height: 8),
          ...pending.map((c) => _ContributionRow(contribution: c)),
        ],
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildLoansTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Loan summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _LoanStat(label: 'Total Loans', value: '${_loans.length}'),
              Container(width: 1, height: 40, color: Colors.white30),
              _LoanStat(label: 'Active', value: '${_loans.where((l) => l.isApproved).length}'),
              Container(width: 1, height: 40, color: Colors.white30),
              _LoanStat(label: 'Paid Off', value: '${_loans.where((l) => l.isPaid).length}'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ..._loans.map((l) => _LoanRow(loan: l)),
        const SizedBox(height: 80),
      ],
    );
  }

  BarChartGroupData _barGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.primary,
          width: 18,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }

  void _exportPdf() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Generating PDF report...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const _SummaryCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textGray)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  const _LegendItem({required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
              Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
          child: Text('$count', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
        ),
      ],
    );
  }
}

class _ContributionRow extends StatelessWidget {
  final ContributionModel contribution;
  const _ContributionRow({required this.contribution});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: contribution.isPaid ? AppColors.successLight : AppColors.warningLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.payments_outlined, color: contribution.isPaid ? AppColors.success : AppColors.warning, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contribution.groupName ?? 'Group', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textDark)),
                Text(
                  contribution.isPaid && contribution.paidDate != null
                      ? 'Paid ${Formatters.formatDate(contribution.paidDate!)}'
                      : contribution.dueDate != null
                          ? 'Due ${Formatters.formatDate(contribution.dueDate!)}'
                          : '',
                  style: const TextStyle(fontSize: 12, color: AppColors.textGray),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(Formatters.formatBirr(contribution.amount), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark)),
              const SizedBox(height: 4),
              StatusBadge(status: contribution.status, fontSize: 10),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoanRow extends StatelessWidget {
  final LoanModel loan;
  const _LoanRow({required this.loan});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.account_balance_outlined, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(loan.groupName ?? 'Group', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textDark)),
                    Text('Requested ${Formatters.formatDate(loan.requestDate)}', style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
                  ],
                ),
              ),
              StatusBadge(status: loan.status),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Detail(label: 'Amount', value: Formatters.formatBirr(loan.amount)),
              _Detail(label: 'Interest', value: Formatters.formatPercent(loan.interestRate)),
              _Detail(label: 'Total', value: Formatters.formatBirr(loan.totalWithInterest)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  final String label;
  final String value;
  const _Detail({required this.label, required this.value});

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

class _LoanStat extends StatelessWidget {
  final String label;
  final String value;
  const _LoanStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
