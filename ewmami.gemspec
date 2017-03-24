# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ewmami/version"

Gem::Specification.new do |s|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  s.name = "ewmami"
  s.version     = Ewmami::VERSION
  s.platform    = Gem::Platform::RUBY
  s.homepage = "http://github.com/strazzere/ewmami"
  s.license = "MIT"
  s.summary = "Wrapper for the Google Play APK Verification API"
  s.description = "This gem will allow you to query the Google Play APK Verification (AntiMalware) service"
  s.email = "diff@lookout.com"
  s.authors = ["Tim Strazzere"]

  s.files         = `git ls-files`.split("\n")
  # s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.executables = ["ewmami"]
  s.require_paths = ["lib"]

  s.add_dependency('rake', '~> 0.9.2')
  s.add_dependency('ruby_protobuf', '>=0.4.11')

  # development dependencies 
  s.add_development_dependency('yard', '~> 0.7')
  s.add_development_dependency('rdiscount', '~> 1.6')
  s.add_development_dependency('rcov', '~> 0.9')

end
