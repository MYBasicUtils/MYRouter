Pod::Spec.new do |s|
  s.name             = 'MYRouter'
  s.version          = '0.1.0'
  s.summary          = 'A Router Util.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/WenMingYan/MYRouter'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'WenMingYan' => 'wenmingyan1990@gmail.com' }
  s.source           = { :git => 'https://github.com/WenMingYan/MYRouter.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'MYRouter/Classes/**/*'
  s.public_header_files = 'MYRouter/Classes/public/**/*.h'
  
end
