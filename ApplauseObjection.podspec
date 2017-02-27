Pod::Spec.new do |s|
  s.name         = 'ApplauseObjection'
  s.version      = '1.6.3'
  s.summary      = 'A lightweight dependency injection framework for Objective-C.'
  s.author       = { 'Justin DeWind' => 'dewind@atomicobject.com' }
  s.source       = { :git => 'https://github.com/ApplauseAQI/objection.git', :tag => "#{s.version}" }
  s.homepage     = 'http://www.objection-framework.org'
  s.source_files = 'Source'
  s.license      = { :type => "MIT" }
  s.requires_arc = true

  s.ios.deployment_target = '7.0'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.8'
end
