# Aware Locations

TODO

## Install the plugin into project
1. Edit `pubspec.yaml`
```
dependencies:
    awareframework_locations
```

2. Import the package on your source code
```
import 'package:awareframework_locations/awareframework_locations.dart';
import 'package:awareframework_core/awareframework_core.dart';
```

### iOS
Open your project ( *.xcworkspace ) and add `NSLocationAlwaysAndWhenInUseUsageDescription` and `NSLocationWhenInUseUsageDescription`, `NSLocationAlwaysUsageDescription` into Info.plist.


## Public functions
### locations Sensor
- `start()`
- `stop()` 
- `sync(force: Boolean)`
- `enable()`
- `disable()`
- `isEnable()`

### Configuration Keys
TODO
- `period`: Float: Period to save data in minutes. (default = 1)
- `threshold`: Double: If set, do not record consecutive points if change in value is less than the set value.
- `enabled`: Boolean Sensor is enabled or not. (default = false)
- `debug`: Boolean enable/disable logging to Logcat. (default = false)
- `label`: String Label for the data. (default = "")
- `deviceId`: String Id of the device that will be associated with the events and the sensor. (default = "")
- `dbEncryptionKey` Encryption key for the database. (default = null)
- `dbType`: Engine Which db engine to use for saving data. (default = 0) (0 = None, 1 = Room or Realm)
- `dbPath`: String Path of the database. (default = "aware_accelerometer")
- `dbHost`: String Host for syncing the database. (default = null)

## Data Representations
The data representations is different between Android and iOS. Following links provide the information.
- [Android](https://github.com/awareframework/com.awareframework.android.sensor.locations)
- [iOS](https://github.com/awareframework/com.awareframework.ios.sensor.locations)

## Example usage
```dart
// init config
var config = LocationsSensorConfig()
  ..debug = true
  ..label = "label";

// init sensor
var sensor = new LocationsSensor(config);

void mathod(){
    /// start 
    sensor.start();
    
    /// set observer
    sensor.onDataChanged.listen((Map<String,dynamic> result){
      setState((){
        // Your code here
      });
    });
    
    /// stop
    sensor.stop();
    
    /// sync
    sensor.sync(true);
    
}

```

## License
Copyright (c) 2021 AWARE Mobile Context Instrumentation Middleware/Framework (http://www.awareframework.com)

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LI
CENSE-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
