import 'package:flutter/material.dart';

import 'biotmetric_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BiometricAuth biometricAuth = BiometricAuth();
  String _statusMessage = '';

  void _handleBiometricLogin(BuildContext context) async {
    setState(() {
      _statusMessage = 'Checking biometrics...';
    });

    final result = await biometricAuth.authenticateUser(
      reason: 'Authenticate to log in',
    );

    setState(() {
      if (result['success']) {
        _statusMessage = '✅ Authentication successful';
      } else {
        debugPrint('Authentication failed: ${result['error']}');
        _statusMessage = '❌ ${result['error']}';
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_statusMessage),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _handleBiometricLogin(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Biometric Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _handleBiometricLogin(context),
              child: Text('Login with Fingerprint'),
            ),
            SizedBox(height: 20),
            Text(
              _statusMessage,
              style: TextStyle(
                color: _statusMessage.contains('❌') ? Colors.red : Colors.green,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
