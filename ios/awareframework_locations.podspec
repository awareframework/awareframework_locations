#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint awareframework_locations.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'awareframework_locations'
  s.version          = '0.7.9'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://www.awareframework.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Yuuki Nishiyama' => 'yuukin@iis.u-tokyo.ac.jp' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'com.awareframework.ios.sensor.locations'
  s.dependency 'awareframework_core'
  # s.dependency 'com.awareframework.ios.sensor.core'
  s.platform = :ios, '13.0'
  s.ios.deployment_target = '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
