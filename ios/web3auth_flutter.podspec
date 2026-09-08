#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint web3auth_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'web3auth_flutter'
  s.version          = '7.0.0'
  s.summary          = 'Flutter SDK for Torus Web3Auth'
  s.description      = <<-DESC
Flutter SDK for Torus Web3Auth (OpenLogin)
                       DESC
  s.homepage         = 'https://web3auth.io'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Web3Auth' => 'hello@web3auth.io' }
  s.source           = { :path => '.' }
  # Dual CocoaPods + SwiftPM support: sources live under the SPM package tree.
  # Keep in sync with ios/web3auth_flutter/Package.swift.
  s.source_files = 'web3auth_flutter/Sources/web3auth_flutter/**/*.swift'
  s.dependency 'Flutter'
  s.dependency 'Web3Auth', '~> 12.0.1'
  s.platform = :ios, '14.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
