lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scalr_api/version'

Gem::Specification.new do |spec|
  spec.name     ='scalr_api'
  spec.version  = ScalrApi::VERSION
  spec.authors  = ['Thom May']
  spec.email    = ['thom@may.lt']
  spec.description = %q{Model based interface to Scalr's cloud API}
  spec.summary = %q{Model based interface to Scalr's cloud API}
  spec.homepage = 'https://github.com/thommay/scalr-api'
  spec.license = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"
  spec.add_dependency "faraday_middleware"
  spec.add_dependency "multi_xml"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "timecop"
  spec.add_development_dependency "simplecov"
end
