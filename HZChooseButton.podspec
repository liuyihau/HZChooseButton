
Pod::Spec.new do |s|
  s.name             = 'HZChooseButton'
  s.version          = '0.1.9'
  s.summary          = '首页可选择式按钮菜单'

  s.description      = <<-DESC
                        首页可选择式按钮菜单，类似于支付宝首页的按钮选择菜单
                       DESC

  s.homepage         = 'https://github.com/liuyihau/HZChooseButton'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liuyihua' => 'liuyihua2015@sina.com' }
  s.source           = { :git => 'https://github.com/liuyihau/HZChooseButton.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'HZChooseButton/Classes/**/*'

  s.resource_bundles = {
    'HZChooseButton' => ['HZChooseButton/Assets/*']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
    s.dependency 'MJExtension'
end
