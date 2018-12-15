import Flutter
import UIKit
import awareframework_core
import com_awareframework_ios_sensor_core
import com_awareframework_ios_sensor_locations

public class SwiftAwareframeworkLocationsPlugin: AwareFlutterPluginCore, FlutterPlugin, AwareFlutterPluginSensorInitializationHandler, LocationsObserver {
    
    public override init() {
        super.init()
        super.initializationCallEventHandler = self
    }
    
    var locationSensor:LocationsSensor?;
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftAwareframeworkLocationsPlugin()
        setMethodChannel(with: registrar,
                         instance: instance,
                         channelName: "awareframework_locations/method")
        setEventChannels(with: registrar,
                         instance:instance,
                         channelNames: ["awareframework_locations/event",
                                        "awareframework_locations/event_on_location_changed",
                                        "awareframework_locations/event_on_exit_region",
                                        "awareframework_locations/event_on_enter_region"])
    }
    
    public func initializeSensor(_ call: FlutterMethodCall,
                                 result: @escaping FlutterResult) -> AwareSensor? {
        if self.sensor == nil {
            if let config = call.arguments as? Dictionary<String,Any>{
                self.locationSensor = LocationsSensor.init(LocationsSensor.Config(config))
            }else{
                self.locationSensor = LocationsSensor.init(LocationsSensor.Config())
            }
            self.locationSensor?.CONFIG.sensorObserver = self
            return self.locationSensor
        }else{
            return nil
        }
    }
    
    public func onLocationChanged(data: LocationsData) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_location_changed" {
                handler.eventSink(data.toDictionary())
            }
        }
    }
    
    public func onExitRegion(data: GeofenceData) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_exit_region" {
                handler.eventSink(data.toDictionary())
            }
        }
    }
    
    public func onEnterRegion(data: GeofenceData) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_enter_region" {
                handler.eventSink(data.toDictionary())
            }
        }
    }
    
    public func onVisit(data: VisitData) {
        
    }
    
}
