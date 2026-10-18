import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../auth/presentation/login_page.dart';
import '../../auth/presentation/register_page.dart'; // IMPORT HALAMAN REGISTER
import '../../catalog/presentation/main_navigation.dart'; 

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const AppText text = AppStrings.id;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final logoSize = screenWidth < 400 ? 50.0 : 65.0;
    final titleFontSize = screenWidth < 400 ? 36.0 : 45.0;
    final menuFontSize = screenWidth < 400 ? 18.0 : 22.0;

    return Scaffold(
      backgroundColor: const Color(0xFF14181C),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                const Spacer(flex: 2),
                // --- LOGO 3 LINGKARAN ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: logoSize, height: logoSize,
                      decoration: const BoxDecoration(color: Color(0xFFFF8000), shape: BoxShape.circle),
                    ),
                    Transform.translate(
                      offset: Offset(-logoSize * 0.23, 0),
                      child: Container(
                        width: logoSize, height: logoSize,
                        decoration: const BoxDecoration(color: Color(0xFF00E054), shape: BoxShape.circle),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(-logoSize * 0.46, 0),
                      child: Container(
                        width: logoSize, height: logoSize,
                        decoration: const BoxDecoration(color: Color(0xFF40BCF4), shape: BoxShape.circle),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenWidth < 400 ? 10 : 16),
                
                // --- TEKS NAMA APLIKASI ---
                Text(
                  text.appName,
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: titleFontSize, 
                    fontWeight: FontWeight.w900, 
                    letterSpacing: -1.5
                  ),
                ),
                const Spacer(flex: 3),
                
                // --- MENU LIST (Hanya Sign In & Create Account) ---
                Container(height: 1, color: const Color(0xFF2C3440)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Menu Sign In
                      _buildMenuItem('Sign in', menuFontSize, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                      }),
                      const SizedBox(height: 24),
                      
                      // 2. Menu Create Account (Sudah berfungsi)
                      _buildMenuItem('Create account', menuFontSize, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                      }),
                    ],
                  ),
                ),
                Container(height: 1, color: const Color(0xFF2C3440)),
                
                // --- ARTWORK ---
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Color(0xFF6B7A8D), fontSize: 14),
                      children: [
                        TextSpan(text: 'Artwork from '),
                        TextSpan(text: 'Kelompok 6', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8A9BAE))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      
      // --- BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF2C3440),
        selectedItemColor: const Color(0xFF40BCF4), // Biru terang
        unselectedItemColor: const Color(0xFF8A9BAE), // Abu-abu
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: 0, 
        onTap: (index) {
          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
          } else if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MainNavigation(initialIndex: 1)));
          } else if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MainNavigation(initialIndex: 2)));
          }
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
    );
  }

  Widget _buildMenuItem(String title, double fontSize, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(
        title,
        style: TextStyle(color: const Color(0xFFB0C0D0), fontSize: fontSize, fontWeight: FontWeight.w400),
      ),
    );
  }
}