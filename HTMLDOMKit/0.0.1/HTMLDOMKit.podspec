Pod::Spec.new do |s|
  s.name             = "HTMLDOMKit"
  s.version          = "0.0.1"
  s.summary          = "An HTML DOM generation tool written in Swift"


  s.description      = <<-DESC
HTMLDOMKit allows the creation of HTML DOMs for the building of web pages. HTML pages are built using the DOM Elements and DOM Attributes, or just as a simple Dictionary. Either method can then be converted using the toHTML() method.
                       DESC

  s.homepage         = "https://github.com/MadApper/HTMLDOMKit"
  s.license          = 'MIT'
  s.author           = { "Paul Napier" => "paul.napier@madapper.co.uk" }
  s.source           = { :git => "https://github.com/MadApper/HTMLDOMKit.git", :branch => "master", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/madapperapps'

  s.ios.deployment_target = '8.0'

  s.source_files = 'HTMLDOMKit/Classes/**/*'
end
