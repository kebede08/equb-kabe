import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      title: 'Welcome to Equb',
      subtitle: 'The modern way to manage your traditional Ethiopian savings group',
      emoji: '🤝',
      color: AppColors.primary,
    ),
    _OnboardingPage(
      title: 'Track Contributions',
      subtitle: 'Never miss a payment. Get reminders and track every contribution in real-time',
      emoji: '💰',
      color: AppColors.secondary,
    ),
    _OnboardingPage(
      title: 'Manage Loans',
      subtitle: 'Request and manage loans within your group with full transparency',
      emoji: '📊',
      color: Color(0xFF7C3AED),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.login),
                  child: const Text('Skip'),
                ),
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: page.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              page.emoji,
                              style: const TextStyle(fontSize: 72),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          page.title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.subtitle,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textGray,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.primary
                        : AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  if (_currentPage == _pages.length - 1) ...[
                    AppButton(
                      label: 'Get Started',
                      onPressed: () => context.go(AppRoutes.register),
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      label: 'I already have an account',
                      variant: ButtonVariant.outline,
                      onPressed: () => context.go(AppRoutes.login),
                    ),
                  ] else
                    AppButton(
                      label: 'Next',
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final String title;
  final String subtitle;
  final String emoji;
  final Color color;

  _OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
  });
}
