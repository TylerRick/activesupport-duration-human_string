
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "activesupport/duration/human_string/version"

Gem::Specification.new do |spec|
  spec.name          = "activesupport-duration-human_string"
  spec.version       = Activesupport::Duration::HumanString.version
  spec.authors       = ["Tyler Rick"]
  spec.email         = ["tyler@tylerrick.com"]
  spec.license       = "MIT"

  spec.summary       = %q{Convert Duration objects to human-friendly strings like '2h 30m 17s'}
  spec.description   = %q{Convert ActiveSupport::Duration objects to human-friendly strings like '2h 30m 17s'. }
                       %q{Like distance_of_time_in_words helper but exact rather than approximate. }
                       %q{Like #inspect but more concise. Like iso8601 but more human readable rather than machine readable.}
  spec.homepage      = "https://github.com/TylerRick/activesupport-duration-human_string"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.metadata["source_code_uri"]}/blob/master/Changelog.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.3.0"
  spec.add_dependency "activesupport", [">= 4.2", "< 5.3"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
