require_relative 'base'

module ResearchMetadataBatch

  class Dataset < ResearchMetadataBatch::Base
    # (see ResearchMetadataBatch::Base#initialize)
    def initialize(pure_config:, log_file: nil)
      super
      @resource_type = :dataset
    end

  end

end
