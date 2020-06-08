lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack_password/version'

Gem::Specification.new do |spec|
  spec.name          = 'rack_password'
  spec.version       = RackPassword::VERSION
  spec.authors       = ['Marcin Stecki']
  spec.email         = ['marcin@netguru.pl']
  spec.summary       = 'Small rack middleware to block your site from unwanted vistors.'
  spec.description   = 'Small rack middleware to block your site from unwanted vistors. '\
                       'A little bit more convenient than basic auth - browser will ask '\
                       'you once for the password and then set a cookie to remember you '\
                       '- unlike the http basic auth it wont prompt you all the time.'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rack'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
end
