#
# Be sure to run `pod lib lint KTUILibrary.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KTUILibrary'
  s.version          = '1.0.4'
  s.summary          = 'KOTU\'s UI Library.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'KOTU\'s UI Library.'

  s.homepage         = 'https://github.com/yjling2019/KTUILibrary'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'KOTU' => 'yjling2019@gmail.com' }
  s.source           = { :git => 'https://github.com/yjling2019/KTUILibrary.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  
  s.user_target_xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }
  
  s.subspec 'Navigation' do |sp|
	  sp.source_files = 'KTUILibrary/Navigation/**/*.{h,m}'
	  sp.dependency 'KVOController'
	  sp.dependency 'Masonry'
	  sp.dependency 'KTFoundation'
  end
  
  s.subspec 'Tabbar' do |sp|
	sp.source_files = 'KTUILibrary/Tabbar/**/*.{h,m}'
	sp.dependency 'Masonry'
	sp.dependency 'KTFoundation'
  end
  
  s.subspec 'EdgesLabel' do |sp|
	sp.source_files = 'KTUILibrary/EdgesLabel/Classes/**/*.{h,m}'
  end
  
  s.subspec 'EdgesTextField' do |sp|
	sp.source_files = 'KTUILibrary/EdgesTextField/Classes/**/*.{h,m}'
  end
  
  s.subspec 'ImageLabel' do |sp|
	sp.source_files = 'KTUILibrary/ImageLabel/Classes/**/*.{h,m}'
	sp.dependency 'Masonry'
	sp.dependency 'KTFoundation/Macros'
  end
  
  s.subspec 'Toast' do |sp|
	sp.source_files = 'KTUILibrary/Toast/**/*.{h,m}'
	sp.dependency 'Masonry'
  end
  
  s.subspec 'Protocol' do |sp|
	sp.source_files = 'KTUILibrary/Protocol/**/*.{h,m}'
  end
  
  s.subspec 'Webview' do |sp|
	sp.source_files = 'KTUILibrary/Webview/**/*.{h,m}'
  end
  
end
