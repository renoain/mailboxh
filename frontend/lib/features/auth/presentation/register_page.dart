import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_state.dart';
import '../../catalog/presentation/main_navigation.dart';
import 'login_page.dart'; 

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14181C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF14181C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Account',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                
                // 1. Input Username
                TextField(
                  controller: _usernameController,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: const InputDecoration(
                    hintText: 'Username (e.g. budi123)',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2C3440))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E054))),
                  ),
                ),
                const SizedBox(height: 24),

                // 2. Input Email
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: const InputDecoration(
                    hintText: 'Email Address',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2C3440))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E054))),
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Input Password
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2C3440))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E054))),
                  ),
                ),
                const SizedBox(height: 40),
                
                // Tombol Daftar
                ElevatedButton(
                  onPressed: () {
                    if (_usernameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Semua kolom harus diisi!'), backgroundColor: Colors.redAccent),
                      );
                      return;
                    }

                    final appState = Provider.of<AppState>(context, listen: false);
                    
                    // PERBAIKAN: Hanya mengirim 2 data (Username dan Email)
                    appState.updateProfile(
                      _usernameController.text.trim(), 
                      _emailController.text.trim()
                    );
                    appState.login();

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainNavigation(initialIndex: 1)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E054),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Text(
                    'CREATE ACCOUNT', 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                  ),
                ),
                
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(builder: (context) => const LoginPage())
                      );
                    },
                    child: const Text(
                      'Already have an account? Sign in', 
                      style: TextStyle(color: Color(0xFF00E054))
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}