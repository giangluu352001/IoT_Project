import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_app/app/models/sensor_api.dart';
import '../views/widgets/chart.dart';

class HomeController extends GetxController {
  String userName = 'Truong Giang';
  List<bool> isToggled = [false, false];
  List<bool> isCompleted = [false, false];
  List<bool> isReceived = [false, false];
  List<bool> isAcked = [false, false];
  List<bool> isTimeOut = [false, false];

  final List<TemperatureData> chartData = [];

  final tempStream = StreamController<String>();
  final humidStream = StreamController<String>();
  final lightStream = StreamController<String>();
  final pumpStream = StreamController<String>();
  final ackLightStream = StreamController<String>();
  final ackPumpStream = StreamController<String>();

  late final streams = {
    "temperature": tempStream,
    "humidity": humidStream,
    "light": lightStream,
    "pump": pumpStream,
    "acklight": ackLightStream,
    "ackpump": ackPumpStream
  };

  handleMessage(String topic, String payload) {
    var key = topic.split("/").last;
    if (!key.contains("ack")) {
      streams[key]!.add(payload);
      if (key.contains("temperature")) {
        final temperature = double.parse(payload);
        final time = DateTime.now().toString();
        chartData.add(TemperatureData(time, temperature));
        if (chartData.length > 30) {
          chartData.removeAt(0);
        }
        update([3, true]);
      }
    } else {
      int index = key == 'acklight' ? 0 : 1;
      if (payload.contains("received")) {
        isAcked[index] = true;
        changeStateButton(index);
      }
    }
  }

  toggle(int index, String? data) {
    String sentData = isToggled[index] ? "0" : "1";
    if (sentData == data) {
      isReceived[index] = true;
    }
  }

  Future<void> _myFuture(int index) async {
    isTimeOut[index] = false;
    await Future.delayed(const Duration(seconds: 3), () {
      isTimeOut[index] = true;
    });
  }

  onSwitched(int index) {
    if (index == 0) {
      var value = isToggled[index] ? "0" : "1";
      TempHumidAPI.updateData("light", value);
    }
    if (index == 1) {
      var value = isToggled[index] ? "0" : "1";
      TempHumidAPI.updateData("pump", value);
    }
    isReceived[index] = false;
    isAcked[index] = false;
    isCompleted[index] = false;
    _myFuture(index);
  }

  registerSensorData() async {
    for (var key in streams.keys) {
      await TempHumidAPI.registerData(key);
    }
    TempHumidAPI.registerStreaming(this);
  }

  changeStateButton(int idx) {
    if (isReceived[idx] && isAcked[idx]) {
      isToggled[idx] = !isToggled[idx];
      isCompleted[idx] = true;
      update([2, true]);
    }
  }

  timeOutMqtt() {
    for (int idx = 0; idx < isToggled.length; idx++) {
      if (isTimeOut[idx] && !isCompleted[idx]) {
        Get.snackbar(
          "An error has occured",
          "Please try again!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
        );
        isTimeOut[idx] = false;
      }
    }
  }

  @override
  void onInit() {
    registerSensorData();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      timeOutMqtt();
    });
    super.onInit();
  }

  @override
  void onClose() {
    tempStream.close();
    humidStream.close();
    lightStream.close();
    pumpStream.close();
    ackLightStream.close();
    ackPumpStream.close();
    super.onClose();
  }
}
