import 'package:flutter/material.dart';

import 'package:awareframework_locations/awareframework_locations.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  late LocationSensor sensor;
  LocationData data = LocationData();
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool sensorState = true;

  @override
  void initState() {
    super.initState();

    var config = LocationSensorConfig()
      ..debug = true
      ..label = "label";

    // // init sensor without a context-card
    widget.sensor = new LocationSensor.init(config);

    // card = new AccelerometerCard(sensor: sensor,);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin Example App'),
        ),
        body: Column(
          children: [
            TextButton(
                onPressed: () {
                  widget.sensor.onLocationChanged.listen((event) {
                    setState(() {
                      Text("Latitude:\t${event.latitude}");
                      Text("Longitude:\t${event.longitude}");
                    });
                  });
                  widget.sensor.start();
                },
                child: Text("Start")),
            TextButton(
                onPressed: () {
                  widget.sensor.stop();
                },
                child: Text("Stop")),
            TextButton(
                onPressed: () {
                  widget.sensor.sync();
                },
                child: Text("Sync")),
          ],
        ),
      ),
    );
  }
}
