import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';

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

void initializeFakeRequestPermissions(Permission permission) {
  const MethodChannel('flutter.baseflow.com/permissions/methods')
      .setMockMethodCallHandler((methodCall) async {
    if (methodCall.method == 'requestPermissions') {
      return <dynamic, dynamic>{
        // Permission.microphone.request().isGranted を True にする
        permission.value: PermissionStatus.granted.index,
      };
    }
    return null;
  });
}

double getSignificantFigures(double x, int digit) =>
    (x * pow(10, digit)).round() / pow(10, digit);
