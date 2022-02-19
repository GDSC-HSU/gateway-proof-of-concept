const aedes = require('aedes')()
const { createServer } = require('aedes-server-factory')
const mqtt = require('mqtt')
const shortid = require('shortid');
const port = 1883
var client = mqtt.MqttClient
const server = createServer(aedes)
server.listen(port, function () {
    console.log('server started and listening on port ', port)
    // After we init MQTT Sever we begin to init client
    initClient()
})


function initClient() {
    console.log(server.address())

    // FOR DEMO WE BIND THE SERVER ADD TO LISTENER
    var address = server.address().address
    client = mqtt.connect(address, {
        protocol: "mqtt",
        port: port
    })

    // MQTT Client request subscribe all sensor event
    var status_topics = makeOrgSensorStatusTopic()


    client.on('connect', function () {

        // --------------- MOCK WE HAVE ALL SENSOR
        // Talk to MQTT server we want to subscribe to those status topic
        // Ex : org/hsu/device/12313/status
        status_topics.forEach(topic => {
            client.subscribe(topic, function (err) {
                if (!err) {
                    // for (let index = 0; index < 10; index++) {
                        client.publish(topic, 'Hello mqtt ' + topic)
                    // }
                }
            })
        });
        //

    })

    // IMPORTANCE !!!
    // Our nodejs server will be able to listen those topic we're subscribe
    client.on('message', function (topic, message) {
        // message is Buffer
        console.log("topic:", topic, "   \tmess: ", message.toString())
        client.end()
    })
}

function makeOrgSensorStatusTopic() {
    var org_list_of_sensor_status_topic = []

    for (let index = 0; index < 5; index++) {
        var sensor_id = shortid.generate()
        var template = `org/hsu/device/${sensor_id}/status`
        org_list_of_sensor_status_topic.push(template)
    }
    return org_list_of_sensor_status_topic

}

