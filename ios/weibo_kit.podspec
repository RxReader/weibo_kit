#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint weibo_kit.podspec` to validate before publishing.
#

pubspec = YAML.load_file(File.join('..', 'pubspec.yaml'))
library_version = pubspec['version'].gsub('+', '-')

Pod::Spec.new do |s|
  s.name             = 'weibo_kit'
  s.version          = library_version
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

  # v3.3.0
  s.static_framework = true
  s.subspec 'vendor' do |sp|
    sp.dependency 'Weibo_SDK', '~> 3.3.0'
  end

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
