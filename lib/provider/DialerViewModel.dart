import 'package:flutter/foundation.dart';
import 'package:linphone_flutter_plugin/linphoneflutterplugin.dart';
import '../service/storage_service.dart';

class DialerViewModel extends ChangeNotifier {
  final LinphoneFlutterPlugin _linphone = LinphoneFlutterPlugin();
  final StorageService _storageService;

  DialerViewModel(this._storageService);

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

    try {
      debugPrint('Calling number: $_enteredNumber');
      // NE PAS concaténer domain ni port, juste le numéro
      await _linphone.call(number: _enteredNumber);
      return null;
    } catch (e) {
      return 'Call failed: $e';
    }
  }





  void clearNumber() {
    _enteredNumber = '';
    notifyListeners();
  }
}
