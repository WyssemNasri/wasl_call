import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:provider/provider.dart';
import 'package:wasl_call/provider/CallViewModel.dart';
import 'package:wasl_call/provider/login_view_model.dart';
import 'package:wasl_call/service/storage_service.dart';
import 'package:wasl_call/views/HomeWrapper.dart';
import 'package:wasl_call/views/IncomingCallScreen.dart';
import 'package:wasl_call/views/login_page.dart';
import 'package:wasl_call/widgets/permission_gate.dart';

class AppRoot extends StatefulWidget {
  final StorageService storageService;
  const AppRoot({super.key, required this.storageService});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  void initState() {
    super.initState();
    _listenToCallEvents();
  }

  void _listenToCallEvents() {
    FlutterCallkitIncoming.onEvent.listen((event) {
      if (event == null) return;

      final callVM = Provider.of<CallViewModel>(context, listen: false);

      switch (event.event) {
        case "callAccept":
          callVM.acceptCall();
          break;
        case "callDecline":
          callVM.declineCall();
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);

    return MaterialApp(
      title: 'Wasel Call',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      routes: {
        '/login': (context) => LoginPage(
          onLogin: (username) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => HomeWrapper(
                  username: username,
                  storageService: widget.storageService,
                ),
              ),
            );
          },
        ),
      },
      home: Stack(
        children: [
          PermissionGate(
            child: FutureBuilder<String?>(
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
                    storageService: widget.storageService,
                  );
                }
                return LoginPage(
                  onLogin: (username) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => HomeWrapper(
                          username: username,
                          storageService: widget.storageService,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          /// Affichage conditionnel de l'écran d'appel entrant
          Consumer<CallViewModel>(
            builder: (context, callVM, _) {
              return callVM.hasIncomingCall
                  ? const IncomingCallScreen()
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
