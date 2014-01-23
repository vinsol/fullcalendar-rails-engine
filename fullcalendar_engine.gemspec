$:.push File.expand_path("../lib", __FILE__)

require "fullcalendar_engine/version"

Gem::Specification.new do |s|
  s.name        = "fullcalendar_engine"
  s.version     = FullcalendarEngine::VERSION
  s.license     = 'MIT'
  s.authors     = ["Team Vinsol"]
  s.email       = ["info@vinsol.com"]
  s.homepage    = "http://vinsol.com"
  s.summary     = "Engine Implementation of jQuery Full Calendar"
  s.description = "Engine Implementation of jQuery Full Calendar"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files  = Dir["test/**/*"]

  s.add_dependency "rails"
end
