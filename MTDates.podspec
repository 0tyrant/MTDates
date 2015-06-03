Pod::Spec.new do |s|
  s.name         	= "MTDates"
  s.version      	= "1.0.2"
  s.summary      	= "A category on NSDate. 100+ date calculation methods."
  s.homepage     	= "https://github.com/0tyrant/MTDates"
  s.license      	= 'MIT'
  s.author       	= { "Adam Kirk" => "atomkirk@gmail.com" }
  s.source       	= { :git => "https://github.com/0tyrant/MTDates.git", :commit => "b6499792889335fd22ab67527bd5fad040e8e782" }
  s.source_files 	= 'MTDates/*.{h,m}'
  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.8"
  s.requires_arc 	= true
end
