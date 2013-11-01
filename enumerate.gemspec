# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "enumerate/version"

Gem::Specification.new do |s|
  s.name        = "enumerate"
  s.version     = Enumerate::VERSION
  s.authors     = ["Dale"]
  s.email       = ["dale@twilightcoders.net"]
  s.homepage    = "http://github.com/twilightcoders/enumerate"
  s.summary     = %q{enumerate adds an `enumerate` command to all ActiveRecord models which enables you to work with string or integer attributes as if they were enums}
  s.description =  <<-END
    Enumerate lets you add an enum command to ActiveRecord models

    There are four things that the enumerate gems adds to your model
      Validation - The enumerate adds a validation to make sure that the field only receives accepted values
      Predicate Methods - adds ? and ! functions for each enum value (canceled? - is it canceled, canceled! - change the state to canceled)
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
