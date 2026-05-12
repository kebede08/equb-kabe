import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../models/group_model.dart';
import '../../../services/loan_service.dart';

class RequestLoanScreen extends StatefulWidget {
  const RequestLoanScreen({super.key});

  @override
  State<RequestLoanScreen> createState() => _RequestLoanScreenState();
}

class _RequestLoanScreenState extends State<RequestLoanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();
  final _loanService = LoanService();
  bool _isLoading = false;
  GroupModel? _selectedGroup;

  final List<GroupModel> _groups = [
    GroupModel(groupId: '1', groupName: 'Family Savings', adminId: 'u1',
        contributionAmount: 5000, cycleDuration: 10, status: 'active',
        createdAt: DateTime.now(), totalPool: 40000),
    GroupModel(groupId: '2', groupName: 'Office Equb', adminId: 'u1',
        contributionAmount: 2000, cycleDuration: 12, status: 'active',
        createdAt: DateTime.now(), totalPool: 24000),
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  double get _maxLoan => (_selectedGroup?.totalPool ?? 0) * 0.5;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGroup == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a group'), backgroundColor: AppColors.error),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _loanService.requestLoan(
        memberId: 'u1',
        groupId: _selectedGroup!.groupId,
        amount: double.parse(_amountController.text),
        reason: _reasonController.text.trim().isEmpty ? null : _reasonController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Loan request submitted!'), backgroundColor: AppColors.secondary),
        );
        context.go('/loans');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Loan')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.account_balance_outlined, color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Loan Request', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                            SizedBox(height: 2),
                            Text('Max 50% of group pool ┬╖ 5% interest', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Group selector
                const Text('Select Group', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<GroupModel>(
                      value: _selectedGroup,
                      isExpanded: true,
                      hint: const Text('Choose a group', style: TextStyle(color: AppColors.textLight)),
                      items: _groups.map((g) => DropdownMenuItem(
                        value: g,
                        child: Row(
                          children: [
                            const Icon(Icons.group_outlined, size: 16, color: AppColors.textGray),
                            const SizedBox(width: 8),
                            Expanded(child: Text(g.groupName)),
                            Text(Formatters.formatBirr(g.totalPool ?? 0),
                                style: const TextStyle(fontSize: 12, color: AppColors.secondary)),
                          ],
                        ),
                      )).toList(),
                      onChanged: (v) => setState(() => _selectedGroup = v),
                    ),
                  ),
                ),

                if (_selectedGroup != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppColors.secondary, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Max loan: ${Formatters.formatBirr(_maxLoan)}',
                          style: const TextStyle(fontSize: 13, color: AppColors.secondary, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),

                AppTextField(
                  label: 'Loan Amount (ETB)',
                  hint: 'Enter amount',
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  prefixIcon: Icons.payments_outlined,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                  validator: (v) {
                    final err = Validators.validateAmount(v);
                    if (err != null) return err;
                    final amount = double.tryParse(v!) ?? 0;
                    if (_selectedGroup != null && amount > _maxLoan) {
                      return 'Cannot exceed max loan of ${Formatters.formatBirr(_maxLoan)}';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),

                AppTextField(
                  label: 'Reason (Optional)',
                  hint: 'Why do you need this loan?',
                  controller: _reasonController,
                  prefixIcon: Icons.description_outlined,
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 28),

                // Summary
                if (_amountController.text.isNotEmpty && double.tryParse(_amountController.text) != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _SummaryRow(label: 'Principal', value: Formatters.formatBirr(double.parse(_amountController.text))),
                        const SizedBox(height: 8),
                        _SummaryRow(label: 'Interest (5%)', value: Formatters.formatBirr(double.parse(_amountController.text) * 0.05)),
                        const Divider(height: 16),
                        _SummaryRow(
                          label: 'Total Repayment',
                          value: Formatters.formatBirr(double.parse(_amountController.text) * 1.05),
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 32),

                AppButton(label: 'Submit Request', onPressed: _submit, isLoading: _isLoading, icon: Icons.send_outlined),
                const SizedBox(height: 12),
                AppButton(label: 'Cancel', variant: ButtonVariant.outline, onPressed: () => context.pop()),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  const _SummaryRow({required this.label, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: AppColors.textGray, fontWeight: isBold ? FontWeight.w700 : FontWeight.w400)),
        Text(value, style: TextStyle(fontSize: 13, color: isBold ? AppColors.primary : AppColors.textDark, fontWeight: isBold ? FontWeight.w700 : FontWeight.w600)),
      ],
    );
  }
}
