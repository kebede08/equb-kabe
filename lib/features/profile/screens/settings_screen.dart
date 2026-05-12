import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Notification toggles
  bool _pushNotifications = true;
  bool _paymentReminders = true;
  bool _groupUpdates = true;
  bool _loanAlerts = true;
  bool _marketingEmails = false;

  // Privacy toggles
  bool _biometricLogin = false;
  bool _twoFactorAuth = false;
  bool _hideBalance = false;

  // Appearance
  bool _darkMode = false;
  String _language = 'English';
  String _currency = 'ETB (Ethiopian Birr)';

  final List<String> _languages = ['English', 'Amharic', 'Oromiffa', 'Tigrinya'];
  final List<String> _currencies = ['ETB (Ethiopian Birr)', 'USD (US Dollar)'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.profile),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Notifications section
          _SectionTitle(title: 'Notifications'),
          _SettingsCard(
            children: [
              _ToggleTile(
                icon: Icons.notifications_outlined,
                iconColor: AppColors.primary,
                title: 'Push Notifications',
                subtitle: 'Receive alerts on your device',
                value: _pushNotifications,
                onChanged: (v) => setState(() => _pushNotifications = v),
              ),
              const _Divider(),
              _ToggleTile(
                icon: Icons.payment_outlined,
                iconColor: AppColors.warning,
                title: 'Payment Reminders',
                subtitle: 'Get reminded before due dates',
                value: _paymentReminders,
                onChanged: (v) => setState(() => _paymentReminders = v),
              ),
              const _Divider(),
              _ToggleTile(
                icon: Icons.group_outlined,
                iconColor: AppColors.secondary,
                title: 'Group Updates',
                subtitle: 'New members, payouts, and changes',
                value: _groupUpdates,
                onChanged: (v) => setState(() => _groupUpdates = v),
              ),
              const _Divider(),
              _ToggleTile(
                icon: Icons.account_balance_outlined,
                iconColor: AppColors.info,
                title: 'Loan Alerts',
                subtitle: 'Loan approvals and repayment reminders',
                value: _loanAlerts,
                onChanged: (v) => setState(() => _loanAlerts = v),
              ),
              const _Divider(),
              _ToggleTile(
                icon: Icons.email_outlined,
                iconColor: AppColors.textGray,
                title: 'Marketing Emails',
                subtitle: 'News, tips, and promotions',
                value: _marketingEmails,
                onChanged: (v) => setState(() => _marketingEmails = v),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Security section
          _SectionTitle(title: 'Security & Privacy'),
          _SettingsCard(
            children: [
              _ToggleTile(
                icon: Icons.fingerprint,
                iconColor: AppColors.primary,
                title: 'Biometric Login',
                subtitle: 'Use fingerprint or face ID to sign in',
                value: _biometricLogin,
                onChanged: (v) => setState(() => _biometricLogin = v),
              ),
              const _Divider(),
              _ToggleTile(
                icon: Icons.security_outlined,
                iconColor: AppColors.secondary,
                title: 'Two-Factor Authentication',
                subtitle: 'Extra security via SMS code',
                value: _twoFactorAuth,
                onChanged: (v) => setState(() => _twoFactorAuth = v),
              ),
              const _Divider(),
              _ToggleTile(
                icon: Icons.visibility_off_outlined,
                iconColor: AppColors.textGray,
                title: 'Hide Balance',
                subtitle: 'Mask amounts on the home screen',
                value: _hideBalance,
                onChanged: (v) => setState(() => _hideBalance = v),
              ),
              const _Divider(),
              _NavTile(
                icon: Icons.lock_outline,
                iconColor: AppColors.warning,
                title: 'Change Password',
                onTap: () => _showChangePasswordSheet(context),
              ),
              const _Divider(),
              _NavTile(
                icon: Icons.devices_outlined,
                iconColor: AppColors.info,
                title: 'Active Sessions',
                subtitle: 'Manage logged-in devices',
                onTap: () => _showActiveSessionsSheet(context),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Appearance section
          _SectionTitle(title: 'Appearance'),
          _SettingsCard(
            children: [
              _ToggleTile(
                icon: Icons.dark_mode_outlined,
                iconColor: AppColors.textDark,
                title: 'Dark Mode',
                subtitle: 'Switch to dark theme',
                value: _darkMode,
                onChanged: (v) => setState(() => _darkMode = v),
              ),
              const _Divider(),
              _SelectTile(
                icon: Icons.language_outlined,
                iconColor: AppColors.primary,
                title: 'Language',
                value: _language,
                onTap: () => _showLanguagePicker(context),
              ),
              const _Divider(),
              _SelectTile(
                icon: Icons.currency_exchange_outlined,
                iconColor: AppColors.secondary,
                title: 'Currency Display',
                value: _currency,
                onTap: () => _showCurrencyPicker(context),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Data & Storage section
          _SectionTitle(title: 'Data & Storage'),
          _SettingsCard(
            children: [
              _NavTile(
                icon: Icons.download_outlined,
                iconColor: AppColors.info,
                title: 'Export My Data',
                subtitle: 'Download all your account data',
                onTap: () => _confirmExport(context),
              ),
              const _Divider(),
              _NavTile(
                icon: Icons.delete_sweep_outlined,
                iconColor: AppColors.warning,
                title: 'Clear Cache',
                subtitle: 'Free up storage space',
                onTap: () => _confirmClearCache(context),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Danger zone
          _SectionTitle(title: 'Account'),
          _SettingsCard(
            children: [
              _NavTile(
                icon: Icons.logout,
                iconColor: AppColors.error,
                title: 'Logout',
                onTap: () => context.go(AppRoutes.login),
              ),
              const _Divider(),
              _NavTile(
                icon: Icons.delete_forever_outlined,
                iconColor: AppColors.error,
                title: 'Delete Account',
                subtitle: 'Permanently remove your account',
                onTap: () => _confirmDeleteAccount(context),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // App version
          Center(
            child: Column(
              children: const [
                Text('Equb App', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textGray)),
                SizedBox(height: 4),
                Text('Version 1.0.0 (Build 1)', style: TextStyle(fontSize: 12, color: AppColors.textLight)),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _showChangePasswordSheet(BuildContext context) {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Change Password', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 20),
            _PasswordField(controller: currentCtrl, label: 'Current Password'),
            const SizedBox(height: 12),
            _PasswordField(controller: newCtrl, label: 'New Password'),
            const SizedBox(height: 12),
            _PasswordField(controller: confirmCtrl, label: 'Confirm New Password'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password updated successfully'), backgroundColor: AppColors.secondary),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14)),
                child: const Text('Update Password', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showActiveSessionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Active Sessions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 16),
            _SessionTile(device: 'This Device', info: 'Android · Addis Ababa, ET', isCurrent: true),
            const SizedBox(height: 8),
            _SessionTile(device: 'Chrome Browser', info: 'Windows · 2 days ago', isCurrent: false),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Sign Out All Other Devices', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Language', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 12),
            ..._languages.map((lang) => ListTile(
              title: Text(lang),
              trailing: _language == lang ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                setState(() => _language = lang);
                Navigator.pop(ctx);
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Currency', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 12),
            ..._currencies.map((cur) => ListTile(
              title: Text(cur),
              trailing: _currency == cur ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                setState(() => _currency = cur);
                Navigator.pop(ctx);
              },
            )),
          ],
        ),
      ),
    );
  }

  void _confirmExport(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Your account data will be prepared and sent to your registered email address.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export request submitted. Check your email.'), backgroundColor: AppColors.secondary),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Export', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmClearCache(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will clear temporary files. Your account data will not be affected.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully'), backgroundColor: AppColors.secondary),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Clear', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('This action is permanent and cannot be undone. All your data, groups, and history will be deleted.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete Account', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ── Shared widgets ──────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textGray, letterSpacing: 0.5)),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, indent: 56, endIndent: 0);
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                if (subtitle != null)
                  Text(subtitle!, style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _NavTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                  if (subtitle != null)
                    Text(subtitle!, style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textGray, size: 20),
          ],
        ),
      ),
    );
  }
}

class _SelectTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final VoidCallback onTap;

  const _SelectTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            ),
            Text(value, style: const TextStyle(fontSize: 13, color: AppColors.textGray)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: AppColors.textGray, size: 20),
          ],
        ),
      ),
    );
  }
}

class _PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  const _PasswordField({required this.controller, required this.label});

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscure,
      decoration: InputDecoration(
        labelText: widget.label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: IconButton(
          icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  final String device;
  final String info;
  final bool isCurrent;
  const _SessionTile({required this.device, required this.info, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCurrent ? AppColors.primaryLight : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isCurrent ? AppColors.primary.withOpacity(0.3) : AppColors.border),
      ),
      child: Row(
        children: [
          Icon(isCurrent ? Icons.phone_android : Icons.computer_outlined, color: isCurrent ? AppColors.primary : AppColors.textGray, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(device, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textDark)),
                    if (isCurrent) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                        child: const Text('Current', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ],
                ),
                Text(info, style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
