// Revenue Screen

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';

class RevenueScreen extends StatefulWidget {
  const RevenueScreen({super.key});

  @override
  State<RevenueScreen> createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Transaction fee settings
  double _transactionFeePercent = 1.5;
  bool _feeEnabled = true;

  // Subscription plans
  final List<_Plan> _plans = [
    _Plan(name: 'Free', price: 0, maxMembers: 10, maxGroups: 1, loanLimit: 5000, color: AppColors.textGray,
        features: ['Up to 10 members', '1 group', 'Basic reports', 'ETB 5,000 loan limit']),
    _Plan(name: 'Standard', price: 199, maxMembers: 30, maxGroups: 5, loanLimit: 50000, color: AppColors.primary,
        features: ['Up to 30 members', '5 groups', 'Advanced reports', 'ETB 50,000 loan limit', 'Priority support']),
    _Plan(name: 'Premium', price: 499, maxMembers: 100, maxGroups: 20, loanLimit: 200000, color: AppColors.warning,
        features: ['Up to 100 members', '20 groups', 'Full analytics + PDF', 'ETB 200,000 loan limit', '24/7 support', 'Custom branding']),
    _Plan(name: 'Enterprise', price: 1499, maxMembers: 999, maxGroups: 999, loanLimit: 1000000, color: AppColors.secondary,
        features: ['Unlimited members', 'Unlimited groups', 'API access', 'ETB 1M+ loan limit', 'Dedicated manager', 'White-label app']),
  ];

  String _activePlan = 'Standard';

  // Loan interest settings
  double _loanInterestRate = 5.0;
  int _loanTermMonths = 3;
  bool _interestEnabled = true;

