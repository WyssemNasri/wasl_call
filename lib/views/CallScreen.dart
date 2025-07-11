import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/CallViewModel.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final callVM = Provider.of<CallViewModel>(context);

    return WillPopScope(
      onWillPop: () async {
        // Empêche de revenir en arrière sans raccrocher
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Appel en cours'),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false, // Pas de bouton retour
          actions: [
            IconButton(
              icon: const Icon(Icons.call_end),
              color: Colors.red,
              onPressed: () {
                callVM.endCall();
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône fixe à la place de avatarUrl
              const Icon(
                Icons.phone_in_talk,
                size: 120,
                color: Colors.white70,
              ),
              const SizedBox(height: 20),
              Text(
                callVM.incomingCaller ?? 'Inconnu',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Appel connecté',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 50),
              // Boutons supplémentaires (mute, haut-parleur)


            ],
          ),
        ),
      ),
    );
  }
}

class _CallControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _CallControlButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: Colors.grey[800],
            padding: const EdgeInsets.all(16),
          ),
          onPressed: onPressed,
          child: Icon(icon, size: 32, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white70),
        )
      ],
    );
  }
}
