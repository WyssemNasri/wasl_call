import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:linphone_flutter_plugin/call_state.dart';
import 'package:linphone_flutter_plugin/linphoneflutterplugin.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';

class CallViewModel extends ChangeNotifier {
  final LinphoneFlutterPlugin _linphone = LinphoneFlutterPlugin();

  String? _incomingCaller;
  String? get incomingCaller => _incomingCaller;

  bool _hasIncomingCall = false;
  bool get hasIncomingCall => _hasIncomingCall;

  StreamSubscription? _callStateSubscription;

  CallViewModel() {
    _listenIncomingCalls();
  }

  void _listenIncomingCalls() {
    _callStateSubscription =
        _linphone.addCallStateListener().listen(_handleCallState);
  }

  void _handleCallState(CallState callState) {
    final name = callState.name;
    if (name == 'IncomingReceived') {
      final stateStr = callState.toString();
      final regex = RegExp(r'remoteContact:\s*(sip:[^@]+)@');
      final match = regex.firstMatch(stateStr);

      _incomingCaller =
          match?.group(1)?.replaceFirst('sip:', '') ?? "SIP User";

      _hasIncomingCall = true;
      notifyListeners();
      _showNativeIncomingCall(_incomingCaller!);
    }

    if (name == 'End' || name == 'Released') {
      _hasIncomingCall = false;
      _incomingCaller = null;
      notifyListeners();
      FlutterCallkitIncoming.endAllCalls();
    }
  }

  Future<void> acceptCall() async {
    try {
      await _linphone.answercall();
      _hasIncomingCall = false;
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error accepting call: $e");
    }
  }

  Future<void> declineCall() async {
    try {
      await _linphone.rejectCall();
      _hasIncomingCall = false;
      _incomingCaller = null;
      notifyListeners();
      await FlutterCallkitIncoming.endAllCalls();
    } catch (e) {
      debugPrint("❌ Error declining call: $e");
    }
  }

  Future<void> endCall() async {
    try {
      await _linphone.hangUp();
      _hasIncomingCall = false;
      _incomingCaller = null;
      notifyListeners();
      await FlutterCallkitIncoming.endAllCalls();
    } catch (e) {
      debugPrint("❌ Error ending call: $e");
    }
  }

  Future<void> _showNativeIncomingCall(String callerName) async {
    final uuid = const Uuid().v4();

    final params = CallKitParams(
      id: uuid,
      nameCaller: callerName,
      appName: 'Wasl Call',
      avatar:
      'https://cdn-icons-png.flaticon.com/512/15/15874.png', // optional
      handle: callerName,
      type: 0, // 0 = audio, 1 = video
      duration: 30000,
      textAccept: 'Accepter',
      textDecline: 'Rejeter',
      android: AndroidParams(
        isCustomNotification: true,
        isShowLogo: true,
        isShowCallID: true,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0955fa',
        backgroundUrl:
        'https://wallpapercave.com/wp/wp10200191.jpg', // optional background
        actionColor: '#4CAF50',
      ),
    );

    try {
      await FlutterCallkitIncoming.showCallkitIncoming(params);
    } catch (e) {
      debugPrint("❌ Error showing native incoming call UI: $e");
    }
  }

  @override
  void dispose() {
    _callStateSubscription?.cancel();
    super.dispose();
  }
}
