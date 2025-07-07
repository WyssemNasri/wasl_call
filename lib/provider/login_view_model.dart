import 'dart:async';
import 'package:flutter/material.dart';
import 'package:linphone_flutter_plugin/linphoneflutterplugin.dart';
import 'package:wasl_call/service/storage_service.dart';

class LoginViewModel extends ChangeNotifier {
  final StorageService storageService;
  final LinphoneFlutterPlugin _linphone =
      LinphoneFlutterPlugin(); // ✅ Correction

  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String? _error;
  bool _obscurePassword = true;

  LoginViewModel(this.storageService);

  // Getters
  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get obscurePassword => _obscurePassword;

  // Setters
  set email(String value) {
    _email = value;
    notifyListeners();
  }

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<void> login({
    required String email,
    required String password,
    required Function(String) onSuccess,
  }) async {
    _email = email;
    _password = password;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _linphone.login(
        userName: _email,
        domain: "sip.wasel.sa:5060",
        password: _password,
      );

      late final StreamSubscription subscription;
      subscription = _linphone.addLoginListener().listen((status) async {
        if (status.name == 'ok') {
          await storageService.write('username', _email);
          await storageService.write('password', _password);
          await storageService.write('domain', "sip.wasel.sa:5060");
          subscription.cancel();
          onSuccess(_email);
        } else if (status.name == 'error') {
          _error = "Login failed: Wrong credentials or server error.";
          subscription.cancel();
          _isLoading = false;
          notifyListeners();
        }
      });
    } catch (e) {
      _error = "Login failed: ${e.toString()}";
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> tryAutoLogin(Function(String) onLoginSuccess) async {
    final storedEmail = await storageService.read('username');
    final storedPassword = await storageService.read('password');

    if (storedEmail != null && storedPassword != null) {
      _email = storedEmail;
      _password = storedPassword;
      notifyListeners();

      await login(
        email: storedEmail,
        password: storedPassword,
        onSuccess: onLoginSuccess,
      );
    }
  }
}
