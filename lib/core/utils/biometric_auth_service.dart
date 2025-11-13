import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  BiometricAuthService._privateConstructor();
  static final BiometricAuthService instance =
  BiometricAuthService._privateConstructor();
  final LocalAuthentication _auth = LocalAuthentication();
  Future<bool> get isBiometricAvailable async {
    try {
      final bool canCheckBiometrics = await _auth.canCheckBiometrics;
      final bool isDeviceSupported = await _auth.isDeviceSupported();
      return canCheckBiometrics && isDeviceSupported;
    } catch (e) {
      print('Error checking biometric availability: $e');
      return false;
    }
  }

  Future<bool> authenticate({
    String reason = 'Please authenticate to proceed',
    bool useErrorDialogs = true,
    bool stickyAuth = true,
  }) async {
    try {
      final bool available = await isBiometricAvailable;
      if (!available) return false;

      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: reason,
            biometricOnly: true
      );
      return didAuthenticate;
    } catch (e) {
      print('Error during biometric authentication: $e');
      return false;
    }
  }
}
