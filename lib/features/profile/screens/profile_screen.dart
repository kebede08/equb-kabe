import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: const Text('KD', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ),
                    const SizedBox(height: 12),
                    const Text('Kebede Deleleg', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    const Text('+251 947 642 560', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Stats
                  Row(
                    children: [
                      Expanded(child: _StatCard(label: 'Groups', value: '3', icon: Icons.group_outlined)),
                      const SizedBox(width: 12),
                      Expanded(child: _StatCard(label: 'Total Saved', value: 'ETB 64K', icon: Icons.savings_outlined)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Account section
                  _Section(
                    title: 'Account',
                    items: [
                      _MenuItem(icon: Icons.person_outline, label: 'Edit Profile', onTap: () => _showEditProfile(context)),
                      _MenuItem(icon: Icons.lock_outline, label: 'Change Password', onTap: () => context.go(AppRoutes.settings)),
                      _MenuItem(icon: Icons.settings_outlined, label: 'Settings', onTap: () => context.go(AppRoutes.settings)),
                      _MenuItem(icon: Icons.fingerprint, label: 'Biometric Login', trailing: Switch(value: false, onChanged: (v) {})),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Preferences
                  _Section(
                    title: 'Preferences',
                    items: [
                      _MenuItem(icon: Icons.notifications_outlined, label: 'Notifications', onTap: () => context.go(AppRoutes.settings)),
                      _MenuItem(icon: Icons.language_outlined, label: 'Language', trailing: const Text('English', style: TextStyle(color: AppColors.textGray))),
                      _MenuItem(icon: Icons.dark_mode_outlined, label: 'Dark Mode', trailing: Switch(value: false, onChanged: (v) {})),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Support
                  _Section(
                    title: 'Support',
                    items: [
                      _MenuItem(icon: Icons.monetization_on_outlined, label: 'Revenue Management', onTap: () => context.go(AppRoutes.revenue)),
                      _MenuItem(icon: Icons.bar_chart_outlined, label: 'Reports', onTap: () => context.go(AppRoutes.reports)),
                      _MenuItem(icon: Icons.school_outlined, label: 'Financial Education', onTap: () => context.go(AppRoutes.education)),
                      _MenuItem(icon: Icons.help_outline, label: 'Help Center', onTap: () => _showHelpCenter(context)),
                      _MenuItem(icon: Icons.privacy_tip_outlined, label: 'Privacy Policy', onTap: () => _showPolicy(context, 'Privacy Policy', 'We collect only the data necessary to provide the Equb service. Your personal information is never sold to third parties. All data is encrypted and stored securely. You may request deletion of your account and data at any time by contacting support.')),
                      _MenuItem(icon: Icons.description_outlined, label: 'Terms of Service', onTap: () => _showPolicy(context, 'Terms of Service', 'By using Equb, you agree to participate honestly in savings groups. You are responsible for making contributions on time. The platform is not liable for disputes between group members. Fraudulent activity will result in immediate account termination.')),
                      _MenuItem(icon: Icons.info_outline, label: 'About', trailing: const Text('v1.0.0', style: TextStyle(color: AppColors.textGray))),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Logout
                  GestureDetector(
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true && context.mounted) {
                        context.go(AppRoutes.login);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.errorLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.error.withOpacity(0.3)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: AppColors.error, size: 20),
                          SizedBox(width: 8),
                          Text('Logout', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600, fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> items;
  const _Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textGray)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: items.map((item) {
              final isLast = items.indexOf(item) == items.length - 1;
              return Column(
                children: [
                  item,
                  if (!isLast) const Divider(height: 1, indent: 56),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  const _MenuItem({required this.icon, required this.label, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textGray, size: 22),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 15, color: AppColors.textDark))),
            if (trailing != null)
              trailing!
            else if (onTap != null)
              const Icon(Icons.chevron_right, color: AppColors.textGray, size: 20),
          ],
        ),
      ),
    );
  }
}
