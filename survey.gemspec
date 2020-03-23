# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "survey/version"

Gem::Specification.new do |s|
  s.name        = "survey"
  s.version     = Survey::VERSION
  s.summary     = %Q{Survey is a user oriented tool that brings surveys into Rails applications.}
  s.description = %Q{A rails gem to enable surveys in your application as easy as possible}
  s.files       = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.md"]
  s.authors     = %Q{Runtime Revolution}
  s.require_paths = %w(lib)

  s.add_dependency("rails", ["~> 5.0.7"])
  s.add_dependency("railties", "~> 5.0.7")
  s.add_development_dependency("mocha")
  s.add_development_dependency("faker", ['~> 1.8', '>= 1.8.7'])
  s.add_development_dependency("rake")
end
