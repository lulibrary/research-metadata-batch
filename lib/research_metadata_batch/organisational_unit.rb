require_relative 'base'

module ResearchMetadataBatch

  class OrganisationalUnit < ResearchMetadataBatch::Base
    # (see ResearchMetadataBatch::Base#initialize)
    def initialize(pure_config:, log_file: nil)
      super
      @resource_type = :organisational_unit
    end

  end

end