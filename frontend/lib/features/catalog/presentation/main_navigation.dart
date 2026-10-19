// Shell utama dengan bottom navigation bar ala Letterboxd.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../auth/presentation/auth_gateway_page.dart';
import '../../profile/presentation/profile_page.dart';
import 'home_page.dart';
import 'search_page.dart';
import '../../log/presentation/log_form_page.dart';
import '../../feed/presentation/feed_page.dart';

/// Layout shell dengan bottom navigation 5 item.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        backgroundColor: const Color(0xFF14181C),
        selectedItemColor: const Color(0xFF00E054),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: Color(0xFF00E054),
              size: 32,
            ),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bolt_outlined),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

/// Navigasi mandiri (non-GoRouter) dengan bottom bar 5 item.
class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  static const AppText text = AppStrings.id;
  static const int _addIndex = 2;

  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
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
