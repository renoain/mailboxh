// Halaman pengaturan user.

import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const AppText text = AppStrings.id;

  bool _isDarkMode = true;
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14181C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF14181C),
        title: Text(text.settingsTitle, style: const TextStyle(color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(text.darkMode, style: const TextStyle(color: Colors.white)),
            subtitle: Text(text.darkModeHint, style: const TextStyle(color: Colors.grey)),
            activeThumbColor: const Color(0xFF00E054),
            value: _isDarkMode,
            onChanged: (val) => setState(() => _isDarkMode = val),
          ),
          SwitchListTile(
            title: Text(text.pushNotifications, style: const TextStyle(color: Colors.white)),
            subtitle: Text(text.pushNotificationsHint, style: const TextStyle(color: Colors.grey)),
            activeThumbColor: const Color(0xFF00E054),
            value: _pushNotifications,
            onChanged: (val) => setState(() => _pushNotifications = val),
          ),
          const Divider(color: Color(0xFF2C3440)),
          ListTile(
            title: Text(text.privacyPolicy, style: const TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
          ListTile(
            title: Text(text.settingsAbout, style: const TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
