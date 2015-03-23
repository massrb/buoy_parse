# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'buoy_parse/version'

Gem::Specification.new do |spec|
  spec.name          = "buoy_parse"
  spec.version       = BuoyParse::VERSION
  spec.authors       = ["Larzdev"]
  spec.email         = ["massrubydev@gmail.com"]
  spec.summary       = %q{Parse Buoy reports}
  spec.description   = %q{Parse offshore Buoy NOAA websites for swell data }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency 'hpricot'
end
