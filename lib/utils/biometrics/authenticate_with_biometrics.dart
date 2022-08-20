import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

Future<bool> authenticateWithBiometrics() async {
  final LocalAuthentication auth = LocalAuthentication();
  final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
  final bool canAuthenticate =
      canAuthenticateWithBiometrics || await auth.isDeviceSupported();

  if (!canAuthenticate) return false;

  try {
    final bool didAuthenticate = await auth.authenticate(
      localizedReason: 'Please authenticate to confirm ticket purchase',
      options: const AuthenticationOptions(
        biometricOnly: true,
      ),
    );

    return didAuthenticate;
    // ···
  } on PlatformException {
    return false;
  }
}
