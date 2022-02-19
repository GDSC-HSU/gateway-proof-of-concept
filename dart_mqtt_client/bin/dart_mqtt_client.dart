// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:convert';

final broker_add = "0.0.0.0";
final device_id = "flutter-xxx-demo";
final client_identifier = 'org/hsu/${device_id}';

final status_topic = client_identifier + "/" + "status";
final core_event_topic = client_identifier + "/" + "core";

final client = MqttServerClient(broker_add, '');
void main(List<String> arguments) async {
  initClientConfig();
  final connection_status = await client.connect();
  if (connection_status!.state == MqttConnectionState.connected) {
    initClientSubscribe();
    intervalPublish();
  }
}

void initClientSubscribe() {
  // client.subscribe(status_topic, MqttQos.atLeastOnce);
  // client.subscribe(core_event_topic, MqttQos.atLeastOnce);

  // // for (var topic in []) {
  // //   client.subscribe(core_event_topic, MqttQos.atLeastOnce);
  // // }

  // client.updates!.listen((event) {
  //   for (var item in event) {
  //     print(''' Subscribe mess
  //     TOPIC : ${item.topic} ${"\t"} MESS : ${item.payload.toString()}
  //     ''');
  //   }
  // });
}

void intervalPublish() {
  var random = Random();

  Timer.periodic(const Duration(seconds: 1), (timer) {
    var status = random.nextInt(20) % 2 == 0 ? "online" : "offline";
    var builder = MqttClientPayloadBuilder();
    builder.addString(status);
    client.publishMessage(status_topic, MqttQos.atLeastOnce, builder.payload!);
  });

  Timer.periodic(const Duration(seconds: 1), (timer) {
    var builder = MqttClientPayloadBuilder();
    builder.addString(json.encode(core_event_sample_payload));
    client.publishMessage(
        core_event_topic, MqttQos.atLeastOnce, builder.payload!);
  });
}

void initClientConfig() {
  client.setProtocolV311();
  client.logging(on: false);
  // client.keepAlivePeriod = 180
  client.autoReconnect = true;
  client.resubscribeOnAutoReconnect = true;
  // final connectionMess = MqttConnectMessage()
  //     .withClientIdentifier(client_identifier)
  //     // .startClean()
  //     .withWillQos(MqttQos.atLeastOnce);
  // client.connectionMessage = connectionMess;

  client.onConnected = () => {print("OMG connected:")};
  client.onAutoReconnect = () => {print("OMG onAutoReconnect:")};
  client.onAutoReconnected = () => {print("OMG onAutoReconnected:")};
  client.onDisconnected = () => {print("OMG onDisconnected:")};
  client.onConnected = () => {print("OMG onConnected:")};
}

// *GCP required base 64encode
final Map<String, dynamic> core_event_sample_payload = {
  "did": device_id,
  "bodyTemperature": 37.0,
  "faceMask": true,
  "covidIdentification": {
    "identificationMethod": "QR",
    "identificationData": "xxxxxxxxxxx-xxxxxxx-xxxxxxxxx"
  },
  "isComplete": true
};
