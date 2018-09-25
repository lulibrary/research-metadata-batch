require_relative 'base'

module ResearchMetadataBatch

  class Event < ResearchMetadataBatch::Base
    # (see ResearchMetadataBatch::Base#initialize)
    def initialize(pure_config:, log_file: nil)
      super
      @resource_type = :event
    end

  end

end
