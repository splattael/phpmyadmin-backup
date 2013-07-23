# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'phpmyadmin/backup/version'

Gem::Specification.new do |spec|
  spec.name          = "phpmyadmin-backup"
  spec.version       = Phpmyadmin::Backup::VERSION
  spec.authors       = ["Peter Suschlik"]
  spec.email         = ["peter-phpmyadmin-backup@suschlik.de"]
  spec.description   = %q{Backup SQL dumps via phpmyadmin}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/splattael/phpmyadmin-backup"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "mechanize", "~> 2.7.1"
end
