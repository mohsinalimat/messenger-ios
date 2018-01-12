# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'Pulse' do
  use_frameworks!
  
  # ignore all warnings from all pods
  inhibit_all_warnings!

  pod 'SlackTextViewController', '~> 1.9.6'
  pod 'TURecipientBar', '~> 2.0'
  pod 'ActiveLabel', :git => 'https://github.com/optonaut/ActiveLabel.swift.git', :tag => '0.8.0'
  
  pod 'RxSwift', '~> 4.0'
  pod 'Kingfisher', '~> 4.0'
  pod 'Alamofire', '~> 4.5'
  pod 'SwiftyJSON', '~> 4.0.0'
  pod 'AsyncSwift', '~> 2.0.4'
  pod 'CryptoSwift', '~> 0.8.0'
  pod 'DeviceKit', '~> 1.0'
  
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'FirebaseInstanceID', '2.0.0'
  
  target 'PulseTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PulseUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  
end
