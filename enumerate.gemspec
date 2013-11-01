# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "enumerate/version"

Gem::Specification.new do |s|
  s.name        = "enumerate"
  s.version     = Enumerate::VERSION
  s.authors     = ["Dale"]
  s.email       = ["dale@twilightcoders.net"]
  s.homepage    = "http://github.com/twilightcoders/enumerate"
  s.summary     = %q{Enumerate adds an `enumerate` command to all ActiveRecord models, enabling you to work with string or integer columns as if they were enums.}
  s.description =  <<-END
    Enumerate adds an `enumerate` command to all ActiveRecord models, enabling you to work with string or integer columns as if they were enums.

    The following features are added to your model:
      Validation - ensures that the field only receives accepted values
      Predicate Methods - adds ? and ! functions for each enum value
      Scopes - you can easily query for values of the enum
  END
  s.license     = 'MIT'


#  s.rubyforge_project = "enumerate"

  s.files         = `git ls-files`.split("\n") - ["Gemfile.lock"]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "activerecord", '>= 3.0'
  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'appraisal', '>= 0.3.8'
end
