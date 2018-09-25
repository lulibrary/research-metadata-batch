# Research Metadata Batch
For the batch processing of Pure records. Custom actions and log messages can be 
defined in user applications.


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
Custom behaviour can be achieved by subclassing ```ResearchMetadataBatch::Base``` and using its derivatives as the basis for resource classes. This example uses Amazon Web Services.

### Base class 
Implement methods to be inherited by all subclasses.

```ruby
# base.rb

require 'research_metadata_batch'

module MyApp
  class Base < ResearchMetadataBatch::Base
    def initialize(pure_config:, aws_config:, log_file: nil)
      super pure_config: pure_config, log_file: log_file
      # Do something with additional arguments provided, i.e. aws_config
    end  
        
    def init
      # Anything to be done at the start of a batch run       
    end

    def init_success_logger_message
      # Message when init method completes
    end

    def init_error_logger_message(error)
      # Message when init method does not complete
    end

    def act(model)
      # Anything to be done with model metadata
    end

    def act_success_logger_message(model, act_msg)
      # Message when act method completes
    end

    def mock_act(model)
      # Anything to be done with model metadata instead instead of completing act method.
    end    
  end
end
```

### Resource class
Optionally, implement the same methods as those in base, specific to a resource.
```ruby
# dataset.rb

require_relative 'base'

module MyApp   
  class Dataset < MyApp::Base
    # (see MyApp::Base#initialize)
    def initialize(pure_config:, aws_config:, log_file: nil)
      super
      @resource_type = :dataset
    end
  end  
end
```

### Running a batch process
```ruby
# script.rb

require_relative 'path/to/your/application/classes'

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

log_file = 'path/to/your/log/file'

config = {
  pure_config: pure_config,
  aws_config: aws_config,
  log_file: log_file
}

MyApp::Dataset.new(config).process
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
