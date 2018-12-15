import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';


/// The Location measures the acceleration applied to the sensor
/// built-in into the device, including the force of gravity.
///
/// Your can initialize this class by the following code.
/// ```dart
/// var sensor = LocationSensor();
/// ```
///
/// If you need to initialize the sensor with configurations,
/// you can use the following code instead of the above code.
/// ```dart
/// var config =  LocationSensorConfig();
/// config
///   ..debug = true
///   ..frequency = 100;
///
/// var sensor = LocationSensor.init(config);
/// ```
///
/// Each sub class of AwareSensor provides the following method for controlling
/// the sensor:
/// - `start()`
/// - `stop()`
/// - `enable()`
/// - `disable()`
/// - `sync()`
/// - `setLabel(String label)`
///
/// `Stream<LocationData>` allow us to monitor the sensor update
/// events as follows:
///
/// ```dart
/// sensor.onDataChanged.listen((data) {
///   print(data)
/// }
/// ```
///
/// In addition, this package support data visualization function on Cart Widget.
/// You can generate the Cart Widget by following code.
/// ```dart
/// var card = LocationCard(sensor: sensor);
/// ```
class LocationSensor extends AwareSensor {
  static const MethodChannel _locationMethod =
      const MethodChannel('awareframework_Location/method');
  static const EventChannel _LocationStream =
      const EventChannel('awareframework_Location/event');

  static const EventChannel _onLocationChangedStream =
      const EventChannel('awareframework_Location/event_on_location_changed');
  static StreamController<LocationData> onLocationChangedStreamController =
      StreamController<LocationData>();
  LocationData data = LocationData();


  static const EventChannel _onExitRegionStream =
    const EventChannel('awareframework_Location/event_on_exit_region');
  static StreamController<GeofenceData> onExitRegionStreamController =
    StreamController<GeofenceData>();

  static const EventChannel _onEnterRegionStream =
    const EventChannel('awareframework_Location/event_on_enter_region');
  static StreamController<GeofenceData> onEnterRegionStreamController =
    StreamController<GeofenceData>();


  /// Init Location Sensor without a configuration file
  ///
  /// ```dart
  /// var sensor = LocationSensor.init(null);
  /// ```
  LocationSensor():this.init(null);

  /// Init Location Sensor with LocationSensorConfig
  ///
  /// ```dart
  /// var config =  LocationSensorConfig();
  /// config
  ///   ..debug = true
  ///   ..frequency = 100;
  ///
  /// var sensor = LocationSensor.init(config);
  /// ```
  LocationSensor.init(LocationSensorConfig config):super(config){
    super.setMethodChannel(_locationMethod);
  }

  /// An event channel for monitoring sensor events.
  ///
  /// `Stream<LocationData>` allow us to monitor the sensor update
  /// events as follows:
  ///
  /// ```dart
  /// sensor.onDataChanged.listen((data) {
  ///   print(data)
  /// }
  ///
  Stream<LocationData> get onLocationChanged {
    onLocationChangedStreamController.close();
    onLocationChangedStreamController = StreamController<LocationData>();
    return onLocationChangedStreamController.stream;
  }

  Stream<GeofenceData> get onEnterRegion {
    onEnterRegionStreamController.close();
    onEnterRegionStreamController = StreamController<GeofenceData>();
    return onEnterRegionStreamController.stream;
  }

  Stream<GeofenceData> get onExitRegion {
    onExitRegionStreamController.close();
    onExitRegionStreamController = StreamController<GeofenceData>();
    return  onExitRegionStreamController.stream;
  }


  @override
  Future<Null> start() {
    super.getBroadcastStream(_onLocationChangedStream, "on_location_changed").map(
            (dynamic event) => LocationData.from(Map<String,dynamic>.from(event))
    ).listen((event){
      this.data = event;
      if(!onLocationChangedStreamController.isClosed){
        onLocationChangedStreamController.add(event);
     }
    });
    super.getBroadcastStream(_onExitRegionStream, "on_exit_region").map(
      (dynamic event) => GeofenceData.from(Map<String,dynamic>.from(event))
    ).listen((event){
      if(!onExitRegionStreamController.isClosed){
        onExitRegionStreamController.add(event);
      }
    });
    super.getBroadcastStream(_onEnterRegionStream, "on_enter_region").map(
      (dynamic event) => GeofenceData.from(Map<String,dynamic>.from(event))
    ).listen((event){
      if(!onEnterRegionStreamController.isClosed){
        onEnterRegionStreamController.add(event);
      }
    });

    return super.start();
  }

  @override
  Future<Null> stop() {
    super.cancelBroadcastStream("on_location_changed");
    super.cancelBroadcastStream("on_exit_region");
    super.cancelBroadcastStream("on_enter_region");
    return super.stop();
  }
}


/// A configuration class of LocationSensor
///
/// You can initialize the class by following code.
///
/// ```dart
/// var config =  LocationSensorConfig();
/// config
///   ..debug = true
///   ..frequency = 100;
/// ```
class LocationSensorConfig extends AwareSensorConfig {

