module ResearchMetadataBatch

  # @note These methods are used internally by {ResearchMetadataBatch::Base#process} and have been left public for documentation purposes only
  module Custom

    # Second stage initialisation, perhaps third party services.
    # @param args [Hash]
    def init(**args)
    end

    # Anything to be done at the start of a batch run
    def preflight
    end

    # Message when preflight method completes
    # @return [String]
    def preflight_success_log_message
    end

    # Message when preflight method does not complete
    # @return [String]
    def preflight_error_log_message(error)
    end

    # Do something with model metadata
    # @return [String, nil] Optionally, return something transaction-specific, such as a code/ID from an external service.
    def act(model)
    end

    # Message when act/mock_act completes
    # @return [String]
    def act_success_log_message(model, act_msg)
    end

    # Fake doing something with model metadata
    # @return [String, nil]
    def mock_act(model)
    end

    # Check for values in metadata
    # @return [Boolean]
    def record_valid?(model)
    end

  end

end
