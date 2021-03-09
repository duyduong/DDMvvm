Pod::Spec.new do |s|
  s.name             = 'DDMvvm'
  s.version          = '1.8.6'
  s.summary          = 'A MVVM library for iOS Swift.'

  s.description      = <<-DESC
A MVVM library for iOS Swift, including interfaces for View, ViewModel and Model, DI and Services
                       DESC

  s.homepage              = 'https://github.com/duyduong/DDMvvm.git'
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { 'Dao Duy Duong' => 'dduy.duong@gmail.com' }
  s.source                = { :git => 'https://github.com/duyduong/DDMvvm.git', :tag => s.version.to_s }
  s.swift_version         = '5.0'
  s.ios.deployment_target = '10.0'
  s.source_files          = 'Sources/DDMvvm/Classes/**/*'
  s.frameworks            = 'UIKit'

  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  s.dependency 'Action'
  s.dependency 'Alamofire'
  s.dependency 'AlamofireImage'
  s.dependency 'PureLayout'
  s.dependency 'DifferenceKit'
end
