# gateway-proof-of-concept


how to run proof-of-concept

```
#aedes_mqtt_server
cd aedes_mqtt_server
node index.js

#dart_mqtt_client
cd dart_mqtt_client
dart run
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
