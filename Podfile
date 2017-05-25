platform :ios, "9.0"

use_frameworks!
inhibit_all_warnings!

target "Monies" do
  pod 'RealmSwift'
  pod 'DateTools'
  pod 'Luncheon', git: 'https://github.com/Dan2552/Luncheon.git'
  pod 'Napkin', git: 'https://github.com/Dan2552/Napkin.git'
  pod 'Placemat', git: 'https://github.com/Dan2552/Placemat.git'
  pod 'ChameleonFramework/Swift', git: 'https://github.com/ViccAlexander/Chameleon.git'
  pod 'AsyncSwift'
  pod 'PureLayout'
  pod 'thenPromise'
end

post_install do |installer|
  installer.pods_project.targets.each  do |target|
      target.build_configurations.each  do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
      end
   end
end
