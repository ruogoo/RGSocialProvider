#
# Be sure to run `pod lib lint RGSocialProvider.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RGSocialProvider'
  s.version          = '0.1.0'
  s.summary          = 'A provider for social authentications.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
 A provider for social authentications.
                       DESC

  s.homepage         = 'https://github.com/ruogoo/RGSocialProvider'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'HyanCat' => 'hyancat@live.cn' }
  s.source           = { :git => 'https://github.com/ruogoo/RGSocialProvider.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'RGSocialProvider/**/*.{h,m}'
  s.resource     = 'RGSocialProvider/Libs/WeiboSDK-3.1.4/WeiboSDK.bundle'

  s.public_header_files = 'RGSocialProvider/Classes/**/*.h'
  s.private_header_files = 'RGSocialProvider/Libs/**/*.h'
  s.vendored_libraries = 'RGSocialProvider/Libs/WeiboSDK-3.1.4/libWeiboSDK.a'
  s.vendored_frameworks = 'RGSocialProvider/Libs/TencentSDK-3.1.3/TencentOpenAPI.framework'
  s.frameworks = 'CoreTelephony', 'SystemConfiguration', 'ImageIO', 'CoreText', 'QuartzCore', 'Security', 'CoreGraphics'
  s.libraries = 'c++', 'z', 'stdc++', 'sqlite3', 'iconv'

end
