Pod::Spec.new do |s|
  s.name         = "NSAttributedString+Geometrics"
  s.version      = "0.0.1"
  s.summary      = "NSString and NSAttributedString categories providing methods to get the width and height required for text drawing."
  s.homepage     = "https://github.com/jerrykrinock/CategoriesObjC"
  s.license      = 'Apache License, Version 2.0'
  s.author       = { "Jerry Krinock" => "jerry@sheepsystems.com" }
  s.source       = { :git => "https://github.com/jerrykrinock/CategoriesObjC.git", :commit => "5f78c2896829b101193bf2bb76b10f0b66e02f0a" }
  s.source_files = 'NS(Attributed)String+Geometrics/NS(Attributed)String+Geometrics.{h,m}'
  s.platform     = :osx
end
