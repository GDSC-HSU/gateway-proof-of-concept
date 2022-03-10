# gateway-proof-of-concept


how to run proof-of-concept

##### Folder structure

1. ```[aedes_mqtt_server](./aedes_mqtt_server/)```

Test out ours backend MQTT library

2. ```[dart_mqtt_client](./dart_mqtt_client/)```

Test out Dart MQTT client compatible with MQTT Broker made by aedes (MOSA), client and broker are able to comunicate publish and subscribe topic, client connection status (online, offline) has been proved to be working.

3. ```[poc_tflite_and_qr](./poc_tflite_and_qr/)``` **```ONLY RUN WITH REAL DEVICE```**

Tested with android, ios devices (Iphone 6s, 12 - Nokia C20)
Flutter running ```tensorflow lite``` inter with ```camera package```, ```google_ml_kit``` (prove of concept flutter framework able to run those task and not crashing)


##### How to run mockup
```
#aedes_mqtt_server
cd aedes_mqtt_server
node index.js

#dart_mqtt_client
cd dart_mqtt_client
dart run

#poc_tflite_and_qr
cd poc_tflite_and_qr
^Noted: only run with real device
flutter app => pub get, flutter run
```

IOT CORE sequenceDiagram concept
```mermaid
sequenceDiagram
    participant MOBILE
    Note right of MOBILE: IOT_CORE_USE_CASE
    participant BACKEND
    participant Pub/Sub
    participant IOT_CORE

    rect rgb(191, 223, 255)
    Note right of MOBILE: MOBILE_GET_ORG_CONFIG
    MOBILE->>+BACKEND:org_config_request
    BACKEND->>-MOBILE:org_config
    end

    rect rgb(200, 150, 255)
    Note over MOBILE,IOT_CORE: DEVICE_IOT_CORE_CONFIG
    MOBILE->>+BACKEND:org_device_claim_request
    BACKEND->>+IOT_CORE:register_iot_device
    BACKEND->>-IOT_CORE:get_register_device_info
    
    IOT_CORE->>+BACKEND:iot_device(jwt,id)
    BACKEND->>-MOBILE:device_config(jwt,id,gcp root pem)
    end

    rect rgb(238, 238, 238)
    Note over MOBILE,IOT_CORE: DEVICE_CONNECT_TO_IOT_CORE
    
    rect rgb(216, 210, 203)
    MOBILE->>+IOT_CORE:CONNECT(JWT,device-id)
    IOT_CORE->>-MOBILE:CONNETION_GRANTED(valid)
    end
    
    Note over MOBILE,IOT_CORE: MOBILE PUBLISH TOPIC
    MOBILE->>+IOT_CORE: pubslish "org/{org}/device/{id}/core_event"

    rect rgb(216, 210, 203)
    IOT_CORE->>-Pub/Sub: forward "org/{org}/device/{id}/core_event"
    BACKEND->>Pub/Sub:subscribe  "org/{org}/device/{id}/core_event"
    end
    end
```
