import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../feed/presentation/feed_page.dart';
import '../../log/presentation/log_form_page.dart';
import '../../profile/presentation/profile_page.dart';
import 'home_page.dart';
import 'search_page.dart';

/// Kerangka utama dengan bottom nav lima item; item tengah membuka form catat.
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  static const AppText text = AppStrings.id;
  static const int _addIndex = 2;

  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  static const List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    SizedBox.shrink(),
    FeedPage(),
    ProfilePage(),
  ];

  void _onTap(int index) {
    if (index == _addIndex) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LogFormPage()),
      );
      return;
    }
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          onTap: _onTap,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.video_library_outlined),
              activeIcon: const Icon(Icons.video_library),
              label: text.navFilms,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.search),
              label: text.navSearch,
            ),
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.add_circle_outline,
                size: AppSizes.navAddIcon,
                color: AppColors.brandGreen,
              ),
              label: text.navAdd,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.bolt),
              label: text.navActivity,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: text.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}
