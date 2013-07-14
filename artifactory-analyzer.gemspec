# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'artifactory/analyzer/version'

Gem::Specification.new do |spec|
  spec.name = 'artifactory-analyzer'
  spec.version = Artifactory::Analyzer::VERSION
  spec.authors = ['Yossi Shaul']
  spec.email = 'yoshaul@gmail.com'
  spec.date = '2013-06-09'
  spec.summary = 'Artifactory Analyzer!'
  spec.description = 'Analyzes Artifactory binaries filestore'
  spec.homepage = 'http://rubygems.org/gems/artifactory-analyzer'

  spec.files = `git ls-files`.split($/)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency("mysql", "~> 2.9.1")

  spec.add_development_dependency("bundler", ">= 1.3.5")
end