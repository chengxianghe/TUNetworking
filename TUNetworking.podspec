
Pod::Spec.new do |s|

s.name         = "TUNetworking"
s.version      = "1.0.9"
s.summary      = "TUNetworking."
s.description  = <<-DESC
				TUNetworking on github
				DESC
s.homepage     = "https://github.com/chengxianghe/TUNetworking.git"
s.license      = "MIT"
s.author       = { "chengxianghe" => "chengxianghe@outlook.com" }
s.source       = { :git => "https://github.com/chengxianghe/TUNetworking.git", :tag => s.version }
s.platform     = :ios, "7.0"

s.source_files  = "TUNetworking/TUNetworking.h"
s.public_header_files = 'TUNetworking/TUNetworking.h'

s.subspec 'Helper' do |ss|
  ss.source_files = 'TUNetworking/Helper/*.{h,m}'
end

s.subspec 'Config' do |ss|
  ss.source_files = 'TUNetworking/Config/*.{h,m}'
  ss.dependency 'TUNetworking/Helper'
end

# s.subspec 'Request' do |ss|
#   ss.source_files = 'TUNetworking/Request/*.{h,m}', 'TUNetworking/Manager/*.{h,m}'
#   ss.dependency 'TUNetworking/Config'
#   ss.dependency 'TUNetworking/Helper'
# end

s.subspec 'Request' do |ss|
  ss.source_files = 'TUNetworking/Request/*.{h,m}'
  ss.dependency 'TUNetworking/Config'
  ss.dependency 'TUNetworking/Helper'
end

s.subspec 'Manager' do |ss|
  ss.source_files = 'TUNetworking/Manager/*.{h,m}'
  ss.dependency 'TUNetworking/Request'
  ss.dependency 'TUNetworking/Helper'
end

s.frameworks = 'Foundation', 'UIKit'

s.requires_arc = true

s.dependency 'AFNetworking', "~> 3.0"

end
