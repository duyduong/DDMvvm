Pod::Spec.new do |s|
  s.name             = 'DDMvvm'
  s.version          = '3.0.0'
  s.summary          = 'A MVVM library for iOS Swift.'

  s.description      = <<-DESC
A MVVM library for iOS Swift, including interfaces for View, ViewModel and Model, DI and Services
                       DESC

  s.homepage              = 'https://github.com/duyduong/DDMvvm.git'
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { 'Dao Duy Duong' => 'dduy.duong@gmail.com' }
  s.source                = { :git => 'https://github.com/duyduong/DDMvvm.git', :tag => s.version.to_s }
  s.swift_version         = '5.0'
  s.ios.deployment_target = '11.0'
  s.source_files          = 'Sources/DDMvvm/Classes/**/*'
  s.frameworks            = 'UIKit'

  s.dependency 'RxSwift', '6.1.0'
  s.dependency 'RxCocoa'
  s.dependency 'Alamofire', '5.2.0'
  s.dependency 'AlamofireImage', '4.0.0'
  s.dependency 'SnapKit', '5.0.1'
end
