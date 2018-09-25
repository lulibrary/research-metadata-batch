require_relative 'base'

module ResearchMetadataBatch

  class Publisher < ResearchMetadataBatch::Base
    # (see ResearchMetadataBatch::Base#initialize)
    def initialize(pure_config:, log_file: nil)
      super
      @resource_type = :publisher
    end

  end

end