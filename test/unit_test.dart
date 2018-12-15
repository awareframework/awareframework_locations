import 'package:test/test.dart';
import 'package:awareframework_locations/awareframework_locations.dart';

void main(){
  test("test sensor config", (){
    var config = LocationSensorConfig();
    expect(config.debug, false);
  });
}
