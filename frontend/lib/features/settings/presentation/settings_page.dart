import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = true;
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14181C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF14181C),
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Use dark theme', style: TextStyle(color: Colors.grey)),
            activeColor: const Color(0xFF00E054),
            value: _isDarkMode,
            onChanged: (val) => setState(() => _isDarkMode = val),
          ),
          SwitchListTile(
            title: const Text('Push Notifications', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Receive activity alerts', style: TextStyle(color: Colors.grey)),
            activeColor: const Color(0xFF00E054),
            value: _pushNotifications,
            onChanged: (val) => setState(() => _pushNotifications = val),
          ),
          const Divider(color: Color(0xFF2C3440)),
          ListTile(
            title: const Text('Privacy Policy', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
          ListTile(
            title: const Text('About Letterboxd Clone', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}