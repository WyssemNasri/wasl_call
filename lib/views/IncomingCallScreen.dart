import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasl_call/provider/CallViewModel.dart';

class IncomingCallScreen extends StatelessWidget {
  const IncomingCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final callVM = Provider.of<CallViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.phone_in_talk,
                size: 90,
                color: Colors.greenAccent,
              ),
              const SizedBox(height: 20),
              Text(
                "Appel entrant de",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                callVM.incomingCaller ?? 'Inconnu',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    heroTag: 'decline',
                    backgroundColor: Colors.red,
                    onPressed: () {
                      callVM.declineCall();
                      Navigator.of(context).pop(); // Ferme l'écran si visible
                    },
                    child: const Icon(Icons.call_end),
                  ),
                  const SizedBox(width: 50),
                  FloatingActionButton(
                    heroTag: 'accept',
                    backgroundColor: Colors.green,
                    onPressed: () {
                      callVM.acceptCall();
                      Navigator.of(context).pop(); // Ferme l'écran si visible
                    },
                    child: const Icon(Icons.call),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
