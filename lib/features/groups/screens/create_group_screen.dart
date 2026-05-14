import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../routes/app_routes.dart';

// Payout method enum
enum PayoutMethod { lottery, rotation, bidding }

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _membersController = TextEditingController();

  // Cycle type: 'weeks' or 'months'
  String _cycleType = 'weeks';
  int _cycleDuration = 1;
  DateTime? _startDate;
  bool _isLoading = false;
  PayoutMethod _payoutMethod = PayoutMethod.lottery;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _membersController.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _createGroup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Group created successfully!'),
          backgroundColor: AppColors.secondary,
        ),
      );
      context.go(AppRoutes.groups);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Group')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52, height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.group_add, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('New Equb Group', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                            SizedBox(height: 4),
                            Text('Set up your savings group', style: TextStyle(color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // ── Group Information ──────────────────────────────
                _SectionLabel(label: 'Group Information'),
                const SizedBox(height: 16),

                AppTextField(
                  label: 'Group Name',
                  hint: 'e.g. Family Savings',
                  controller: _nameController,
                  prefixIcon: Icons.group_outlined,
                  validator: Validators.validateGroupName,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),

                AppTextField(
                  label: 'Description (Optional)',
                  hint: 'Brief description of the group',
                  controller: _descriptionController,
                  prefixIcon: Icons.description_outlined,
                  maxLines: 3,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 28),

                // ── Contribution Settings ──────────────────────────
                _SectionLabel(label: 'Contribution Settings'),
                const SizedBox(height: 16),

                AppTextField(
                  label: 'Contribution Amount (ETB)',
                  hint: 'e.g. 5000',
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  prefixIcon: Icons.payments_outlined,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                  validator: Validators.validateAmount,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),

                AppTextField(
                  label: 'Max Members',
                  hint: 'e.g. 10',
                  controller: _membersController,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.people_outline,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: Validators.validateMembers,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 20),

                // Cycle Duration
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Cycle Duration', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                    const SizedBox(height: 8),
                    // Week / Month toggle
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() { _cycleType = 'weeks'; _cycleDuration = 1; }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _cycleType == 'weeks' ? AppColors.primary : AppColors.surfaceVariant,
                                borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
                                border: Border.all(color: _cycleType == 'weeks' ? AppColors.primary : AppColors.border),
                              ),
                              child: Center(
                                child: Text('Weekly', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _cycleType == 'weeks' ? Colors.white : AppColors.textGray)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() { _cycleType = 'months'; _cycleDuration = 1; }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _cycleType == 'months' ? AppColors.primary : AppColors.surfaceVariant,
                                borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
                                border: Border.all(color: _cycleType == 'months' ? AppColors.primary : AppColors.border),
                              ),
                              child: Center(
                                child: Text('Monthly', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _cycleType == 'months' ? Colors.white : AppColors.textGray)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Duration picker
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month_outlined, color: AppColors.textGray, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: _cycleDuration,
                                isExpanded: true,
                                items: _cycleType == 'weeks'
                                    ? List.generate(12, (i) => i + 1)
                                        .map((w) => DropdownMenuItem(value: w, child: Text(w == 1 ? '1 Week' : '$w Weeks')))
                                        .toList()
                                    : List.generate(24, (i) => i + 1)
                                        .map((m) => DropdownMenuItem(value: m, child: Text(m == 1 ? '1 Month' : '$m Months')))
                                        .toList(),
                                onChanged: (v) => setState(() => _cycleDuration = v!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _cycleType == 'weeks'
                          ? 'Members contribute every $_cycleDuration week${_cycleDuration > 1 ? "s" : ""}'
                          : 'Members contribute every $_cycleDuration month${_cycleDuration > 1 ? "s" : ""}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textGray),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Start Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Start Date (Optional)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickStartDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, color: AppColors.textGray, size: 20),
                            const SizedBox(width: 12),
                            Text(
                              _startDate == null
                                  ? 'Select start date'
                                  : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                              style: TextStyle(
                                color: _startDate == null ? AppColors.textLight : AppColors.textDark,
                                fontSize: 14,
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.chevron_right, color: AppColors.textGray, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // ── Payout Method ──────────────────────────────────
                _SectionLabel(label: 'Payout Method'),
                const SizedBox(height: 8),
                const Text(
                  'Choose how to decide who receives the pool each cycle',
                  style: TextStyle(fontSize: 13, color: AppColors.textGray),
                ),
                const SizedBox(height: 16),

                _PayoutMethodCard(
                  method: PayoutMethod.lottery,
                  selected: _payoutMethod == PayoutMethod.lottery,
                  title: 'Lottery Draw',
                  subtitle: 'A member is randomly selected each cycle. Fair and unbiased.',
                  icon: Icons.casino_outlined,
                  color: AppColors.primary,
                  onTap: () => setState(() => _payoutMethod = PayoutMethod.lottery),
                ),
                const SizedBox(height: 12),

                _PayoutMethodCard(
                  method: PayoutMethod.rotation,
                  selected: _payoutMethod == PayoutMethod.rotation,
                  title: 'Fixed Rotation',
                  subtitle: 'Members agree on a pre-set order before the group starts.',
                  icon: Icons.swap_horiz_outlined,
                  color: AppColors.secondary,
                  onTap: () => setState(() => _payoutMethod = PayoutMethod.rotation),
                ),
                const SizedBox(height: 12),

                _PayoutMethodCard(
                  method: PayoutMethod.bidding,
                  selected: _payoutMethod == PayoutMethod.bidding,
                  title: 'Bidding',
                  subtitle: 'Members bid for early payout. Highest bidder wins; interest shared among all.',
                  icon: Icons.gavel_outlined,
                  color: AppColors.warning,
                  onTap: () => setState(() => _payoutMethod = PayoutMethod.bidding),
                ),

                // Extra info based on selected method
                const SizedBox(height: 16),
                _PayoutMethodInfo(method: _payoutMethod),

                const SizedBox(height: 36),

                AppButton(
                  label: 'Create Group',
                  onPressed: _createGroup,
                  isLoading: _isLoading,
                  icon: Icons.check_circle_outline,
                ),
                const SizedBox(height: 16),
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
      ),
    );
  }
}

// ── Payout Method Card ───────────────────────────────────────────────────────

class _PayoutMethodCard extends StatelessWidget {
  final PayoutMethod method;
  final bool selected;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _PayoutMethodCard({
    required this.method,
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.06) : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? color : AppColors.border,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [BoxShadow(color: color.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 3))]
              : const [BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: selected ? color : AppColors.textDark)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textGray, height: 1.4)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 22, height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: selected ? color : AppColors.border, width: 2),
                color: selected ? color : Colors.transparent,
              ),
              child: selected ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Payout Method Info Box ───────────────────────────────────────────────────

