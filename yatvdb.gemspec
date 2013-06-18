# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yatvdb/version'

Gem::Specification.new do |spec|
  spec.name          = "yatvdb"
  spec.version       = YATVDB::VERSION
  spec.authors       = ["JJ Buckley"]
  spec.email         = ["jjbuckley@gmail.com"]
  spec.description   = %q{A Ruby-ish TVDB API client}
  spec.summary       = %q{Yet another client for TheTVDB}
  spec.homepage      = "http://github.com/bjjb/yatvdb"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "fakeweb"

  spec.add_dependency "nokogiri"
end
