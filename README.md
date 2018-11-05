# Research Metadata Batch
Batch processing for the Pure Research Information System.

## Status

[![Gem Version](https://badge.fury.io/rb/research_metadata_batch.svg)](https://badge.fury.io/rb/research_metadata_batch)
[![Maintainability](https://api.codeclimate.com/v1/badges/d3d1723f2900c3e4774a/maintainability)](https://codeclimate.com/github/lulibrary/research-metadata-batch/maintainability)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'research_metadata_batch'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install research_metadata_batch

## Basic usage
Uses the default gem behaviour which merely inspects the metadata models using STDOUT.

```ruby 
pure_config = {
  url:      ENV['PURE_URL'],
  username: ENV['PURE_USERNAME'],
  password: ENV['PURE_PASSWORD'],
  api_key:  ENV['PURE_API_KEY']
}
ResearchMetadataBatch::Dataset.new(pure_config: pure_config).process
```

## Creating an application
Either open up classes or create subclasses to implement application-specific behaviour.

This example creates subclasses and uses Amazon Web Services.

### shared.rb
Implement methods from {ResearchMetadataBatch::Shared}.
```ruby
# require aws sdk

module App
  module Shared
    def init(aws_config:)
      # Do something with :aws_config
    end
  
    def act(model)
      # Do something with Amazon Web Services
      return {key1: 'some_value', key2: 'another_value', msg: 'what_happened'} 
    end
  end
end
```

### research_output.rb
```ruby
require_relative 'shared'

module App
  class ResearchOutput < ResearchMetadataBatch::ResearchOutput
    include App::Shared
  end  
end
```

### script.rb
```ruby
require 'research_metadata_batch'
require_relative 'research_output'

pure_config = {
  url:      ENV['PURE_URL'],
  username: ENV['PURE_USERNAME'],
  password: ENV['PURE_PASSWORD'],
  api_key:  ENV['PURE_API_KEY']
}

aws_config = {
  # details
}

log_file = '/path/to/your/log/file'

config = {
  pure_config: pure_config,
  log_file: log_file
}

batch = App::ResearchOutput.new config
batch.init aws_config: aws_config
params = {
  size: 50,
  typeUri: [
    '/dk/atira/pure/researchoutput/researchoutputtypes/contributiontojournal/article',
    '/dk/atira/pure/researchoutput/researchoutputtypes/contributiontoconference/paper'
  ]
}
batch.process params: params

```