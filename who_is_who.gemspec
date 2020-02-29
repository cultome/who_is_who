lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "who_is_who/version"

Gem::Specification.new do |spec|
  spec.name          = "who_is_who"
  spec.version       = WhoIsWho::VERSION
  spec.authors       = ["Carlos Soria"]
  spec.email         = ["csoria@cultome.io"]

  spec.summary       = "Who is who?"
  spec.description   = "Who is who?"
  spec.homepage      = "https://github.com/cultome/who_is_who"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/cultome/who_is_who"
    spec.metadata["changelog_uri"] = "https://github.com/cultome/who_is_who"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", "~> 1.10"
  spec.add_dependency "thor", "~> 0.20.3"

  spec.add_development_dependency "pry", "~> 0.12.2"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
