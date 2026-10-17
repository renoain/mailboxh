import 'package:flutter/material.dart';
import 'features/splash/presentation/splash_page.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Letterboxd Clone',
      debugShowCheckedModeBanner: false,
           theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF14181C),
        primaryColor: const Color(0xFF00E054),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E054),
          secondary: Color(0xFF40BCF4),
          surface: Color(0xFF2C3440),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF14181C),
          elevation: 0,
        ),
      ),
      // RESPONSIVE BUILDER (Laptop vs HP)
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            // Jika layar lebar (Laptop/PC), batasi lebarnya jadi 500
            if (constraints.maxWidth > 600) {
              return Container(
                color: Colors.black, // Background luar
                child: Center(
                  child: SizedBox(
                    width: 500, // Lebar aplikasi di laptop
                    child: child,
                  ),
                ),
              );
            }
            // Jika layar HP, tampilkan full screen
            return child!;
          },
        );
      },
      home: const SplashPage(),
    );
  }
}