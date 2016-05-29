# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cloudit/version'

Gem::Specification.new do |spec|
  spec.name          = "cloudit"
  spec.version       = Cloudit::VERSION
  spec.authors       = ["Zachary Chai"]
  spec.email         = ["zachary.chai@outlook.com"]

  spec.summary       = %q{YAML to AWS CloudFormation}
  spec.description   = %q{Build AWS CloudFormation JSON templates from a YAML file structure}
  spec.homepage      = "https://github.com/zach-chai/cloudit"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = "cloudit"
  spec.require_paths = ["lib"]

  spec.add_dependency "slop"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
