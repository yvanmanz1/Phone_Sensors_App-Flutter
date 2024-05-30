import 'package:flutter/material.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geofence_flutter/geofence_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'dart:math'; // Import dart:math for sqrt function
import 'package:smart_home_monitoring_app/utils/notification_service.dart'; // Assuming you have this file for notification utils

class SensorDataProvider extends ChangeNotifier {
  List<double> _lightReadings = [];
  List<double> _accelerometerReadings = [];
  double _ambientLightLevel = 0.0;
  String _detectedActivity = 'UNKNOWN';
  Position? _currentPosition;

  StreamSubscription<dynamic>? _lightSubscription;
  StreamSubscription<dynamic>? _accelerometerSubscription;
  StreamSubscription<Position>? _positionSubscription;

  SensorDataProvider() {
    initializeSensors();
    startLocationTracking();
  }

  Future<void> initializeSensors() async {
    await startLightSensor();
    await startAccelerometerSensor();
  }

  Future<void> startLightSensor() async {
    int TYPE_LIGHT = 5; // TYPE_LIGHT is equals to 5
    final sensorManager = SensorManager();

    bool isAvailable = await sensorManager.isSensorAvailable(TYPE_LIGHT);
    if (isAvailable) {
      final stream = await sensorManager.sensorUpdates(
        sensorId: TYPE_LIGHT,
        interval: Sensors.SENSOR_DELAY_NORMAL,
      );

      _lightSubscription = stream.listen((sensorEvent) {
        _ambientLightLevel = sensorEvent.data[0];
        _lightReadings.add(_ambientLightLevel);
        notifyListeners();

        if (_ambientLightLevel > 1000) {
          showNotification(
              'Light Level High', 'Ambient light level is very high!');
        } else if (_ambientLightLevel < 100) {
          showNotification(
              'Light Level Low', 'Ambient light level is very low!');
        }
      });
    }
  }

  Future<void> startAccelerometerSensor() async {
    int TYPE_ACCELEROMETER = 1; // TYPE_ACCELEROMETER is equals to 1
    final sensorManager = SensorManager();

    bool isAvailable =
        await sensorManager.isSensorAvailable(TYPE_ACCELEROMETER);
    if (isAvailable) {
      final stream = await sensorManager.sensorUpdates(
        sensorId: TYPE_ACCELEROMETER,
        interval: Sensors.SENSOR_DELAY_NORMAL,
      );

      _accelerometerSubscription = stream.listen((sensorEvent) {
        final x = sensorEvent.data[0];
        final y = sensorEvent.data[1];
        final z = sensorEvent.data[2];

        _accelerometerReadings.add(sensorEvent.data[0]);
        notifyListeners();

        // Calculate the magnitude of the accelerometer vector
        double magnitude = sqrt(x * x + y * y + z * z);

        // Determine activity based on magnitude thresholds
        if (magnitude < 2) {
          _detectedActivity = 'STILL';
        } else if (magnitude >= 2 && magnitude < 4) {
          _detectedActivity = 'TILTING';
        } else if (magnitude >= 4 && magnitude < 10) {
          _detectedActivity = 'WALKING';
        } else {
          _detectedActivity = 'UNKNOWN';
        }

        notifyListeners();

        if (magnitude > 10) {
          showNotification('Motion Detected', 'Significant movement detected!');
        }
      });
    }
  }

  Future<void> startLocationTracking() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      _currentPosition = position;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _lightSubscription?.cancel();
    _accelerometerSubscription?.cancel();
    _positionSubscription?.cancel();
    super.dispose();
  }

  List<double> get lightReadings => _lightReadings;
  List<double> get accelerometerReadings => _accelerometerReadings;
  double get ambientLightLevel => _ambientLightLevel;
  String get detectedActivity => _detectedActivity;
  Position? get currentPosition => _currentPosition;
}

void showNotification(String title, String body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    platformChannelSpecifics,
  );
}
