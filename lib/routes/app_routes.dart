import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/auth/screens/onboarding_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/otp_screen.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/auth/screens/reset_password_screen.dart';
import '../features/dashboard/screens/main_screen.dart';
import '../features/groups/screens/group_list_screen.dart';
import '../features/groups/screens/group_detail_screen.dart';
import '../features/groups/screens/create_group_screen.dart';
import '../features/groups/screens/join_group_screen.dart';
import '../features/contributions/screens/contribution_list_screen.dart';
import '../features/contributions/screens/make_payment_screen.dart';
import '../features/loans/screens/loan_dashboard_screen.dart';
import '../features/loans/screens/request_loan_screen.dart';
import '../features/loans/screens/loan_detail_screen.dart';
import '../features/notifications/screens/notifications_screen.dart';
import '../features/reports/screens/reports_screen.dart';
import '../features/education/screens/education_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/profile/screens/settings_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';
  static const String groups = '/groups';
  static const String groupDetail = '/groups/:id';
  static const String createGroup = '/groups/create';
  static const String joinGroup = '/groups/join';
  static const String contributions = '/contributions';
  static const String makePayment = '/contributions/pay/:id';
  static const String loans = '/loans';
  static const String requestLoan = '/loans/request';
  static const String loanDetail = '/loans/:id';
  static const String notifications = '/notifications';
  static const String reports = '/reports';
  static const String education = '/education';
  static const String profile = '/profile';
  static const String settings = '/settings';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: otp,
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return OtpScreen(phoneNumber: phone);
        },
      ),
      GoRoute(
        path: forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: resetPassword,
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return ResetPasswordScreen(phoneNumber: phone);
        },
      ),
      ShellRoute(
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          GoRoute(
            path: home,
            builder: (context, state) => const SizedBox.shrink(),
          ),
          GoRoute(
            path: groups,
            builder: (context, state) => const GroupListScreen(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const CreateGroupScreen(),
              ),
              GoRoute(
                path: 'join',
                builder: (context, state) => const JoinGroupScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return GroupDetailScreen(groupId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: contributions,
            builder: (context, state) => const ContributionListScreen(),
            routes: [
              GoRoute(
                path: 'pay/:id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return MakePaymentScreen(contributionId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: loans,
            builder: (context, state) => const LoanDashboardScreen(),
            routes: [
              GoRoute(
                path: 'request',
                builder: (context, state) => const RequestLoanScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return LoanDetailScreen(loanId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: notifications,
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: reports,
            builder: (context, state) => const ReportsScreen(),
          ),
          GoRoute(
            path: education,
            builder: (context, state) => const EducationScreen(),
          ),
          GoRoute(
            path: profile,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: settings,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
}
