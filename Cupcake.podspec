Pod::Spec.new do |s|

  s.name         = "Cupcake"
  s.version      = "0.1.2"
  s.summary      = "An easy way to create and layout UI components for iOS."

  s.description  = <<-DESC
  An easy way to create and layout UI components for iOS. Written in Swift.
                   DESC

  s.homepage     = "https://github.com/nerdycat/Cupcake"
  s.license      = "MIT"
  s.author       = { "nerdycat" => "nerdymozart@gmail.com" }

  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/nerdycat/Cupcake.git", :tag => "#{s.version}" }
  s.requires_arc = true

  s.source_files = "Cupcake/*.swift"
  
end