  // Revenue stats (mock)
  final double _totalRevenue = 48750;
  final double _monthlyRevenue = 8200;
  final double _transactionFees = 3150;
  final double _subscriptionRevenue = 3500;
  final double _interestRevenue = 1550;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Text('Revenue Management'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textGray,
          indicatorColor: AppColors.primary,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Transaction Fees'),
            Tab(text: 'Subscriptions'),
            Tab(text: 'Loan Interest'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverview(),
          _buildTransactionFees(),
          _buildSubscriptions(),
          _buildLoanInterest(),
        ],
      ),
    );
  }

  // ── Overview Tab ────────────────────────────────────────────────────────────
  Widget _buildOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total revenue banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Revenue', style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 6),
                Text(Formatters.formatBirr(_totalRevenue),
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('This month: ${Formatters.formatBirr(_monthlyRevenue)}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text('Revenue Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 12),

          _RevenueCard(
            title: 'Transaction Fees',
            amount: _transactionFees,
            icon: Icons.percent_outlined,
            color: AppColors.primary,
            subtitle: '${Formatters.formatPercent(_transactionFeePercent)} per transaction',
            onTap: () => _tabController.animateTo(1),
          ),
          const SizedBox(height: 10),
          _RevenueCard(
            title: 'Subscriptions',
            amount: _subscriptionRevenue,
            icon: Icons.star_outline,
            color: AppColors.warning,
            subtitle: '$_activePlan plan active',
            onTap: () => _tabController.animateTo(2),
          ),
          const SizedBox(height: 10),
          _RevenueCard(
            title: 'Loan Interest',
            amount: _interestRevenue,
            icon: Icons.account_balance_outlined,
            color: AppColors.secondary,
            subtitle: '${Formatters.formatPercent(_loanInterestRate)} interest rate',
            onTap: () => _tabController.animateTo(3),
          ),
          const SizedBox(height: 24),

          const Text('Recent Transactions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 12),

          _TransactionRow(title: 'Fee: Family Savings contribution', amount: 75, date: 'Today', type: 'fee'),
          _TransactionRow(title: 'Standard Plan renewal', amount: 199, date: 'May 1', type: 'subscription'),
          _TransactionRow(title: 'Loan interest: Office Equb', amount: 500, date: 'Apr 28', type: 'interest'),
          _TransactionRow(title: 'Fee: Office Equb contribution', amount: 30, date: 'Apr 25', type: 'fee'),
          _TransactionRow(title: 'Fee: Family Savings contribution', amount: 75, date: 'Apr 20', type: 'fee'),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // ── Transaction Fees Tab ─────────────────────────────────────────────────────
  Widget _buildTransactionFees() {
    final exampleAmount = 5000.0;
    final feeAmount = exampleAmount * _transactionFeePercent / 100;
    final memberReceives = exampleAmount - feeAmount;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enable toggle
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.percent_outlined, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Transaction Fee', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textDark)),
                      Text('Charge a % on every contribution', style: TextStyle(fontSize: 12, color: AppColors.textGray)),
                    ],
                  ),
                ),
                Switch(value: _feeEnabled, onChanged: (v) => setState(() => _feeEnabled = v), activeColor: AppColors.primary),
              ],
            ),
          ),
          const SizedBox(height: 20),

          if (_feeEnabled) ...[
            const Text('Fee Percentage', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _transactionFeePercent,
                    min: 0.5,
                    max: 5.0,
                    divisions: 9,
                    activeColor: AppColors.primary,
                    label: '${_transactionFeePercent.toStringAsFixed(1)}%',
                    onChanged: (v) => setState(() => _transactionFeePercent = v),
                  ),
                ),
                Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${_transactionFeePercent.toStringAsFixed(1)}%',
                    style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Fee preview
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.4),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Fee Preview', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark)),
                  const SizedBox(height: 12),
                  _FeeRow(label: 'Contribution Amount', value: Formatters.formatBirr(exampleAmount)),
                  const Divider(height: 16),
                  _FeeRow(label: 'Platform Fee (${_transactionFeePercent.toStringAsFixed(1)}%)', value: '- ${Formatters.formatBirr(feeAmount)}', valueColor: AppColors.error),
                  const Divider(height: 16),
                  _FeeRow(label: 'Member Receives', value: Formatters.formatBirr(memberReceives), valueColor: AppColors.secondary, bold: true),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Fee tiers info
            const Text('Recommended Fee Tiers', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 10),
            _FeeTierCard(label: 'Low', percent: 0.5, description: 'Best for large groups (50+ members)', color: AppColors.secondary),
            const SizedBox(height: 8),
            _FeeTierCard(label: 'Standard', percent: 1.5, description: 'Recommended for most groups', color: AppColors.primary),
            const SizedBox(height: 8),
            _FeeTierCard(label: 'Premium', percent: 3.0, description: 'For groups with extra services', color: AppColors.warning),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Transaction fee set to ${_transactionFeePercent.toStringAsFixed(1)}%'), backgroundColor: AppColors.secondary),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14)),
                child: const Text('Save Fee Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // ── Subscriptions Tab ────────────────────────────────────────────────────────
  Widget _buildSubscriptions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current plan banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Current Plan: $_activePlan',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                      const Text('Renews on June 1, 2026',
                          style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: const Text('ACTIVE', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text('Available Plans', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 12),

          ..._plans.map((plan) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _PlanCard(
              plan: plan,
              isActive: plan.name == _activePlan,
              onSelect: () {
                setState(() => _activePlan = plan.name);
                if (plan.price > 0) {
                  _showUpgradeDialog(plan);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Switched to ${plan.name} plan'), backgroundColor: AppColors.secondary),
                  );
                }
              },
            ),
          )),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.infoLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.info.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.info, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Upgrading your plan gives your group access to higher loan limits and more members. Billed monthly in ETB.',
                    style: TextStyle(fontSize: 12, color: AppColors.info, height: 1.4),
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

  void _showUpgradeDialog(_Plan plan) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Upgrade to ${plan.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ETB ${plan.price}/month', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: plan.color)),
            const SizedBox(height: 12),
            ...plan.features.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, color: plan.color, size: 16),
                  const SizedBox(width: 8),
                  Text(f, style: const TextStyle(fontSize: 13)),
                ],
              ),
            )),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Upgraded to ${plan.name} plan!'), backgroundColor: AppColors.secondary),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: plan.color),
            child: const Text('Confirm Upgrade', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Loan Interest Tab ────────────────────────────────────────────────────────
  Widget _buildLoanInterest() {
    final exampleLoan = 10000.0;
    final interest = exampleLoan * _loanInterestRate / 100;
    final total = exampleLoan + interest;
    final monthly = total / _loanTermMonths;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enable toggle
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: AppColors.secondaryLight, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.account_balance_outlined, color: AppColors.secondary, size: 22),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Loan Interest', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textDark)),
                      Text('Earn interest on group loans', style: TextStyle(fontSize: 12, color: AppColors.textGray)),
                    ],
                  ),
                ),
                Switch(value: _interestEnabled, onChanged: (v) => setState(() => _interestEnabled = v), activeColor: AppColors.secondary),
              ],
            ),
          ),
          const SizedBox(height: 20),

          if (_interestEnabled) ...[
            // Interest rate slider
            const Text('Interest Rate (%)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _loanInterestRate,
                    min: 1.0,
                    max: 20.0,
                    divisions: 19,
                    activeColor: AppColors.secondary,
                    label: '${_loanInterestRate.toStringAsFixed(0)}%',
                    onChanged: (v) => setState(() => _loanInterestRate = v),
                  ),
                ),
                Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(color: AppColors.secondaryLight, borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    '${_loanInterestRate.toStringAsFixed(0)}%',
                    style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.secondary, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Loan term
            const Text('Loan Term (Months)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [1, 2, 3, 6, 12].map((m) {
                final selected = m == _loanTermMonths;
                return GestureDetector(
                  onTap: () => setState(() => _loanTermMonths = m),
                  child: Container(
                    width: 56, height: 48,
                    decoration: BoxDecoration(
                      color: selected ? AppColors.secondary : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: selected ? AppColors.secondary : AppColors.border, width: selected ? 2 : 1),
                    ),
                    child: Center(
                      child: Text(
                        '$m mo',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: selected ? Colors.white : AppColors.textGray),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Loan preview
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondaryLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Loan Preview (ETB 10,000)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark)),
                  const SizedBox(height: 12),
                  _FeeRow(label: 'Loan Amount', value: Formatters.formatBirr(exampleLoan)),
                  const Divider(height: 16),
                  _FeeRow(label: 'Interest (${_loanInterestRate.toStringAsFixed(0)}%)', value: '+ ${Formatters.formatBirr(interest)}', valueColor: AppColors.warning),
                  const Divider(height: 16),
                  _FeeRow(label: 'Total Repayment', value: Formatters.formatBirr(total), bold: true),
                  const Divider(height: 16),
                  _FeeRow(label: 'Monthly Payment ($_loanTermMonths months)', value: Formatters.formatBirr(monthly), valueColor: AppColors.secondary, bold: true),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Interest distribution info
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.warningLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.warning.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.warning, size: 18),
                      SizedBox(width: 8),
                      Text('How Interest is Distributed', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textDark)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _InterestRow(label: 'Platform fee', percent: 20, color: AppColors.primary),
                  const SizedBox(height: 6),
                  _InterestRow(label: 'Shared among group members', percent: 80, color: AppColors.secondary),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Loan interest set to ${_loanInterestRate.toStringAsFixed(0)}% for $_loanTermMonths months'),
                      backgroundColor: AppColors.secondary,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary, padding: const EdgeInsets.symmetric(vertical: 14)),
                child: const Text('Save Interest Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// ── Helper Widgets ────────────────────────────────────────────────────────────

class _RevenueCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;
  final String subtitle;
  final VoidCallback onTap;

  const _RevenueCard({
    required this.title, required this.amount, required this.icon,
    required this.color, required this.subtitle, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              width: 44, height: 44,
              decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark)),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(Formatters.formatBirr(amount), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: color)),
                const Icon(Icons.chevron_right, color: AppColors.textGray, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final String title;
  final double amount;
  final String date;
  final String type;

  const _TransactionRow({required this.title, required this.amount, required this.date, required this.type});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    switch (type) {
      case 'fee': color = AppColors.primary; icon = Icons.percent_outlined; break;
      case 'subscription': color = AppColors.warning; icon = Icons.star_outline; break;
      default: color = AppColors.secondary; icon = Icons.account_balance_outlined;
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                Text(date, style: const TextStyle(fontSize: 11, color: AppColors.textGray)),
              ],
            ),
          ),
          Text(Formatters.formatBirr(amount),
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: color)),
        ],
      ),
    );
  }
}

