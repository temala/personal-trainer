import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/presentation/themes/app_colors.dart';
import '../../../../shared/presentation/widgets/cartoon_bottom_nav.dart';
import '../../../../shared/presentation/widgets/cartoon_app_bar.dart';
import '../../../progress/presentation/screens/progress_screen.dart';
import '../../../profile/presentation/screens/settings_screen.dart';
import 'home_screen.dart';

/// Main navigation screen with bottom navigation
class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  static const routeName = '/main';

  @override
  ConsumerState<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const WorkoutScreen(),
    const ProgressScreen(),
    const SettingsScreen(),
  ];

  final List<CartoonBottomNavItem> _navItems = [
    const CartoonBottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    const CartoonBottomNavItem(
      icon: Icons.fitness_center_outlined,
      activeIcon: Icons.fitness_center_rounded,
      label: 'Workout',
    ),
    const CartoonBottomNavItem(
      icon: Icons.trending_up_outlined,
      activeIcon: Icons.trending_up_rounded,
      label: 'Progress',
    ),
    const CartoonBottomNavItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings_rounded,
      label: 'Settings',
    ),
  ];

  final List<String> _appBarTitles = [
    'FitTrainer AI',
    'Workouts',
    'Progress',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CartoonAppBar(
        title: _appBarTitles[_currentIndex],
        showBackButton: false,
        actions:
            _currentIndex == 0
                ? [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      // TODO: Navigate to notifications
                    },
                  ),
                ]
                : null,
      ),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: CartoonBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _navItems,
      ),
      floatingActionButton:
          _currentIndex == 1
              ? FloatingActionButton(
                onPressed: () {
                  // TODO: Start quick workout
                },
                backgroundColor: AppColors.primary,
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: AppColors.white,
                ),
              )
              : null,
    );
  }
}

/// Placeholder workout screen
class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.background, AppColors.surfaceTint],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center_rounded,
              size: 80,
              color: AppColors.primary,
            ),
            SizedBox(height: 16),
            Text(
              'Workout Screen',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Coming soon!',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
