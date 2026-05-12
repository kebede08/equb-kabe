import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../services/group_service.dart';

class JoinGroupScreen extends StatefulWidget {
  const JoinGroupScreen({super.key});

  @override
  State<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _groupService = GroupService();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _joinGroup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      // In a real app, we'd look up the group by invite code first
      // For now, we use the code as the group ID
      await _groupService.joinGroup('', inviteCode: _codeController.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully joined the group!'),
            backgroundColor: AppColors.secondary,
          ),
        );
        context.go('/groups');
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
      appBar: AppBar(title: const Text('Join Group')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Illustration
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.group_add_outlined, size: 60, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Join an Equb Group',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textDark),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter the invite code shared by the group admin to join.',
                  style: TextStyle(fontSize: 15, color: AppColors.textGray, height: 1.5),
                ),
                const SizedBox(height: 32),

                AppTextField(
                  label: 'Invite Code',
                  hint: 'e.g. EQB-XXXX-XXXX',
                  controller: _codeController,
                  prefixIcon: Icons.vpn_key_outlined,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Invite code is required';
                    if (v.trim().length < 4) return 'Enter a valid invite code';
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _joinGroup(),
                ),
                const SizedBox(height: 32),

                AppButton(
                  label: 'Join Group',
                  onPressed: _joinGroup,
                  isLoading: _isLoading,
                  icon: Icons.login_outlined,
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: 'Cancel',
                  variant: ButtonVariant.outline,
                  onPressed: () => context.pop(),
                ),

                const Spacer(),

                // Info card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.infoLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.info.withOpacity(0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.info, size: 20),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Ask the group admin to share the invite code with you. Codes are case-insensitive.',
                          style: TextStyle(fontSize: 13, color: AppColors.info, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
