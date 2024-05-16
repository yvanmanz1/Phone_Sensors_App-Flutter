import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors/sensor_data_provider.dart';
import 'package:sensors/ui/chart_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Home Monitoring'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Consumer<SensorDataProvider>(
              builder: (context, sensorDataProvider, _) {
                return ChartWidget(
                  title: 'Light Level',
                  data: sensorDataProvider.lightReadings,
                );
              },
            ),
            SizedBox(height: 16.0),
            Consumer<SensorDataProvider>(
              builder: (context, sensorDataProvider, _) {
                return ChartWidget(
                  title: 'Accelerometer Readings',
                  data: sensorDataProvider.accelerometerReadings,
                );
              },
            ),
            SizedBox(height: 16.0),
            Consumer<SensorDataProvider>(
              builder: (context, sensorDataProvider, _) {
                return Text(
                  'Ambient Light Level: ${sensorDataProvider.ambientLightLevel}',
                  style: TextStyle(fontSize: 18.0),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
