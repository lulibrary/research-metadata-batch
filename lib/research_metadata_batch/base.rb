require 'ougai'
require 'puree'
require_relative 'shared'

module ResearchMetadataBatch
  # @note Not to be used directly
  class Base
    include ResearchMetadataBatch::Shared
    # @param pure_config [Hash]
    # @option config [String] :url
    # @option config [String] :username
    # @option config [String] :password
    # @option config [String] :api_key
   # @param log_file [String]
    def initialize(pure_config:, log_file: nil)
      @pure_config = pure_config
      if log_file
        @logger = Ougai::Logger.new File.new(log_file, 'a'), 20, 'daily'
      else
        @logger = Ougai::Logger.new(STDOUT)
      end
    end

    # @param params [Hash] Combined GET and POST parameters for all records
    # @param max [Fixnum] Number of records to act upon. Omit to act upon as many as possible.
    # @param delay [Fixnum] Delay in seconds between batches.
    def process(params: {}, max: nil, delay: 0)
      offset = params[:offset]
      records_available = resource_count params
      log_records_available records_available
      begin
        preflight_h = preflight
        @logger.info({preflight: preflight_h}) if preflight_h.is_a?(Hash) && !preflight_h.empty?
      rescue => error
        @logger.error({preflight: error})
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
          params[:offset] = position
          result = resource_batch params
        rescue => error
          @logger.error({metadata_extraction: error})
          sleep 10
          redo
        end

        result.each do |i|

          unless valid? i
            @logger.info log_entry_core(position, i.uuid).merge({valid: false})
            position += 1
            next
          end

          begin
            act_h = act i
            act_log_entry = log_entry_core(position, i.uuid)
            act_log_entry.merge!(act_h) if act_h.is_a?(Hash) && !act_h.empty?
            @logger.info act_log_entry
          rescue => error
            act_error_log_entry = log_entry_core(position, i.uuid)
            act_error_log_entry.merge!({error: error})
            @logger.error act_error_log_entry
          end

          position += 1
          qty_obtained += 1

          break if qty_obtained == qty_to_find
        end

        break if qty_obtained == qty_to_find

        # handle error response
        if result.empty?
          @logger.error({pure_record: position, metadata_extraction: 'No data'})
          position += 1
        end

        sleep delay
      end

      log_records_available records_available

    end

    private

    def log_records_available(count)
      @logger.info({pure_records_available: count})
    end

    # @return [Hash]
    def log_entry_core(pure_record, pure_uuid)
      {pure_record: pure_record, pure_uuid: pure_uuid}
    end

    def resource_count(params)
      params = params.dup
      resource_class = "Puree::Extractor::#{Puree::Util::String.titleize(@resource_type)}"
      Object.const_get(resource_class).new(@pure_config).count(params)
    end

    def resource_batch(params)
      params = params.dup
      resource_method = "#{@resource_type}s".to_sym
      client = Puree::REST::Client.new(@pure_config).send resource_method
      response = client.all_complex params: params
      Puree::XMLExtractor::Collection.send resource_method, response.to_s
    end
  end
end