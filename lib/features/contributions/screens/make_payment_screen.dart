import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../services/contribution_service.dart';

class MakePaymentScreen extends StatefulWidget {
  final String contributionId;
  const MakePaymentScreen({super.key, required this.contributionId});

  @override
  State<MakePaymentScreen> createState() => _MakePaymentScreenState();
}

class _MakePaymentScreenState extends State<MakePaymentScreen> {
  final _contributionService = ContributionService();
  String _selectedMethod = AppConstants.paymentTelebirr;
  bool _isLoading = false;

  // Mock contribution data
  final double _amount = 5000;
  final String _groupName = 'Family Savings';
  final DateTime _dueDate = DateTime.now().add(const Duration(days: 3));

  final List<_PaymentMethod> _methods = [
    _PaymentMethod(id: AppConstants.paymentTelebirr, name: 'Telebirr', icon: Icons.phone_android, color: Color(0xFF1E88E5)),
    _PaymentMethod(id: AppConstants.paymentCBE, name: 'CBE Birr', icon: Icons.account_balance, color: Color(0xFF43A047)),
    _PaymentMethod(id: AppConstants.paymentCash, name: 'Cash', icon: Icons.money, color: Color(0xFFF57C00)),
  ];

  Future<void> _pay() async {
    setState(() => _isLoading = true);
    try {
      await _contributionService.payContribution(
        widget.contributionId,
        paymentMethod: _selectedMethod,
      );
      if (mounted) {
        _showSuccessDialog();
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: const BoxDecoration(color: AppColors.successLight, shape: BoxShape.circle),
              child: const Icon(Icons.check_circle, color: AppColors.secondary, size: 48),
            ),
            const SizedBox(height: 20),
            const Text('Payment Successful!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 8),
            Text(
              'You have successfully paid ${Formatters.formatBirr(_amount)} for $_groupName.',
              style: const TextStyle(color: AppColors.textGray, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.go('/contributions');
              },
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Make Payment')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Payment summary card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text('Amount to Pay', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(
                      Formatters.formatBirr(_amount),
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            const Icon(Icons.group_outlined, color: Colors.white70, size: 16),
                            const SizedBox(width: 6),
                            Text(_groupName, style: const TextStyle(color: Colors.white, fontSize: 13)),
                          ]),
                          Row(children: [
                            const Icon(Icons.calendar_today_outlined, color: Colors.white70, size: 16),
                            const SizedBox(width: 6),
                            Text('Due ${Formatters.formatDate(_dueDate)}',
                                style: const TextStyle(color: Colors.white, fontSize: 13)),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              const Text('Select Payment Method',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
              const SizedBox(height: 16),

              ..._methods.map((method) => _PaymentMethodTile(
                    method: method,
                    isSelected: _selectedMethod == method.id,
                    onTap: () => setState(() => _selectedMethod = method.id),
                  )),

              const SizedBox(height: 32),

              // Payment instructions
              if (_selectedMethod == AppConstants.paymentTelebirr)
                _InstructionCard(
                  title: 'Telebirr Instructions',
                  steps: [
                    'Open your Telebirr app',
                    'Go to Send Money',
                    'Enter the group account number',
                    'Enter amount: ${Formatters.formatBirr(_amount)}',
                    'Confirm the payment',
                  ],
                  color: const Color(0xFF1E88E5),
                )
              else if (_selectedMethod == AppConstants.paymentCBE)
                _InstructionCard(
                  title: 'CBE Birr Instructions',
                  steps: [
                    'Open your CBE Birr app',
                    'Select Transfer',
                    'Enter the group account number',
                    'Enter amount: ${Formatters.formatBirr(_amount)}',
                    'Confirm the transfer',
                  ],
                  color: const Color(0xFF43A047),
                )
              else
                _InstructionCard(
                  title: 'Cash Payment',
                  steps: [
                    'Contact your group admin',
                    'Pay ${Formatters.formatBirr(_amount)} in cash',
                    'Get a receipt from the admin',
                    'Admin will mark your payment as paid',
                  ],
                  color: const Color(0xFFF57C00),
                ),

              const SizedBox(height: 32),

              AppButton(
                label: 'Confirm Payment',
                onPressed: _pay,
                isLoading: _isLoading,
                icon: Icons.check_circle_outline,
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Cancel',
                variant: ButtonVariant.outline,
                onPressed: () => context.pop(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentMethod {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  const _PaymentMethod({required this.id, required this.name, required this.icon, required this.color});
}

class _PaymentMethodTile extends StatelessWidget {
  final _PaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;
  const _PaymentMethodTile({required this.method, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: method.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(method.icon, color: method.color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(method.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.primary : AppColors.textDark,
                  )),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary, size: 22)
            else
              const Icon(Icons.radio_button_unchecked, color: AppColors.border, size: 22),
          ],
        ),
      ),
    );
  }
}

class _InstructionCard extends StatelessWidget {
  final String title;
  final List<String> steps;
  final Color color;
  const _InstructionCard({required this.title, required this.steps, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.info_outline, color: color, size: 18),
            const SizedBox(width: 8),
            Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 14)),
          ]),
          const SizedBox(height: 12),
          ...steps.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 20, height: 20,
                      decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
                      child: Center(
                        child: Text('${e.key + 1}',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(e.value, style: TextStyle(fontSize: 13, color: color.withOpacity(0.8)))),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
