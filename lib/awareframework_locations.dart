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
  Stream<Map<String,dynamic>> get onLocationChanged {
    return super.getBroadcastStream(_locationEvent, 'on_location_changed')
        .map((dynamic event) => Map<String,dynamic>.from(event));
  }

  @override
  void cancelAllEventChannels() {
    super.cancelBroadcastStream('on_location_changed');
  }

}

class LocationSensorConfig extends AwareSensorConfig {

  // TODO: make a converter or just send a String ?
  String geoFences;

  /// statusGps: Boolean true or false to activate or deactivate GPS locations. (default = true)
  bool statusGps = true;

  /// statusNetwork: Boolean true or false to activate or deactivate Network locations. (default = true)
  bool statusNetwork = true;

  /// statusLocationVisit: (only iOS)
  bool statusLocationVisit = true;

  /// statusPassive: Boolean true or false to activate or deactivate passive locations. (default = true)
  bool statusPassive = true;

  /// frequencyGps: Int how frequent to check the GPS location, in seconds.
  /// By default, every 180 seconds. Setting to 0 (zero) will keep the GPS location tracking always on. (default = 180)
  // TODO: interval or frequency? second or min?
  int intervalGps = 180;

  /// minGpsAccuracy: Int the minimum acceptable accuracy of GPS location, in meters.
  /// By default, 150 meters. Setting to 0 (zero) will keep the GPS location tracking always on. (default = 150)
  int minGpsAccuracy = 180;

  /// frequencyNetwork: Int how frequently to check the network location, in seconds.
  /// By default, every 300 seconds. Setting to 0 (zero) will keep the network location tracking always on. (default = 300)
  // TODO: interval or frequency? second or min?
  int intervalNetwork = 300;

  /// minNetworkAccuracy: Int the minimum acceptable accuracy of network location, in meters.
  /// By default, 1500 meters. Setting to 0 (zero) will keep the network location tracking always on. (default = 1500)
  int minNetworkAccuracy = 1500;

  /// expirationTime: Long the amount of elapsed time, in seconds, until the location is considered outdated.
  /// By default, 300 seconds. (default = 300)
  int expirationTime = 300;

  /// saveAll: Boolean Whether to save all the location updates or not. (default = false)
  bool saveAll = false;

  @override
  Map<String, dynamic> toMap() {
    var config = super.toMap();
    if (geoFences != null){
      // TODO: make a converter or just send a String ?
      config['geoFences'] = geoFences;
    }
    config['statusGps'] = statusGps;
    config['statusNetwork'] = statusNetwork;
    config['statusLocationVist'] = statusLocationVisit;
    config['statusPassive'] = statusPassive;
    config['intervalGps'] = intervalGps;
    config['intervalNework'] = intervalNetwork;
    config['minGpsAccuracy'] = minGpsAccuracy;
    config['minNetworkAccuracy'] = minNetworkAccuracy;
    config['expirationTime'] = expirationTime;
    config['saveAll'] = saveAll;
    return config;
  }
}

class LocationCard extends StatefulWidget{

  LocationCard({Key key, @required this.sensor,
                                   this.height = 250.0,
                                    this.apiKey }) : super(key: key);

  final LocationSensor sensor;
  final double height;
  final String apiKey;

  String data = "";

  @override
  State<StatefulWidget> createState() => new LocationCardState();
}


class LocationCardState extends State<LocationCard>{

  void initState(){
    super.initState();
    widget.sensor.onLocationChanged.listen((event){
      setState(() {
        if(event!=null){
          widget.data = "timestamp:${event['timestamp']}\n"
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
          new Text(widget.data)
        ],
      ) ,
      title: "Locations",
      sensor: widget.sensor,
    );
  }

  @override
  void dispose() {
    widget.sensor.cancelAllEventChannels();
    super.dispose();
  }
}