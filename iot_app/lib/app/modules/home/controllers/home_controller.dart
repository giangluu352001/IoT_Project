import 'dart:async';
import 'package:get/get.dart';
import 'package:iot_app/app/models/sensor_api.dart';
import '../views/widgets/chart.dart';

class HomeController extends GetxController {
  String userName = 'Truong Giang';
  List<bool> isToggled = [false, false];
  List<bool> oneHop = [false, false];
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
    }
    else {
      int index = key == 'acklight' ? 0 : 1;
      if (payload.contains("received") && oneHop[index]) {
        isToggled[index] = !isToggled[index];
        update([2, true]);
      }
      oneHop[index] = false;
    }
  }
  
  toggle(int index, String? data) {
    String sentData = isToggled[index] ? "0" : "1";
    if (sentData == data) {
      oneHop[index] = true;
    }
    else {
      // we can resend messages here again
      oneHop[index] = false;
    }
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
  }

  registerSensorData() async {
    for (var key in streams.keys) {
      await TempHumidAPI.registerData(key);
    }
    TempHumidAPI.registerStreaming(this);
  } 

  @override
  void onInit() {
    registerSensorData();
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