class _PayoutMethodInfo extends StatelessWidget {
  final PayoutMethod method;
  const _PayoutMethodInfo({required this.method});

  @override
  Widget build(BuildContext context) {
    switch (method) {
      case PayoutMethod.lottery:
        return _InfoBox(
          color: AppColors.primary,
          icon: Icons.info_outline,
          items: const [
            'Each cycle a random draw picks the winner',
            'All members have equal chance every round',
            'Draw happens automatically on the cycle date',
            'Results are visible to all group members',
          ],
        );
      case PayoutMethod.rotation:
        return _InfoBox(
          color: AppColors.secondary,
          icon: Icons.info_outline,
          items: const [
            'You set the payout order when group starts',
            'Members can swap their round by mutual agreement',
            'Everyone knows in advance when they receive',
            'Most predictable method for planning',
          ],
        );
      case PayoutMethod.bidding:
        return _InfoBox(
          color: AppColors.warning,
          icon: Icons.info_outline,
          items: const [
            'Members bid an interest % to receive early',
            'Highest bidder gets the pool that cycle',
            'The bid interest is split among all other members',
            'Later rounds receive more due to accumulated interest',
          ],
        );
    }
  }
}

class _InfoBox extends StatelessWidget {
  final Color color;
  final IconData icon;
  final List<String> items;
  const _InfoBox({required this.color, required this.icon, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check_circle_outline, color: color, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text(item, style: TextStyle(fontSize: 12, color: color.withOpacity(0.85), height: 1.4))),
            ],
          ),
        )).toList(),
      ),
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 4, height: 18, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget child;
  const _DropdownField({required this.label, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textGray, size: 20),
              const SizedBox(width: 12),
              Expanded(child: child),
            ],
          ),
        ),
      ],
    );
  }
}
