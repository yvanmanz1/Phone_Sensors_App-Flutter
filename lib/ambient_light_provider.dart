import 'package:flutter_sensors/flutter_sensors.dart';

class AmbientLightProvider {
  double _ambientLightLevel = 0.0;

  double get ambientLightLevel => _ambientLightLevel;

  void startListeningAmbientLight() {
    ambientLightEvents.listen((ambientLightEvent) {
      _ambientLightLevel = ambientLightEvent.light;
    });
  }

  void stopListeningAmbientLight() {
    ambientLightEvents.drain();
  }
}
