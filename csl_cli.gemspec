# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'csl_cli/version'

Gem::Specification.new do |spec|
  spec.name          = "csl_cli"
  spec.version       = CslCli::VERSION
  spec.authors       = ["Nils Bartels"]
  spec.email         = ["gemcslcli@schrohm.de"]

  spec.summary       = %q{Context switch logger cli.}
  spec.homepage      = "https://github.com/brtz/csl-cli"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.14.0"
  spec.add_dependency "thor"
  spec.add_dependency "table_print"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop"

end
