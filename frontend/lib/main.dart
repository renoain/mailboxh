import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_strings.dart';
import 'core/providers/app_state.dart';
import 'features/splash/presentation/splash_page.dart';

void main() {
  runApp(
    ProviderScope(
      child: ChangeNotifierProvider(
        create: (context) => AppState(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
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
      ),
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return Container(
                color: Colors.black,
                child: Center(
                  child: SizedBox(width: 500, child: child),
                ),
              );
            }
            return child!;
          },
        );
      },
      // KUNCI HALAMAN PERTAMA ADALAH SPLASH
      home: const SplashPage(),
    );
  }
}