import 'package:flutter/material.dart';
import 'package:stashlink/services/auth_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: user == null
          ? ListTile(
              title: const Text('Sign in with Google'),
              trailing: const Icon(Icons.login),
              onTap: () async {
                await _authService.logIn();
                setState(() {});
              },
            )
          : ListTile(
              title: Text(user.email ?? 'No email'),
              subtitle: const Text('Tap to sign out'),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                await _authService.signOut();
                setState(() {});
              },
            ),
    );
  }
}
