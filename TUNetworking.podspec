
Pod::Spec.new do |s|

s.name         = "TUNetworking"
s.version      = "1.0.4"
s.summary      = "TUNetworking."
s.description  = <<-DESC
				TUNetworking on github
				DESC
s.homepage     = "https://github.com/chengxianghe/TUNetworking.git"
# s.screenshots  = "https://github.com/chengxianghe/watch-gif/raw/master/PopMenu.gif?raw=true"

s.license      = "MIT"
# s.license    = { :type => "MIT", :file => "FILE_LICENSE" }

s.author             = { "chengxianghe" => "chengxianghe@outlook.com" }
# Or just: s.author    = "chengxianghe"
# s.social_media_url   = "http://twitter.com/chengxianghe"

s.platform     = :ios, "7.0"

#  When using multiple platforms
# s.ios.deployment_target = "5.0"
# s.osx.deployment_target = "10.7"
# s.watchos.deployment_target = "2.0"
# s.tvos.deployment_target = "9.0"

s.source       = { :git => "https://github.com/chengxianghe/TUNetworking.git", :tag => s.version }
s.source_files  = "TUNetworking/*"
# s.exclude_files = "Classes/Exclude"
s.public_header_files = 'TUNetworking/**/*.h'   #公开头文件地址
# s.resource_bundles = {
# 	'PodTestLibrary' => ['Pod/Assets/*.png']
# }

# 在工程中以子目录显示
s.subspec 'Config' do |ss|
  ss.source_files = 'TUNetworking/Config/*.{h,m}'
end

s.subspec 'Helper' do |ss|
  ss.source_files = 'TUNetworking/Helper/*.{h,m}'
end

s.subspec 'Manager' do |ss|
  ss.source_files = 'TUNetworking/Manager/*.{h,m}'
end

s.subspec 'Request' do |ss|
  ss.source_files = 'TUNetworking/Request/*.{h,m}'
end
# s.resource  = "icon.png"
# s.resources = "Resources/*.png"

# s.preserve_paths = "FilesToSave", "MoreFilesToSave"

# s.framework  = "SomeFramework"
s.frameworks = 'Foundation', 'UIKit'

# s.library   = "iconv"
# s.libraries = "iconv", "xml2"


# ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.requires_arc = true

# s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency 'AFNetworking'

end
