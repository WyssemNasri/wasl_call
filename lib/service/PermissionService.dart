import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Liste complète des permissions à demander
  final List<Permission> _permissions = [
    Permission.microphone,
    Permission.camera,
    Permission.phone,
    Permission.bluetooth,
    Permission.bluetoothScan,    // Android 12+
    Permission.bluetoothConnect, // Android 12+
    Permission.storage,
    Permission.notification,    // Android 13+
  ];

  /// Demande toutes les permissions et retourne true si toutes sont accordées
  Future<bool> checkAndRequestPermissions() async {
    final statuses = await _permissions.request();

    final allGranted = statuses.entries.every((entry) => entry.value.isGranted);
    return allGranted;
  }

  /// Vérifie si toutes les permissions sont déjà accordées
  Future<bool> hasPermissions() async {
    for (var permission in _permissions) {
      if (!await permission.isGranted) return false;
    }
    return true;
  }
}
