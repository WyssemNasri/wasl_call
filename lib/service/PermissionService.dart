import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Liste des permissions à demander (sans caméra et sans stockage)
  final List<Permission> _permissions = [
    Permission.microphone,
    Permission.phone,
    Permission.bluetooth,
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.notification,
  ];

  /// Demande toutes les permissions et retourne la liste de celles refusées
  Future<List<Permission>> checkAndRequestPermissions() async {
    final statuses = await _permissions.request();

    final denied = statuses.entries
        .where((entry) => !entry.value.isGranted)
        .map((entry) => entry.key)
        .toList();

    return denied;
  }

  /// Retourne true si toutes les permissions sont accordées
  Future<bool> hasAllPermissions() async {
    for (final permission in _permissions) {
      if (!await permission.isGranted) return false;
    }
    return true;
  }

  /// Vérifie s'il y a des permissions définitivement refusées
  Future<bool> hasPermanentlyDenied(List<Permission> permissions) async {
    for (final permission in permissions) {
      if (await permission.status.isPermanentlyDenied) return true;
    }
    return false;
  }
}
