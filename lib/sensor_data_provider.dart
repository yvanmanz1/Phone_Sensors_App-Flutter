import 'package:flutter/material.dart';
import 'package:flutter_sensors/flutter_sensors.dart';

class SensorDataProvider extends ChangeNotifier {
  List<double> _lightReadings = [];
  List<double> _accelerometerReadings = [];

  // Light sensor
  void startLightSensor() {
    // Implement light sensor logic
    // You may need to use platform channels or a different approach to access light sensor data
  }

  // Accelerometer sensor
  void startAccelerometerSensor() async {
    final sensorEvent = await SensorManager().sensorUpdates(
      sensorId: Sensors.ACCELEROMETER,
      interval: Sensors.SENSOR_DELAY_GAME,
    );
    sensorEvent.listen((event) {
      final accelerometerData = event.data as List<double>;
      final double x = accelerometerData[0];
      _accelerometerReadings.add(x);
      notifyListeners(); // Notify listeners of changes
    });
  }

  // Get latest light readings
  List<double> get lightReadings => _lightReadings;

  // Get latest accelerometer readings
  List<double> get accelerometerReadings => _accelerometerReadings;
}
