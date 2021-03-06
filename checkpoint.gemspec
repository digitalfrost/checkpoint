# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "checkpoint/version"

Gem::Specification.new do |s|
  s.name        = "checkpoint"
  s.version     = Checkpoint::VERSION
  s.authors     = ["Leanbid LTD"]
  s.email       = ["it@leanbid.com"]
  s.homepage    = "https://github.com/leanbid/checkpoint"
  s.summary     = "Simple rails authorisation"
  #s.description = %q{TODO: Write a gem description}
  s.license = "MIT"

  s.rubyforge_project = "checkpoint"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
