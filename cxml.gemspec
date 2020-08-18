require File.expand_path('../lib/cxml/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "cxml"
  s.version     = CXML::VERSION
  s.summary     = "Ruby library to work with cXML protocol"
  s.description = "Ruby library to work with cXML protocol"
  s.homepage    = "http://github.com/sosedoff/cxml"
  s.authors     = ["Dan Sosedoff"]
  s.email       = ["dan.sosedoff@gmail.com"]

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec',     '~> 2.13'
  s.add_development_dependency 'simplecov', '~> 0.7'

  s.add_dependency 'nokogiri'
  s.add_dependency 'xml-simple'
  s.add_dependency 'hashr'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  s.require_paths = ["lib"]
end
