import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

typedef Callback = void Function(MethodCall call);

final List<MethodCall> methodCallLog = <MethodCall>[];

void setupFirebaseMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  setupFirebaseCoreMocks();

  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/firebase_core');

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    methodCallLog.add(methodCall);
    if (customHandlers != null) {
      customHandlers(methodCall);
    }
    switch (methodCall.method) {
      case 'Firebase#initializeCore':
        return {
          'name': '[DEFAULT]',
          'options': {
            'apiKey': 'fakeApiKey',
            'appId': '1:111111111111:web:1111111111111111',
            'messagingSenderId': '111111111111',
            'projectId': 'test',
          },
          'pluginConstants': {},
        };
      default:
        return null;
    }
  });
}
