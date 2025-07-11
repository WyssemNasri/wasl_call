import 'package:flutter/material.dart';

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
    bool granted = await _permissionService.checkAndRequestPermissions();

    if (!granted && mounted) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Permissions requises"),
          content: const Text(
              "L'application a besoin d'accéder au micro, caméra, téléphone, Bluetooth et notifications."),
          actions: [
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
