#
# Be sure to run `pod lib lint PoporDomainConfig.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PoporDomainConfig'
  s.version          = '0.0.06'
  s.summary          = '简易的域名配置工具,方便开发测试.'

  s.homepage         = 'https://github.com/popor/PoporDomainConfig'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'popor' => '908891024@qq.com' }
  s.source           = { :git => 'https://github.com/popor/PoporDomainConfig.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.source_files = 'Example/Classes/PoporDomainConfig/*.{h,m}'
  
  s.dependency 'YYModel'
  s.dependency 'YYCache'
  s.dependency 'Masonry'
  s.dependency 'ReactiveObjC'
  
  s.dependency 'PoporFoundation/PrefixCore'
  s.dependency 'PoporUI/UIImage'
  s.dependency 'PoporUI/UITextField'
  s.dependency 'PoporUI/UIViewController'
  s.dependency 'PoporUI/UINavigationController'
  s.dependency 'PoporUI/IToast'
  
end
