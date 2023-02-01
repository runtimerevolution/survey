# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'survey/version'

Gem::Specification.new do |s|
  s.name        = 'survey'
  s.version     = Survey::VERSION
  s.description = 'A rails gem to enable surveys in your application as easy as possible'
  s.summary     = 'Survey is a user oriented tool that brings surveys into Rails applications.'
  s.authors     = ['Runtime Revolution']
  s.files       = Dir['{app,lib,config}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'Gemfile', 'README.md']
  s.require_paths = %w[lib]
  s.test_files = Dir.glob('spec/**/*')
  s.required_ruby_version = '>= 2.0' # rubocop:disable Gemspec/RequiredRubyVersion

  # dependencies
  s.add_dependency('rails', '>= 3.2.6')
  s.add_dependency('railties', '>= 3.2.6')
  s.add_development_dependency('faker')
  s.add_development_dependency('mocha')
  s.add_development_dependency('rake')
end
