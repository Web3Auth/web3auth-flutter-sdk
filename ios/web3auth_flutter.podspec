#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint web3auth_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'web3auth_flutter'
  s.version          = '0.1.1'
  s.summary          = 'Flutter SDK for Torus Web3Auth (OpenLogin)'
  s.description      = <<-DESC
Flutter SDK for Torus Web3Auth (OpenLogin)
                       DESC
  s.homepage         = 'https://web3auth.io'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Web3Auth' => 'hello@web3auth.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'Web3Auth', '~> 3.0.0'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
