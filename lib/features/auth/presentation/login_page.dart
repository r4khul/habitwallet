import 'package:flutter/material.dart';

/// Auth Feature Presentation: User login screen.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Center(child: Text('Auth Feature')),
    );
  }
}
