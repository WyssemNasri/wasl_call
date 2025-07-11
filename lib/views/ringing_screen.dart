import 'package:flutter/material.dart';

class RingingScreen extends StatelessWidget {
  final String calleeNumber;

  const RingingScreen({super.key, required this.calleeNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appel en cours...'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Appel vers:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              calleeNumber,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: () {
                // Logique pour raccrocher ici, exemple:
                Navigator.pop(context); // revenir à l'écran précédent
                // Ici tu peux appeler dialerVM.hangUp() si tu as cette méthode
              },
              icon: const Icon(Icons.call_end),
              label: const Text('Raccrocher'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
