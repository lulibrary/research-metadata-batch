require_relative 'base'

module ResearchMetadataBatch

  class Journal < ResearchMetadataBatch::Base
    # (see ResearchMetadataBatch::Base#initialize)
    def initialize(pure_config:, log_file: nil)
      super
      @resource_type = :journal
    end

  end

end