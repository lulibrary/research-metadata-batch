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
Use the default classes, output metadata to STDOUT, without any further processing. With action 
set to false, the ```mock_action``` method is called, which merely inspects the metadata models.

```ruby 
ResearchMetadataBatch::Dataset.new(pure_config: pure_config).process action: false
```

## Custom application

### Base class 
Implement methods to be inherited by all subclasses.

```ruby
# base.rb

require 'research_metadata_batch'

module MyApp
  class Base < ResearchMetadataBatch::Base
    def initialize(pure_config:, my_app_config:, log_file: nil)
      # ...do something with my_app_config
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
Mandatory structure. Optionally, implement the same methods as those in base, specific to a resource.
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

def pure_config
  {
      url:      ENV['PURE_URL'],
      username: ENV['PURE_USERNAME'],
      password: ENV['PURE_PASSWORD'],
      api_key:  ENV['PURE_API_KEY']
  }
end

def other_config
  {
    foo: 'bar'
  }
end

def config
  {
    pure_config: pure_config,
    other_config: other_config
  }
end

MyApp::Dataset.new(config).process
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
