
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "termy/version"

Gem::Specification.new do |spec|
  spec.name          = "termy"
  spec.version       = Termy::VERSION
  spec.authors       = ["Steven K. Terry"]
  spec.email         = ["stkterry@gmail.com"]

  spec.summary       = "A simple terminal timer."
  spec.description   = "A timer that sits in your terminal and counts away your life second by second. You can start and stop the timer, reset it, and set the time limit as well."
  spec.homepage      = "https://github.com/stkterry/termy"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  #spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.executables   << "termy"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