  // TODO: make a converter or just send a String ?
  String geoFences;

  /// statusGps: Boolean true or false to activate or deactivate GPS Location. (default = true)
  bool statusGps = true;

  /// statusNetwork: Boolean true or false to activate or deactivate Network Location. (default = true)
  bool statusNetwork = true;

  /// statusLocationVisit: (only iOS)
  bool statusLocationVisit = true;

  /// statusPassive: Boolean true or false to activate or deactivate passive Location. (default = true)
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

  List<Region> regions;

  @override
  Map<String, dynamic> toMap() {
    var config = super.toMap();
    if (geoFences != null){
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
    if (regions != null) {
      var list = List<Map<String,dynamic>>();
      for(int i=0; i<regions.length; i++){
        list.add(regions[i].toMap());
      }
      config['regions'] = list;
    }
    return config;
  }
}


/// A data model of LocationSensor
///
/// This class converts sensor data that is Map<String,dynamic> format, to a
/// sensor data object.
///
class Region {
  double latitude = 0.0;
  double longitude = 0.0;
  double radius = 0.0;
  String id = "";

  Region({@required this.latitude, @required this.longitude, @required this.radius, @required this.id});

  Map<String,dynamic> toMap(){
    var region = Map<String,dynamic>();
    region["latitude"] = latitude;
    region["longitude"] = longitude;
    region["radius"] = radius;
    region["id"] = id;
    return region;
  }
}


/// A data model of LocationSensor
///
/// This class converts sensor data that is Map<String,dynamic> format, to a
/// sensor data object.
///
class LocationData extends AwareData {

  Map<String,dynamic> source;

  double latitude = 0.0;
  double longitude = 0.0;
  double course = 0.0;
  double speed = 0.0;
  double altitude = 0.0;
  double horizontalAccuracy = 0.0;
  double verticalAccuracy = 0.0;
  int floorLevel = 0;

  LocationData():this.from(null);

  LocationData.from(Map<String,dynamic> data ):super.from(data){
    if(data != null){
      latitude  = data["latitude"] ?? 0.0;
      longitude = data["longitude"]  ?? 0.0;
      course    = data["course"] ?? 0.0;
      speed     = data["speed"] ?? 0.0;
      altitude  = data["altitude"] ?? 0.0;
      horizontalAccuracy = data["horizontalAccuracy"] ?? 0.0;
      verticalAccuracy = data["verticalAccuracy"] ?? 0.0;
      floorLevel = data["floor"] ?? 0;
    }
  }

  @override
  String toString() {
    if(source != null){
      return source.toString();
    }
    return super.toString();
  }
}


/// A data model of LocationSensor
///
/// This class converts sensor data that is Map<String,dynamic> format, to a
/// sensor data object.
///
class GeofenceData extends AwareData{
  double horizontalAccuracy = 0.0;
  double verticalAccuracy   = 0.0;
  double latitude           = 0.0;
  double longitude          = 0.0;

  bool onExit  = false;
  bool onEntry = false;

  String identifier = "";

  GeofenceData():this.from(null);
  GeofenceData.from(Map<String,dynamic> data):super.from(data){
    if(data!=null){
      latitude = data["latitude"] ?? 0.0;
      longitude = data["longitude"]  ?? 0.0;
      horizontalAccuracy = data["horizontalAccuracy"] ?? 0.0;
      verticalAccuracy = data["verticalAccuracy"] ?? 0.0;
      identifier = data["identifier"] ?? "";
      onEntry = data["onEntry"] ?? false;
      onExit = data["onExit"] ?? false;
    }
  }
}



///
/// A Card Widget of Location Sensor
///
/// You can generate a Cart Widget by following code.
/// ```dart
/// var card = LocationCard(sensor: sensor);
/// ```
class LocationCard extends StatefulWidget{

  LocationCard({Key key, @required this.sensor,
                                   this.height = 250.0,
                                    this.apiKey }) : super(key: key);

  final LocationSensor sensor;
  final double height;
  final String apiKey;

  @override
  State<StatefulWidget> createState() => new LocationCardState();
}

///
/// A Card State of Location Sensor
///
class LocationCardState extends State<LocationCard>{

  String locationData = "";

  void initState(){

    super.initState();

    updateContent(widget.sensor.data);

    widget.sensor.onLocationChanged.listen((event){
      if(event!=null) {
        if (mounted) {
          setState(() {
            updateContent(event);
          });
        } else {
          updateContent(event);
        }
      }
    });
    widget.sensor.start();
  }

  void updateContent(LocationData data){
    locationData = "timestamp:${data.timestamp}\n"
        "latitude:${data.latitude}\n"
        "longitude:${data.longitude}\n"
        "altitude:${data.altitude}\n"
        "speed:${data.speed}";
  }

  Widget build(BuildContext context){
    return new AwareCard(
      contentWidget: Row(
        children: <Widget>[
          new Text(locationData)
        ],
      ) ,
      title: "Location",
      sensor: widget.sensor,
    );
  }
}