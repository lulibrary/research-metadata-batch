require 'logger'
require 'puree'
require_relative 'custom'

module ResearchMetadataBatch
  # @note Not to be used directly
  class Base
    include ResearchMetadataBatch::Custom
    # @param pure_config [Hash]
    # @option config [String] :url
    # @option config [String] :username
    # @option config [String] :password
    # @option config [String] :api_key
   # @param log_file [String]
    def initialize(pure_config:, log_file: nil)
      @pure_config = pure_config
      if log_file
        @logger = Logger.new File.new(log_file, 'a'), 20, 'daily'
      else
        @logger = Logger.new(STDOUT)
      end
    end

    # @param params [Hash] Combined GET and POST parameters for all records
    # @param max [Fixnum] Number of records to act upon. Omit to act upon as many as possible.
    # @param action [Boolean] Set to false to mock an action.
    # @param delay [Fixnum] Delay in seconds between limit-sized batches.
    def process(params: {}, max: nil, action: true, delay: 0)
      puts 'process'
      puts params

      offset = params[:offset]
      records_available = resource_count params

      @logger.info "#{records_available} records in Pure before processing"
      if action
        begin
          preflight
          @logger.info preflight_success_log_message
        rescue => error
          @logger.info preflight_error_log_message(error)
        end
      end

      if max
        if max >= 0 && max <= records_available
          qty_to_find = max
        end
      else
        qty_to_find = records_available
      end

      if !offset || offset < 0 || offset > records_available - 1
        offset = 0
      end

      qty_obtained = 0
      position = offset

      while position < records_available
        # extract from Pure
        begin
          puts 'begin'
          puts params
          params[:offset] = position
          result = resource_batch params
        rescue => e
          @logger.error e
          sleep 10
          redo
        end

        result.each do |i|

          record_validation_error = validate_record i
          if record_validation_error
            @logger.warn "#{log_message_prefix(position, i.uuid)} - VALIDATION_ERROR=#{record_validation_error}"
            position += 1
            next
          end

          begin
            if action
              act_msg = act i
            else
              act_msg = mock_act i
            end
            if act_msg
              @logger.info "#{log_message_prefix(position, i.uuid)} - #{act_success_log_message(i, act_msg)}"
            else
              @logger.info "#{log_message_prefix(position, i.uuid)}"
            end
          rescue => error
            @logger.error "#{log_message_prefix(position, i.uuid)} - ERROR=#{error}"
          end

          position += 1
          qty_obtained += 1

          break if qty_obtained == qty_to_find
        end

        break if qty_obtained == qty_to_find

        # handle error response
        if result.empty?
          @logger.error "PURE_RECORD=#{position} - ERROR=No data"
          position += 1
        end

        sleep delay
      end

      @logger.info "#{records_available} records in Pure after processing"

    end

    private

    def act(model)
      puts model.inspect
    end

    # @return [String]
    def log_message_prefix(pure_record, pure_uuid)
      "PURE_RECORD=#{pure_record} - PURE_UUID=#{pure_uuid}"
    end

    def resource_count(params)
      puts 'resource_count'
      puts params

      resource_class = "Puree::Extractor::#{Puree::Util::String.titleize(@resource_type)}"
      Object.const_get(resource_class).new(@pure_config).count(params)
    end

    def resource_batch(params)
      puts 'resource_batch'
      puts params

      resource_method = "#{@resource_type}s".to_sym
      client = Puree::REST::Client.new(@pure_config).send resource_method
      response = client.all_complex params: params

      puts response.to_s

      Puree::XMLExtractor::Collection.send resource_method, response.to_s
    end
  end
end