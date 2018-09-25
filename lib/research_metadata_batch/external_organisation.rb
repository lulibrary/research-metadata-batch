require_relative 'base'

module ResearchMetadataBatch

  class ExternalOrganisation < ResearchMetadataBatch::Base
    # (see ResearchMetadataBatch::Base#initialize)
    def initialize(pure_config:, log_file: nil)
      super
      @resource_type = :external_organisation
    end

  end

end
