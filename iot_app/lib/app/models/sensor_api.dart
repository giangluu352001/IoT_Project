import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iot_app/app/models/adafruit_get.dart';
import 'package:iot_app/app/modules/home/controllers/home_controller.dart';

class TempHumidAPI {
  static String username = dotenv.env['USERNAME'].toString();
  static String aioKey = dotenv.env['APIKEY'].toString();
  static String uniqueID = dotenv.env['UNIQUEID'].toString();
  static final adafruitIO = AdafruitGET(username: username, password: aioKey, uniqueID: uniqueID);

  static Future<void> registerData(String name) async {
    var topic = "$username/feeds/$name";
    await adafruitIO.subscribe(topic);
  }

  static Future<void> registerStreaming(HomeController controller) async {
    await adafruitIO.startStreaming(controller);
  }

  static Future<void> updateData(String name, String value) async {
    var topic = "$username/feeds/$name";
    await adafruitIO.publish(topic, value);
  }
}
