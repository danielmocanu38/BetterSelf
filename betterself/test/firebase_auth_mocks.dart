import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

typedef Callback = void Function(MethodCall call);

final List<MethodCall> methodCallLog = <MethodCall>[];

void setupFirebaseAuthMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  setupFirebaseCoreMocks();

  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/firebase_auth');

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    methodCallLog.add(methodCall);
    if (customHandlers != null) {
      customHandlers(methodCall);
    }
    switch (methodCall.method) {
      case 'Auth#registerIdTokenListener':
      case 'Auth#registerAuthStateListener':
        return null;
      default:
        return null;
    }
  });
}
