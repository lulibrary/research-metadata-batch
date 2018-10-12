module ResearchMetadataBatch

  # @note These methods (except init) are used internally by {ResearchMetadataBatch::Base#process} and have been left public for documentation purposes only
  module Shared

    # Second stage initialisation, perhaps third party services.
    # @param args [Hash]
    def init(**args)
    end

    # Anything to be done at the start of a batch run
    # @return [String, nil] Optionally, return something to indicate what has been done.
    def preflight
    end

    # Do something with model metadata
    # @return [String, nil] Optionally, return something transaction-specific, such as a code/ID from an external service.
    def act(model)
      puts model.inspect
    end

    # Check for values in metadata.
    # @return [Boolean]
    def valid?(model)
      true
    end

  end

end
