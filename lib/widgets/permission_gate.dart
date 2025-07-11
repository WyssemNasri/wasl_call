import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../service/PermissionService.dart';

class PermissionGate extends StatefulWidget {
  final Widget child;
  const PermissionGate({super.key, required this.child});

  @override
  State<PermissionGate> createState() => _PermissionGateState();
}

class _PermissionGateState extends State<PermissionGate> {
  bool _ready = false;
  final PermissionService _permissionService = PermissionService();

  @override
  void initState() {
    super.initState();
    _initPermissions();
  }

  Future<void> _initPermissions() async {
    final denied = await _permissionService.checkAndRequestPermissions();

    if (denied.isNotEmpty && mounted) {
      final permanentlyDenied = await _permissionService.hasPermanentlyDenied(denied);

      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Permissions requises"),
          content: Text(
            permanentlyDenied
                ? "Les permissions suivantes sont bloquées définitivement. Veuillez les autoriser dans les paramètres :\n\n" +
                denied.map((p) => "- ${_permissionName(p)}").join("\n")
                : "Les permissions suivantes n'ont pas été accordées :\n\n" +
                denied.map((p) => "- ${_permissionName(p)}").join("\n"),
          ),
          actions: [
            if (permanentlyDenied)
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await openAppSettings();
                },
                child: const Text("Ouvrir les paramètres"),
              )
            else
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _initPermissions();
                },
                child: const Text("Réessayer"),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Ignorer"),
            ),
          ],
        ),
      );
    }

    if (mounted) {
      setState(() {
        _ready = true;
      });
    }
  }

  String _permissionName(Permission p) {
    switch (p) {
      case Permission.microphone:
        return "Microphone";
      case Permission.phone:
        return "Téléphone";
      case Permission.bluetooth:
      case Permission.bluetoothConnect:
      case Permission.bluetoothScan:
        return "Bluetooth";
      case Permission.notification:
        return "Notifications";
      default:
        return p.toString().split('.').last;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        body: Center(child: Text('Chargement des permissions...')),
      );
    }
    return widget.child;
  }
}
