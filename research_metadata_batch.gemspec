
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "research_metadata_batch/version"

Gem::Specification.new do |spec|
  spec.name          = "research_metadata_batch"
  spec.version       = ResearchMetadataBatch::VERSION
  spec.authors       = ["Adrian Albin-Clark"]
  spec.email         = ["a.albin-clark@lancaster.ac.uk"]

  spec.summary       = %q{Batch processing for the Pure Research Information System.}
  spec.homepage      = 'https://github.com/lulibrary/research_metadata_batch'
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ["lib"]

  spec.add_dependency 'puree', '~> 2.2'
end
