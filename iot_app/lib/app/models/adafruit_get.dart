import 'dart:async';
import 'package:iot_app/app/modules/home/controllers/home_controller.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:logging/logging.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class AdafruitGET {
  AdafruitGET({
    required this.username,
    required this.password,
    required this.uniqueID
  });

  String username;
  String password;
  String uniqueID;
  late final MqttServerClient client;
  final Logger log = Logger('AdafruitIO Flutter Connection!');
  bool isConnected = false;
  Future<bool> subscribe(String topic) async {
    if (isConnected == false) {
      await mqttConnect(uniqueID);
    }
    client.onSubscribed = _onSubscribed;
    _subscribe(topic);
    return true;
  }

  void _onSubscribed(String topic) {
    log.info('Subscription confirmed for topic $topic');
  }

  Future<void> mqttConnect(String uniqueID) async {
    client = MqttServerClient('io.adafruit.com', uniqueID);
    client.logging(on: false);
    client.keepAlivePeriod = 60;
    client.port = 8883;
    client.secure = true;
    client.onConnected = () {
      log.info('Connected to adafruitIO');
    };
    client.onDisconnected = () {
      log.info('Disconnected from AdafruitIO');
    };

    final MqttConnectMessage connMess = MqttConnectMessage()
        .authenticateAs(username, password)
        .withClientIdentifier(uniqueID)
        .startClean();
    log.info('Adafruit client connecting....');
    client.connectionMessage = connMess;
    try {
      await client.connect();
    } on Exception catch (e) {
      log.severe('EXCEPTION::client exception - $e');
      isConnected = false;
      client.disconnect();
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      log.info('Adafruit client connected');
      isConnected = true;
    } else {
      log.info(
          'Adafruit client connection failed - disconnecting, status is ${client.connectionStatus}');
      isConnected = false;
      client.disconnect();
    }
  }

  Future<void> _subscribe(String topic) async {
    log.info('Subscribing to the topic $topic');
    client.subscribe(topic, MqttQos.atMostOnce);
  }

  Future startStreaming(HomeController controller) async {
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      final recMess = messages[0].payload as MqttPublishMessage;
      final String payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      log.info('Received message:$payload from topic: ${messages[0].topic}');
      String topic = messages[0].topic;
      controller.handleMessage(topic, payload);
    });
  }

// Publish to an (Adafruit) mqtt topic.
  Future<void> publish(String topic, String value) async {
    if (isConnected == true) {
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(value);
      client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
    }
  }
}
