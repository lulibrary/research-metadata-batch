require_relative 'base'

module ResearchMetadataBatch

  class Project < ResearchMetadataBatch::Base
    # (see ResearchMetadataBatch::Base#initialize)
    def initialize(pure_config:, log_file: nil)
      super
      @resource_type = :project
    end

  end

end
