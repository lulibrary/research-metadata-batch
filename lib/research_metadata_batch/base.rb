require 'logger'
require 'puree'

module ResearchMetadataBatch
  # @note Not to be used directly.
  class Base
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

    # @param max [Fixnum] Number of records to act upon. Omit to act upon as many as possible.
    # @param limit [Fixnum] Pure records limit.
    # @param offset [Fixnum] Pure records offset.
    # @param action [Boolean] Set to false to mock an action.
    # @param delay [Fixnum] Delay in seconds between limit-sized batches.
    def process(max: nil, limit: 20, offset: 0, action: true, delay: 0)
      records_available = resource_count

      @logger.info "#{records_available} records in Pure before processing"
      if action
        begin
          init
          @logger.info init_success_logger_message
        rescue => error
          @logger.info init_error_logger_message(error)
        end
      end

      if max
        if max >= 0 && max <= records_available
          qty_to_find = max
        end
      else
        qty_to_find = records_available
      end

      if offset < 0 || offset > records_available - 1
        offset = 0
      end

      qty_obtained = 0
      position = offset

      while position < records_available
        # extract from Pure
        begin
          result = resource_batch limit, position
        rescue => e
          @logger.error e
          sleep 10
          redo
        end

        result.each do |i|

          if !record_valid? i
            @logger.warn "#{logger_message_prefix(position, i.uuid)} - record invalid"
            position += 1
            next
          end

          begin
            if action
              act_msg = act i
            else
              act_msg = mock_act i
            end
            @logger.info "#{logger_message_prefix(position, i.uuid)} - #{act_success_logger_message(i, act_msg)}" if act_msg
          rescue => error
            @logger.error "#{logger_message_prefix(position, i.uuid)} - ERROR=#{error}"
          end

          position += 1
          qty_obtained += 1

          break if qty_obtained == qty_to_find
        end

        break if qty_obtained == qty_to_find

        # handle error response
        if result.empty?
          @logger.error "#{logger_message_prefix(position, nil)} - ERROR=system"
          position += 1
        end

        sleep delay
      end

      @logger.info "#{records_available} records in Pure after processing"

    end

    private

    def init
      # Define in subclasses
    end

    def init_success_logger_message
      # Define in subclasses
    end

    def init_error_logger_message(error)
      # Define in subclasses
    end

    def act(model)
      # Define in subclasses
    end

    def act_success_logger_message(model, act_msg)
      # Define in subclasses
    end

    def mock_act(model)
      # Define in subclasses
      puts model.inspect
    end

    def record_valid?(model)
      # Define in subclasses
      true
    end

    def logger_message_prefix(pure_record, pure_uuid)
      "PURE_RECORD=#{pure_record} - PURE_UUID=#{pure_uuid}"
    end

    def resource_count
      resource_class = "Puree::Extractor::#{Puree::Util::String.titleize(@resource_type)}"
      Object.const_get(resource_class).new(@pure_config).count
    end

    def resource_batch(limit, offset)
      resource_method = "#{@resource_type}s".to_sym
      client = Puree::REST::Client.new(@pure_config).send resource_method
      response = client.all params: {size: limit, offset: offset}
      Puree::XMLExtractor::Collection.send resource_method, response.to_s
    end
  end
end