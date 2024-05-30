import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'sensor_data_provider.dart';

import 'package:smart_home_monitoring_app/ui/home_screen.dart';

import 'package:smart_home_monitoring_app/utils/notification_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeNotifications();

  runApp(
    ChangeNotifierProvider(
      create: (_) => SensorDataProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Home Monitoring',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
