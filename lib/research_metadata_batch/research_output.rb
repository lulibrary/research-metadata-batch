require_relative 'base'

module ResearchMetadataBatch

  class ResearchOutput < ResearchMetadataBatch::Base
    # (see ResearchMetadataBatch::Base#initialize)
    def initialize(pure_config:, log_file: nil)
      super
      @resource_type = :research_output
    end

    private

    def resource_batch(params)
      research_outputs_hash = super
      research_outputs_array = []
      research_outputs_hash.each do |k, v|
        research_outputs_array += v
      end
      research_outputs_array
    end

  end

end