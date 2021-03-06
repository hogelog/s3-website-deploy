
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "s3_website_deploy/version"

Gem::Specification.new do |spec|
  spec.name          = "s3-website-deploy"
  spec.version       = S3WebsiteDeploy::VERSION
  spec.authors       = ["hogelog"]
  spec.email         = ["konbu.komuro@gmail.com"]

  spec.summary       = %q{S3 Website deploy tool.}
  spec.description   = %q{S3 Website deploy tool.}
  spec.homepage      = "https://github.com/hogelog/s3-website-deploy"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk-s3", "< 2"
  spec.add_dependency "mini_mime"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-mocks"
  spec.add_development_dependency "rspec_junit_formatter"
  spec.add_development_dependency "pry"
end
