# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "survey/version"

Gem::Specification.new do |s|
  s.name        = "questionaire"
  s.version     = Survey::VERSION
  s.summary     = %Q{Questionaire is a user oriented tool that brings surveys into Rails applications.}
  s.description = %Q{A rails gem to enable surveys in your application as easy as possible}
  s.files       = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.md"]
  s.authors     = "Dr-Click"
  s.email       = "ragab.mostafa@gmail.com"
  s.homepage    = "https://github.com/dr-click/questionaire"
  s.licenses    = "MIT"
  s.require_paths = %w(lib)

  s.add_dependency("rails")
  s.add_development_dependency("mocha")
  s.add_development_dependency("faker")
  s.add_development_dependency("rake")
end