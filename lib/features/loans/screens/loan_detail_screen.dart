import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../models/loan_model.dart';

class LoanDetailScreen extends StatelessWidget {
  final String loanId;
  const LoanDetailScreen({super.key, required this.loanId});

  @override
  Widget build(BuildContext context) {
    final loan = LoanModel(
      loanId: loanId, memberId: 'u1', groupId: '1',
      amount: 10000, interestRate: 5,
      requestDate: DateTime.now().subtract(const Duration(days: 10)),
      approvalDate: DateTime.now().subtract(const Duration(days: 8)),
      status: 'approved', memberName: 'Abebe Kebede',
      groupName: 'Family Savings', remainingBalance: 10500,
      reason: 'Home renovation expenses',
    );

    final repayments = [
      {'date': DateTime.now().subtract(const Duration(days: 3)), 'amount': 2000.0, 'method': 'Telebirr'},
      {'date': DateTime.now().subtract(const Duration(days: 1)), 'amount': 1500.0, 'method': 'CBE Birr'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Loan Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  StatusBadge(status: loan.status),
                  const SizedBox(height: 12),
                  Text(
                    Formatters.formatBirr(loan.amount),
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(loan.groupName ?? '', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _HeaderStat(label: 'Interest', value: Formatters.formatPercent(loan.interestRate)),
                      _HeaderStat(label: 'Total Due', value: Formatters.formatBirr(loan.totalWithInterest)),
                      _HeaderStat(label: 'Remaining', value: Formatters.formatBirr(loan.remainingBalance ?? 0)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Details card
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Loan Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  const SizedBox(height: 16),
                  _DetailRow(label: 'Requested', value: Formatters.formatDate(loan.requestDate)),
                  const Divider(height: 20),
                  if (loan.approvalDate != null) ...[
                    _DetailRow(label: 'Approved', value: Formatters.formatDate(loan.approvalDate!)),
                    const Divider(height: 20),
                  ],
                  _DetailRow(label: 'Group', value: loan.groupName ?? '-'),
                  if (loan.reason != null) ...[
                    const Divider(height: 20),
                    _DetailRow(label: 'Reason', value: loan.reason!),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Repayment progress
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Repayment Progress', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Paid so far', style: const TextStyle(fontSize: 13, color: AppColors.textGray)),
                      Text(
                        Formatters.formatBirr(loan.totalWithInterest - (loan.remainingBalance ?? 0)),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.secondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: loan.totalWithInterest > 0
                          ? (loan.totalWithInterest - (loan.remainingBalance ?? 0)) / loan.totalWithInterest
                          : 0,
                      backgroundColor: AppColors.border,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Remaining: ${Formatters.formatBirr(loan.remainingBalance ?? 0)}',
                          style: const TextStyle(fontSize: 12, color: AppColors.error)),
                      Text('Total: ${Formatters.formatBirr(loan.totalWithInterest)}',
                          style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Repayment history
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Repayment History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  const SizedBox(height: 16),
                  if (repayments.isEmpty)
                    const Center(child: Text('No repayments yet', style: TextStyle(color: AppColors.textGray)))
                  else
                    ...repayments.map((r) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(10)),
                                child: const Icon(Icons.check_circle_outline, color: AppColors.secondary, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(r['method'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textDark)),
                                    Text(Formatters.formatDate(r['date'] as DateTime), style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
                                  ],
                                ),
                              ),
                              Text(
                                '+${Formatters.formatBirr(r['amount'] as double)}',
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.secondary),
                              ),
                            ],
                          ),
                        )),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (loan.isApproved)
              AppButton(
                label: 'Make Repayment',
                onPressed: () {},
                icon: Icons.payments_outlined,
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final String label;
  final String value;
  const _HeaderStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: child,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textGray)),
        const SizedBox(width: 16),
        Flexible(
          child: Text(value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark),
              textAlign: TextAlign.end),
        ),
      ],
    );
  }
}
