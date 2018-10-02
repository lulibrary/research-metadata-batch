
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "research_metadata_batch/version"

Gem::Specification.new do |spec|
  spec.name          = "research_metadata_batch"
  spec.version       = ResearchMetadataBatch::VERSION
  spec.authors       = ["Adrian Albin-Clark"]
  spec.email         = ["a.albin-clark@lancaster.ac.uk"]
  spec.summary       = %q{Batch processing for the Pure Research Information System.}
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '~> 2.1'
  spec.add_dependency 'puree', '~> 2.2'
  spec.metadata = {
    "source_code_uri" => "https://github.com/lulibrary/research-metadata-batch"
  }
end
