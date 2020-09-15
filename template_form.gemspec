# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'template_form/version'

Gem::Specification.new do |spec|
  spec.name          = "template_form"
  spec.version       = TemplateForm::VERSION
  spec.authors       = ['Andy Stewart']
  spec.email         = ['boss@airbladesoftware.com']

  spec.summary       = 'A template-based form builder for Rails.'
  spec.description   = 'A template-based form builder for Rails.'
  spec.homepage      = 'https://github.com/airblade/template_form'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata['allowed_push_host'] = ""

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'actionpack', '> 5.0'
  spec.add_dependency 'tilt', '~> 2.0'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", "~> 5.0"
end
