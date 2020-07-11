#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint weibo_kit.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'weibo_kit'
  s.version          = '1.1.0'
  s.summary          = 'A powerful Flutter plugin allowing developers to auth/share with natvie Android & iOS Weibo SDKs.'
  s.description      = <<-DESC
A powerful Flutter plugin allowing developers to auth/share with natvie Android & iOS Weibo SDKs.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # v3.2.7
  s.static_framework = true
  s.subspec 'vendor' do |sp|
    sp.dependency 'Weibo_SDK', '~> 3.2.7'
  end

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
