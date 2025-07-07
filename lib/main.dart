import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasl_call/service/storage_service.dart';
import 'package:wasl_call/views/HomeWrapper.dart';
import 'package:wasl_call/views/login_page.dart';
import 'package:wasl_call/provider/login_view_model.dart';

void main() {
  final storageService = StorageService();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(storageService),
        ),
        // tu peux ajouter d'autres providers ici si besoin
      ],
      child: MyApp(storageService: storageService),
    ),
  );
}

class MyApp extends StatelessWidget {
  final StorageService storageService;

  const MyApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);

    return MaterialApp(
      title: 'Wasel Call',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        '/login': (context) => LoginPage(
          onLogin: (username) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => HomeWrapper(
                  username: username,
                  storageService: storageService,
                ),
              ),
            );
          },
        ),
        // si tu as d'autres routes, ajoute ici
      },
      home: FutureBuilder<String?>(
        future: loginVM.storageService.read('username'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            return HomeWrapper(
              username: snapshot.data!,
              storageService: storageService,
            );
          }
          return LoginPage(
            onLogin: (username) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => HomeWrapper(
                    username: username,
                    storageService: storageService,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
