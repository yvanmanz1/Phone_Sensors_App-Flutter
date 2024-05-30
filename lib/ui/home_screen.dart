import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home_monitoring_app/sensor_data_provider.dart';
import 'chart_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Home Monitoring'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Consumer<SensorDataProvider>(
                builder: (context, sensorDataProvider, _) {
                  return Column(
                    children: [
                      ChartWidget(
                        title: 'Light Level',
                        data: sensorDataProvider.lightReadings,
                        yAxisLabel: 'Lux',
                      ),
                      Text(
                        'Current Light Level: ${sensorDataProvider.ambientLightLevel.toStringAsFixed(2)} lux',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 16.0),
              Consumer<SensorDataProvider>(
                builder: (context, sensorDataProvider, _) {
                  return Column(
                    children: [
                      ChartWidget(
                        title: 'Accelerometer Readings',
                        data: sensorDataProvider.accelerometerReadings,
                        yAxisLabel: 'm/s²',
                      ),
                      Text(
                        'Detected Activity: ${sensorDataProvider.detectedActivity}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 16.0),
              Consumer<SensorDataProvider>(
                builder: (context, sensorDataProvider, _) {
                  return Column(
                    children: [
                      Text(
                        'Current Position',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      if (sensorDataProvider.currentPosition != null)
                        Column(
                          children: [
                            Text(
                              'Latitude: ${sensorDataProvider.currentPosition!.latitude}\nLongitude: ${sensorDataProvider.currentPosition!.longitude}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 16.0),
                            Image.asset(
                                'assets/geofence.png'), // Display the image here
                          ],
                        )
                      else
                        Text(
                          'Location not available',
                          style: TextStyle(fontSize: 16),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
