Pod::Spec.new do |s|
  s.name         = 'KECallsAttribution'
  s.version      = '2.1'
  s.license      =  :type => '<#License#>'
  s.homepage     = '<#Homepage URL#>'
  s.authors      =  '<#Author Name#>' => '<#Author Email#>'
  s.summary      = '<#Summary (Up to 140 characters#>'

# Source Info
  s.platform     =  :ios, '<#iOS Platform#>'
  s.source       =  :git => '<#Github Repo URL#>', :tag => '<#Tag name#>'
  s.source_files = '<#Resources#>'
  s.framework    =  '<#Required Frameworks#>'

  s.requires_arc = true
  
# Pod Dependencies
  s.dependencies =	pod 'Reachability', '~> 3.1.1'
  s.dependencies =	pod 'MBProgressHUD', '~> 0.8'
  s.dependencies =	pod 'PXAlertView', '~> 0.1.0'
  s.dependencies =	pod 'hpple', '~> 0.2.0'
  s.dependencies =	pod 'SDWebImage', '~> 3.7.1'
  s.dependencies =	pod 'ZBarSDK', '~> 1.3.1'
  s.dependencies =	pod 'AFNetworking/NSURLConnection', '~> 2.3.1'
  s.dependencies =	pod 'SVProgressHUD', '~> 1.0'
  s.dependencies =	pod 'Base64', '~> 1.0.1'

end