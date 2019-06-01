#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_text_to_speech'
  s.version          = '2.0.0'
  s.summary          = 'An on-device Flutter Text-to-Speech plugin'
  s.description      = <<-DESC
An on-device Flutter Text-to-Speech plugin.
                       DESC
  s.homepage         = 'https://github.com/rishab2113/flutter_text_to_speech/tree/master'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Rishab Nayak' => 'rishab@bu.edu' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '8.0'
end
