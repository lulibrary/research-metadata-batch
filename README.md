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

## Example application
This example uses Amazon Web Services.

### shared.rb
Implement methods from {ResearchMetadataBatch::Shared}.
```ruby
require 'aws-sdk-s3'

module App
  module Shared
    def init(aws_config:)
      aws_credentials = Aws::Credentials.new aws_config[:access_key_id],
                                             aws_config[:secret_access_key]
      @s3_client = Aws::S3::Client.new region: aws_config[:region],
                                       credentials: aws_credentials
      @s3_bucket = aws_config[:s3_bucket]
    end
  
    def act(model)
      # Do something involving Amazon Web Services 
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
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  region: ENV['AWS_REGION'],
  s3_bucket: 'YOUR_S3_BUCKET'
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
