# Research Metadata Batch
For the batch processing of Pure records. Custom actions and log messages can be 
defined in user-defined applications.

## Status

[![Gem Version](https://badge.fury.io/rb/research_metadata_batch.svg)](https://badge.fury.io/rb/research_metadata_batch)

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

## Making an application
Require this gem, then open up the base class {ResearchMetadataBatch::Base} as below. Implement methods from 
{ResearchMetadataBatch::Custom} as inherited methods, including any secondary initialisation using the 
``init`` method.
 
 
For resource-specific customisation, open up a resource class e.g. {ResearchMetadataBatch::Dataset}. Implement methods from 
{ResearchMetadataBatch::Custom} as resource-specific methods.

This example uses Amazon Web Services.

### Base class 
```ruby
module ResearchMetadataBatch
  class Base
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

### Resource class
```ruby
module ResearchMetadataBatch   
  class Dataset    
    # Implement methods from ResearchMetadataBatch::Custom
  end  
end
```

### Running a batch process
```ruby
require_relative '/path/to/your/opened/class'

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

batch = ResearchMetadataBatch::Dataset.new config
batch.init aws_config: aws_config
batch.process
```
