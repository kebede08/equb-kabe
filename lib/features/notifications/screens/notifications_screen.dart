import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationModel> _notifications = [
    NotificationModel(notificationId: 'n1', userId: 'u1', title: 'Payment Reminder',
        message: 'Your contribution for Family Savings is due in 3 days',
        type: 'reminder', isRead: false, createdAt: DateTime.now().subtract(const Duration(hours: 2))),
    NotificationModel(notificationId: 'n2', userId: 'u1', title: 'Loan Approved',
        message: 'Your loan request of ETB 10,000 has been approved',
        type: 'loan', isRead: false, createdAt: DateTime.now().subtract(const Duration(hours: 5))),
    NotificationModel(notificationId: 'n3', userId: 'u1', title: 'New Member Joined',
        message: 'Liya Worku joined Family Savings group',
        type: 'group', isRead: true, createdAt: DateTime.now().subtract(const Duration(days: 1))),
    NotificationModel(notificationId: 'n4', userId: 'u1', title: 'Payment Received',
        message: 'Your contribution of ETB 5,000 was received',
        type: 'payment', isRead: true, createdAt: DateTime.now().subtract(const Duration(days: 2))),
    NotificationModel(notificationId: 'n5', userId: 'u1', title: 'Overdue Payment',
        message: 'Your Office Equb contribution is overdue',
        type: 'alert', isRead: true, createdAt: DateTime.now().subtract(const Duration(days: 3))),
  ];

  @override
  Widget build(BuildContext context) {
    final unread = _notifications.where((n) => !n.isRead).toList();
    final read = _notifications.where((n) => n.isRead).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (unread.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() {
                  for (var n in _notifications) {
                    _notifications[_notifications.indexOf(n)] = n.copyWith(isRead: true);
                  }
                });
              },
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                    child: const Icon(Icons.notifications_outlined, size: 40, color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  const Text('No notifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  const Text('You\'re all caught up!', style: TextStyle(color: AppColors.textGray)),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (unread.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text('New', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  ),
                  ...unread.map((n) => _NotificationTile(
                        notification: n,
                        onTap: () => setState(() {
                          final index = _notifications.indexOf(n);
                          _notifications[index] = n.copyWith(isRead: true);
                        }),
                      )),
                  const SizedBox(height: 20),
                ],
                if (read.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text('Earlier', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  ),
                  ...read.map((n) => _NotificationTile(notification: n, onTap: () {})),
                ],
              ],
            ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  const _NotificationTile({required this.notification, required this.onTap});

  IconData _getIcon() {
    switch (notification.type) {
      case 'payment': return Icons.payments;
      case 'loan': return Icons.account_balance;
      case 'group': return Icons.group;
      case 'reminder': return Icons.alarm;
      case 'alert': return Icons.warning_amber;
      default: return Icons.notifications;
    }
  }

  Color _getColor() {
    switch (notification.type) {
      case 'payment': return AppColors.secondary;
      case 'loan': return AppColors.info;
      case 'group': return AppColors.primary;
      case 'reminder': return AppColors.warning;
      case 'alert': return AppColors.error;
      default: return AppColors.textGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notification.isRead ? AppColors.surface : AppColors.primaryLight.withOpacity(0.3),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: notification.isRead ? AppColors.border : AppColors.primary.withOpacity(0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(_getIcon(), color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(notification.title,
                            style: TextStyle(
                              fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w700,
                              fontSize: 14,
                              color: AppColors.textDark,
                            )),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8, height: 8,
                          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(notification.message,
                      style: const TextStyle(fontSize: 13, color: AppColors.textGray, height: 1.4)),
                  const SizedBox(height: 6),
                  Text(_formatTime(notification.createdAt),
                      style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return Formatters.formatDate(date);
  }
}
