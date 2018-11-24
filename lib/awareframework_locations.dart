import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';

class LocationSensor extends AwareSensorCore {
  static const MethodChannel _locationMethod =
      const MethodChannel('awareframework_locations/method');
  static const EventChannel _locationEvent =
      const EventChannel('awareframework_locations/event');

  LocationSensor(LocationSensorConfig config):this.convenience(config);
  LocationSensor.convenience(config) : super(config){
    super.setMethodChannel(_locationMethod);
  }

  /// A sensor observer instance
  Stream<Map<String,dynamic>> onLocationChanged(String id) {
    return super.getBroadcastStream(_locationEvent, "on_location_changed", id)
        .map((dynamic event) => Map<String,dynamic>.from(event));
  }

}

class LocationSensorConfig extends AwareSensorConfig {
  bool   statusGps = true;
  double frequencyGps = 180.0;
  double minGpsAccuracy = 150.0;
  int    expirationTime = 300;
  bool   saveAll = false;

  @override
  Map<String, dynamic> toMap() {
    var config = super.toMap();
    config['statusGps'] = statusGps;
    config['frequencyGps'] = frequencyGps;
    config['minGpsAccuracy'] = minGpsAccuracy;
    config['expirationTime'] = expirationTime;
    config['saveAll'] = saveAll;
    return config;
  }
}

class LocationCard extends StatefulWidget{

  LocationCard({Key key, @required this.sensor, this.cardId="location_card", this.height=250.0 }) : super(key: key);

  LocationSensor sensor;
  double height;
  String cardId;

  @override
  State<StatefulWidget> createState() => new LocationCardState();
}


class LocationCardState extends State<LocationCard>{

  var data = "";
  void initState(){
    super.initState();
    widget.sensor.onLocationChanged(widget.cardId).listen((event){
      setState(() {
        if(event!=null){
          data = "timestamp:${event['timestamp']}\n"
                 "latitude:${event['latitude']}\n"
                 "longitude:${event['longitude']}\n"
                 "altitude:${event['altitude']}\n"
                 "speed:${event['speed']}";
        }
      });
    });
  }

  Widget build(BuildContext context){
    return new AwareCard(
      contentWidget: Row(
        children: <Widget>[
          new Text(data)
        ],
      ) ,
      title: "Locations",
      sensor: widget.sensor,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.sensor.cancelBroadcastStream(widget.cardId);
    super.dispose();
  }
}