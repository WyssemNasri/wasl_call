import 'package:flutter/foundation.dart';
import 'package:linphone_flutter_plugin/linphoneflutterplugin.dart';

class DialerViewModel extends ChangeNotifier {
  final LinphoneFlutterPlugin _linphone = LinphoneFlutterPlugin();

  String _enteredNumber = '';
  String get enteredNumber => _enteredNumber;

  static const int maxLength = 15;

  void appendDigit(String digit) {
    if (_enteredNumber.length < maxLength) {
      _enteredNumber += digit;
      notifyListeners();
    }
  }

  void deleteLast() {
    if (_enteredNumber.isNotEmpty) {
      _enteredNumber = _enteredNumber.substring(0, _enteredNumber.length - 1);
      notifyListeners();
    }
  }

  Future<String?> makeCall() async {
    if (_enteredNumber.isEmpty) {
      return 'Please enter a number';
    }
    final fullNumber = '$_enteredNumber@sip.wasel.sa';

    try {
      _linphone.call(number: fullNumber);
      return null; // succès, pas de message d'erreur
    } catch (e) {
      return 'Call failed: $e';
    }
  }

  void clearNumber() {
    _enteredNumber = '';
    notifyListeners();
  }
}
