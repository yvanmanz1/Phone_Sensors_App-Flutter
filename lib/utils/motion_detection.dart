import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sensors/flutter_sensors.dart';

class MotionDetection {
  static const double motionThreshold = 10.0; // Adjust as needed

  static void startMotionDetection(BuildContext context) async {
    StreamSubscription? subscription;
    final accelerometerStream = await SensorManager().sensorUpdates(
      sensorId: Sensors.ACCELEROMETER,
      interval: Sensors.SENSOR_DELAY_GAME,
    );
    subscription = accelerometerStream.listen((event) {
      final accelerometerData = event.data as List<double>;
      final double x = accelerometerData[0];
      final double y = accelerometerData[1];
      final double z = accelerometerData[2];

      if (x.abs() > motionThreshold ||
          y.abs() > motionThreshold ||
          z.abs() > motionThreshold) {
        _showMotionAlert(context);
        subscription?.cancel();
      }
    });
  }

  static void _showMotionAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Motion Detected!'),
          content: Text('There was unexpected motion detected.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
