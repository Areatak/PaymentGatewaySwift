Pod::Spec.new do |spec|
  spec.name = "PaymentGatewaySwift"
  spec.version = "0.2"
  spec.summary = "Payment Gateway Client for Swift"
  spec.homepage = "https://github.com/areatak/PaymentGatewaySwift.git"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Cross" => 'cross@areatak.com' }
  spec.social_media_url = ""

  spec.platform = :ios, "9.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/areatak/PaymentGatewaySwift.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "PaymentGatewaySwift/**/*.{h,swift}"
  spec.resource_bundles = {
    'PaymentGatewaySwift' => ['PaymentGatewaySwift/**/*.{storyboard,xib}']
  }

  spec.dependency "StompClient", "~> 0.2.6"
end
