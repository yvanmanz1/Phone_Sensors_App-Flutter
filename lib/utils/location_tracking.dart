import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationTracking {
  static Location _location = Location();
  static LocationData? _currentLocation;
  static Stream<LocationData>? _locationStream;

  static Future<void> startLocationTracking(BuildContext context) async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        // Location services are not enabled
        return;
      }
    }

    PermissionStatus permissionStatus = await _location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await _location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        // Location permissions are not granted
        return;
      }
    }

    _locationStream = _location.onLocationChanged;
    _locationStream?.listen((LocationData locationData) {
      _currentLocation = locationData;
      _checkGeofence(context);
    });
  }

  static void _checkGeofence(BuildContext context) {
    // Implement geofencing logic here
    // For example, check if the current location is within predefined geographical boundaries
    // Trigger actions or notifications accordingly
    // This is a placeholder method
    print('Current Location: ${_currentLocation.toString()}');
  }
}
