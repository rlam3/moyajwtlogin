# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'moyaJWTLogin' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'RxSwift'
  pod 'ReachabilitySwift', '3'
  # pod 'Moya/RxSwift'
  pod 'Locksmith'
  pod 'JWTDecode'
  pod 'Cely'
  pod 'Moya-ModelMapper'
  pod 'Moya-ModelMapper/RxSwift'
  # Pods for moyaJWTLogin

end


swift_32 = []
swift4 = ['Cely','Moya-ModelMapper','Eureka', 'Quick', 'Nimble', 'FlatUIColors', 'TinyConstraints','Kingfisher', 'Locksmith', 'JWTDecode', 'Kingfisher', 'Font-Awesome-Swift', 'Moya-ModelMapper/RxSwift','RxSwift']

post_install do |installer|
  installer.pods_project.targets.each do |target|
    swift_version = nil

    if swift_32.include?(target.name)
      swift_version = '3.2'
    end

    if swift4.include?(target.name)
      swift_version = '4.0'
    end

    if swift_version
      target.build_configurations.each do |config|
        # config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = '$(inherited)'
        config.build_settings['SWIFT_VERSION'] = swift_version
    end

  end
end
end