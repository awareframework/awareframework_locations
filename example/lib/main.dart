import 'package:flutter/material.dart';
import 'dart:async';

import 'package:awareframework_locations/awareframework_locations.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  LocationSensorConfig config;
  LocationSensor sensor;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    config = LocationSensorConfig();
    config
      ..debug = true;
    
    sensor = LocationSensor.init(config);

    print(sensor);

    sensor.start();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: LocationCard(sensor: sensor),
      ),
    );
  }
}
