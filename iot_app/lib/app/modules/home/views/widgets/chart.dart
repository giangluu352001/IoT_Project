import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_app/app/modules/home/controllers/home_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class TemperatureData {
  TemperatureData(this.time, this.temperature);
  final String time;
  final double temperature;
}

class TemperatureChart extends GetView<HomeController> {
  TemperatureChart({super.key});
  @override
  final HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat.Hm(),
        title: AxisTitle(text: 'Time (hour)')
        ),
        primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        title: AxisTitle(text: 'Temperature (°C)')
        ),
        series: <LineSeries<TemperatureData, DateTime>>[
        LineSeries<TemperatureData, DateTime>(
            dataSource: controller.chartData,
            color: const Color.fromRGBO(192, 108, 132, 1),
            xValueMapper: (TemperatureData data, _) => DateTime.parse(data.time),
            yValueMapper: (TemperatureData data, _) => data.temperature,
            )
        ],
      );
  }
}