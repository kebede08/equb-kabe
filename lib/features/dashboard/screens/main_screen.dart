import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  final Widget child;
  const MainScreen({super.key, required this.child});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home', route: AppRoutes.home),
    _NavItem(icon: Icons.group_outlined, activeIcon: Icons.group, label: 'Groups', route: AppRoutes.groups),
    _NavItem(icon: Icons.payments_outlined, activeIcon: Icons.payments, label: 'Contribute', route: AppRoutes.contributions),
    _NavItem(icon: Icons.account_balance_outlined, activeIcon: Icons.account_balance, label: 'Loans', route: AppRoutes.loans),
    _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile', route: AppRoutes.profile),
  ];

  void _onTap(int index) {
    setState(() => _currentIndex = index);
    context.go(_navItems[index].route);
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    int activeIndex = 0;
    for (int i = 0; i < _navItems.length; i++) {
      if (location.startsWith(_navItems[i].route)) {
        activeIndex = i;
      }
    }

    // Show home dashboard when on /home
    final body = location == AppRoutes.home ? const HomeScreen() : widget.child;

    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: activeIndex,
        onTap: _onTap,
        items: _navItems
            .map((item) => BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  activeIcon: Icon(item.activeIcon),
                  label: item.label,
                ))
            .toList(),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}
