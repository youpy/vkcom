# -*- encoding: utf-8 -*-
require File.expand_path('../lib/vkcom/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["youpy"]
  gem.email         = ["youpy@buycheapviagraonlinenow.com"]
  gem.description   = %q{A Library to extract information from vk.com }
  gem.summary       = %q{A Library to extract information from vk.com}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "vkcom"
  gem.require_paths = ["lib"]
  gem.version       = Vkcom::VERSION

  gem.add_development_dependency('rspec', ['~> 2.8.0'])
  gem.add_development_dependency('rake')
  gem.add_development_dependency('netprint')
  gem.add_development_dependency('webmock')
  gem.add_development_dependency('libxml-ruby')

  gem.add_dependency('nokogiri')
  gem.add_dependency('builder')
end
