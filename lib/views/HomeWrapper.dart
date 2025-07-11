import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasl_call/service/storage_service.dart';

import '../provider/DialerViewModel.dart';
import '../widgets/dial_button.dart';
import 'ringing_screen.dart';  // <-- Import de la nouvelle page

class HomeWrapper extends StatelessWidget {
  final String username;
  final StorageService storageService;

  const HomeWrapper({
    super.key,
    required this.username,
    required this.storageService,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DialerViewModel(storageService),
      child: _HomeWrapperContent(
        username: username,
        storageService: storageService,
      ),
    );
  }
}

class _HomeWrapperContent extends StatelessWidget {
  final String username;
  final StorageService storageService;

  _HomeWrapperContent({
    super.key,
    required this.username,
    required this.storageService,
  });

  final List<String> _digits = [
    '1', '2', '3',
    '4', '5', '6',
    '7', '8', '9',
    '*', '0', '#',
  ];

  @override
  Widget build(BuildContext context) {
    final dialerVM = Provider.of<DialerViewModel>(context);

    void _showMessage(String msg) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text('Wasel - $username'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await storageService.deleteAll();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: Text(
                dialerVM.enteredNumber.isEmpty ? '' : dialerVM.enteredNumber,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: dialerVM.enteredNumber.isEmpty
                      ? Colors.grey[400]
                      : Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1.0,
              children: _digits
                  .map(
                    (digit) => DialButtonIOS(
                  digit: digit,
                  onPressed: () => dialerVM.appendDigit(digit),
                ),
              )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: dialerVM.deleteLast,
                  icon: Icon(Icons.backspace, size: 28, color: Colors.grey[600]),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final domain = await storageService.read('domain') ?? 'sip.wasel.sa';
                    final fullNumber = '${dialerVM.enteredNumber}@$domain';

                    if (dialerVM.enteredNumber.isEmpty) {
                      _showMessage("Please enter a number first.");
                      return;
                    }

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Confirm Call"),
                        content: Text("Do you want to call:\n$fullNumber"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context); // fermer la popup
                              final error = await dialerVM.makeCall();
                              if (error != null) {
                                _showMessage(error);
                              } else {
                                _showMessage('Call launched successfully');
                                // Naviguer vers RingingScreen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RingingScreen(calleeNumber: fullNumber),
                                  ),
                                );
                              }
                            },
                            child: const Text("Call"),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.all(20),
                    elevation: 6,
                    shadowColor: const Color(0xFF4CAF50).withOpacity(0.4),
                  ),
                  child: const Icon(Icons.call, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
