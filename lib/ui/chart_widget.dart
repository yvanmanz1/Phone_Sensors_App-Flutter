import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'package:sensors/sensor_data_provider.dart';

class ChartWidget extends StatelessWidget {
  final String title;
  final List<double> data;

  ChartWidget({required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      height: 200.0,
      child: Card(
        elevation: 4.0,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Expanded(
                child: charts.LineChart(
                  _createSeries(data),
                  animate: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<charts.Series<ChartData, int>> _createSeries(List<double> data) {
    List<ChartData> chartDataList = [];
    for (int i = 0; i < data.length; i++) {
      chartDataList.add(ChartData(i, data[i]));
    }

    return [
      charts.Series<ChartData, int>(
        id: 'Sensor Data',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (ChartData data, _) => data.index,
        measureFn: (ChartData data, _) => data.value.toInt(),
        data: chartDataList,
      ),
    ];
  }
}

class ChartData {
  final int index;
  final double value;

  ChartData(this.index, this.value);
}
