import 'package:flutter/material.dart';

class CallProvider extends ChangeNotifier {
  String? _callerName;
  bool _isIncomingCall = false;

  String? get callerName => _callerName;
  bool get isIncomingCall => _isIncomingCall;

  // Simuler un appel entrant
  void incomingCall(String caller) {
    _callerName = caller;
    _isIncomingCall = true;
    notifyListeners();
  }

  // Accepter l'appel
  void acceptCall() {
    _isIncomingCall = false;
    // Ajoute ici la logique pour accepter l'appel via Linphone ou autre
    notifyListeners();
  }

  // Refuser l'appel
  void declineCall() {
    _isIncomingCall = false;
    // Ajoute ici la logique pour rejeter l'appel
    notifyListeners();
  }
}
