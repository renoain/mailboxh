import 'package:flutter/material.dart';
import 'home_page.dart'; 
import 'search_page.dart'; 
import '../../profile/presentation/profile_page.dart'; 

class MainNavigation extends StatefulWidget {
  final int initialIndex; 

  const MainNavigation({super.key, this.initialIndex = 1});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; 
  }

  final List<Widget> _pages = [
    const ProfilePage(),  
    const HomePage(),     
    const SearchPage(),   
  ];

  @override
  Widget build(BuildContext context) {
    // PopScope mencegah user menekan tombol back dan kembali ke Login
    return PopScope(
      canPop: false, // Tidak bisa di-pop (back) secara default
      child: Scaffold(
        backgroundColor: const Color(0xFF14181C),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF2C3440),
          selectedItemColor: const Color(0xFF40BCF4), 
          unselectedItemColor: const Color(0xFF8A9BAE), 
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          onTap: (index) {
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