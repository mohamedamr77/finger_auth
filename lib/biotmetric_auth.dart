import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricAuth {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Check if device supports biometric authentication
  Future<bool> isBiometricSupported() async {
    return await _auth.isDeviceSupported();
  }

  /// Check if there are any enrolled biometrics
  Future<bool> hasEnrolledBiometrics() async {
    return await _auth.canCheckBiometrics;
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print('Error getting available biometrics: ${e.message}');
      return [];
    }
  }

  /// Authenticate with biometrics
  Future<Map<String, dynamic>> authenticateUser({
    String reason = 'Please authenticate to continue',
  }) async {
    try {
      final isAvailable = await isBiometricSupported();
      if (!isAvailable) {
        return {
          'success': false,
          'error': 'Biometric authentication is not available on this device',
        };
      }

      final hasBiometrics = await hasEnrolledBiometrics();
      if (!hasBiometrics) {
        return {
          'success': false,
          'error': 'No biometrics enrolled on this device',
        };
      }

      final availableBiometrics = await getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        return {'success': false, 'error': 'No biometrics available'};
      }

      final didAuthenticate = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      return {
        'success': didAuthenticate,
        'error': didAuthenticate ? null : 'Authentication failed',
      };
    } on PlatformException catch (e) {
      return {'success': false, 'error': 'Platform error: ${e.message}'};
    } catch (e) {
      return {'success': false, 'error': 'Unexpected error: $e'};
    }
  }
}