class _FeeRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  const _FeeRow({required this.label, required this.value, this.valueColor, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textGray)),
        Text(value, style: TextStyle(
          fontSize: 13,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
          color: valueColor ?? AppColors.textDark,
        )),
      ],
    );
  }
}

class _FeeTierCard extends StatelessWidget {
  final String label;
  final double percent;
  final String description;
  final Color color;

  const _FeeTierCard({required this.label, required this.percent, required this.description, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
            child: Text('${percent.toStringAsFixed(1)}%',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: color)),
                Text(description, style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final _Plan plan;
  final bool isActive;
  final VoidCallback onSelect;

  const _PlanCard({required this.plan, required this.isActive, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive ? plan.color.withOpacity(0.06) : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isActive ? plan.color : AppColors.border, width: isActive ? 2 : 1),
          boxShadow: isActive
              ? [BoxShadow(color: plan.color.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 3))]
              : const [BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(plan.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: plan.color)),
                const Spacer(),
                if (isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: plan.color, borderRadius: BorderRadius.circular(20)),
                    child: const Text('CURRENT', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                  ),
                if (!isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: plan.color),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('SELECT', style: TextStyle(color: plan.color, fontSize: 10, fontWeight: FontWeight.w700)),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              plan.price == 0 ? 'Free' : 'ETB ${plan.price}/month',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: plan.price == 0 ? AppColors.textGray : plan.color),
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),
            ...plan.features.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, color: plan.color, size: 15),
                  const SizedBox(width: 8),
                  Text(f, style: const TextStyle(fontSize: 12, color: AppColors.textDark)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _InterestRow extends StatelessWidget {
  final String label;
  final int percent;
  final Color color;

  const _InterestRow({required this.label, required this.percent, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textDark)),
                  Text('$percent%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: percent / 100,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Data Models ───────────────────────────────────────────────────────────────

class _Plan {
  final String name;
  final int price;
  final int maxMembers;
  final int maxGroups;
  final double loanLimit;
  final Color color;
  final List<String> features;

  const _Plan({
    required this.name, required this.price, required this.maxMembers,
    required this.maxGroups, required this.loanLimit, required this.color,
    required this.features,
  });
}
