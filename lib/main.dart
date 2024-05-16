import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors/sensor_data_provider.dart';
import 'package:sensors/ui/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SensorDataProvider(),
      child: MaterialApp(
        title: 'Smart Home Monitoring',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
