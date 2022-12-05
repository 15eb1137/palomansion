import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrap(Widget child) {
  return MaterialApp(home: Material(child: child));
}

void initializeFakeSensorChannel(String channelName, List<double> data) {
  const standardMethod = StandardMethodCodec();

  void emitEvent(ByteData? event) {
    ServicesBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
      channelName,
      event,
      (reply) {},
    );
  }

  TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
      .setMockMessageHandler(channelName, (message) async {
    final methodCall = standardMethod.decodeMethodCall(message);
    if (methodCall.method == 'listen') {
      emitEvent(standardMethod.encodeSuccessEnvelope(data));
      emitEvent(null);
      return standardMethod.encodeSuccessEnvelope(null);
    } else if (methodCall.method == 'cancel') {
      return standardMethod.encodeSuccessEnvelope(null);
    } else {
      fail('Expected listen or cancel');
    }
  });
}
