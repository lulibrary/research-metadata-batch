require_relative 'base'

module ResearchMetadataBatch

  class Person < ResearchMetadataBatch::Base
    # (see ResearchMetadataBatch::Base#initialize)
    def initialize(pure_config:, aws_config:, log_file: nil)
      super
      @resource_type = :person
    end

  end

end
