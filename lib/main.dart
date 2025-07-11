import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasl_call/provider/CallViewModel.dart';
import 'package:wasl_call/provider/DialerViewModel.dart';
import 'package:wasl_call/provider/login_view_model.dart';
import 'package:wasl_call/service/storage_service.dart';
import 'package:wasl_call/views/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storageService = StorageService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel(storageService)),
        ChangeNotifierProvider(create: (_) => DialerViewModel(storageService)),
        ChangeNotifierProvider(create: (_) => CallViewModel()),
      ],
      child: AppRoot(storageService: storageService),
    ),
  );
}
