import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../routes/app_routes.dart';
import '../../../services/group_service.dart';

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
  final _groupService = GroupService();

  int _cycleDuration = 1; // months
  DateTime? _startDate;
  bool _isLoading = false;

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
    try {
      final group = await _groupService.createGroup(
        groupName: _nameController.text.trim(),
        contributionAmount: double.parse(_amountController.text),
        cycleDuration: _cycleDuration,
        maxMembers: int.tryParse(_membersController.text),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        startDate: _startDate,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Group created successfully!'),
            backgroundColor: AppColors.secondary,
          ),
        );
        context.go('/groups/${group.groupId}');
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
      appBar: AppBar(title: const Text('Create Group')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
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
                        width: 52,
                        height: 52,
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
                            Text(
                              'New Equb Group',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Set up your savings group',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

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
                    const Text(
                      'Cycle Duration',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark),
                    ),
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
                          const Icon(Icons.calendar_month_outlined, color: AppColors.textGray, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: _cycleDuration,
                                isExpanded: true,
                                items: List.generate(24, (i) => i + 1)
                                    .map((m) => DropdownMenuItem(
                                          value: m,
                                          child: Text(m == 1 ? '1 Month' : '$m Months'),
                                        ))
                                    .toList(),
                                onChanged: (v) => setState(() => _cycleDuration = v!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Start Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Start Date (Optional)',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark),
                    ),
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
