import 'package:flutter/material.dart';
import '../../auth/presentation/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14181C),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Logo 3 Lingkaran
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 60, height: 60, decoration: const BoxDecoration(color: Color(0xFFFF8000), shape: BoxShape.circle)),
                  Transform.translate(
                    offset: const Offset(-15, 0),
                    child: Container(width: 60, height: 60, decoration: const BoxDecoration(color: Color(0xFF00E054), shape: BoxShape.circle)),
                  ),
                  Transform.translate(
                    offset: const Offset(-30, 0),
                    child: Container(width: 60, height: 60, decoration: const BoxDecoration(color: Color(0xFF40BCF4), shape: BoxShape.circle)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Letterboxd',
                style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900),
              ),
              const Spacer(flex: 3),
              
              // Menu Sign In
              Container(height: 1, color: const Color(0xFF2C3440)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        // Pindah ke halaman Login saat diklik
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => const LoginPage())
                        );
                      },
                      child: const Text('Sign in', style: TextStyle(color: Color(0xFFB0C0D0), fontSize: 22)),
                    ),
                    const SizedBox(height: 28),
                    const Text('Create account', style: TextStyle(color: Color(0xFFB0C0D0), fontSize: 22)),
                    const SizedBox(height: 28),
                    const Text('Open tour', style: TextStyle(color: Color(0xFFB0C0D0), fontSize: 22)),
                  ],
                ),
              ),
              Container(height: 1, color: const Color(0xFF2C3440)),
              
              // Artwork
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text('Artwork from Kelompok 6', style: TextStyle(color: Color(0xFF6B7A8D), fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}