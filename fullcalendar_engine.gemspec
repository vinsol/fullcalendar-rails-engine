$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "fullcalendar_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "fullcalendar_engine"
  s.version     = FullcalendarEngine::VERSION
  s.authors     = ["Team Vinsol"]
  s.email       = ["info@vinsol.com"]
  s.homepage    = "http://vinsol.com"
  s.summary     = "Engine Implementation of jQuery Full Calendar"
  s.description = "Engine Implementation of jQuery Full Calendar"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

# FIXME: Make it more loose. As the engine also works on rails 3.
  s.add_dependency "rails", "~> 4.0.1"

  s.add_development_dependency "sqlite3"
end
