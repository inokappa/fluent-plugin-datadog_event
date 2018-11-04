# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fluent/plugin/datadog_event/version'

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-datadog_event"
  spec.version       = Fluent::Plugin::DatadogEvent::VERSION
  spec.authors       = ["Yohei Kawahara(inokappa)"]
  spec.email         = [""]

  spec.summary       = %q{fluentd plugin for datadog event}
  spec.description   = %q{fluentd plugin for datadog event}
  spec.homepage      = "https://github.com/inokappa/fluent-plugin-datadog_event"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "dogapi"
  spec.add_runtime_dependency "fluentd", [">= 0.14.0", "< 2"]
  spec.add_runtime_dependency "fluent-mixin-rewrite-tag-name"
  spec.add_development_dependency "test-unit"
end
