Pod::Spec.new do |spec|

  spec.name         = "PaltaAnalyticsPrivateModel"
  spec.version      = "3.9.2"
  spec.summary      = "A short description of PaltaAnalyticsPrivateModel."

  spec.homepage     = "https://github.com/Palta-Data-Platform/paltalib-eventschema-swift-sdk"

  spec.license      = "MIT"

  spec.author       = { "Vyacheslav Beltyukov" => "vyacheslav.beltyukov@palta.com" }

  spec.platform     = :ios
  spec.platform     = :ios, "14.0"

  spec.source       = { :git => "https://github.com/Palta-Data-Platform/paltalib-eventschema-swift-sdk.git", :tag => "#{spec.version}" }

  spec.source_files  = "Sources/AnalyticsPrivateModel/**/*.swift"
  
  spec.dependency "SwiftProtobuf", "~> 1.21.0"

end
