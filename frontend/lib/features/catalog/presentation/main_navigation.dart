// Navigasi utama dengan bottom bar untuk mode tamu dan user login.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/providers/app_state.dart';
import '../../auth/presentation/auth_gateway_page.dart';
import '../../auth/presentation/auth_provider.dart';
import 'home_page.dart';
import 'search_page.dart';
import '../../profile/presentation/profile_page.dart';
import '../../auth/presentation/login_page.dart';

class MainNavigation extends ConsumerStatefulWidget {
  final int initialIndex;

  const MainNavigation({super.key, this.initialIndex = 1});

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final bool isGuest = ref.watch(authProvider).value == null;
    final List<Widget> pages = [
      isGuest ? const AuthGatewayPage() : const ProfilePage(),
      const HomePage(),
      const SearchPage(),
    ];

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF14181C),
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF2C3440),
          selectedItemColor: const Color(0xFF40BCF4),
          unselectedItemColor: const Color(0xFF8A9BAE),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 28),
              activeIcon: Icon(Icons.person, size: 28),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_library_outlined, size: 28),
              activeIcon: Icon(Icons.video_library, size: 28),
              label: 'Films',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 28),
              label: 'Search',
            ),
          ],
        ),
      ),
    );
  }
}