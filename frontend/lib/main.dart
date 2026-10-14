// Titik masuk aplikasi Mailboxh.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MailboxhApp()));
}

/// Akar aplikasi.
class MailboxhApp extends StatefulWidget {
  const MailboxhApp({super.key});

  @override
  State<MailboxhApp> createState() => _MailboxhAppState();
}

class _MailboxhAppState extends State<MailboxhApp> {
  late final _router = buildRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mailboxh',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}