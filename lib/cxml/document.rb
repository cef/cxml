# frozen_string_literal: true

module CXML
  class Document
    attr_accessor :version
    attr_accessor :payload_id
    attr_accessor :timestamp
    attr_accessor :xml_lang

    attr_accessor :header
    attr_accessor :request
    attr_accessor :response
    attr_accessor :punch_out_order_message

    def initialize(data = {})
      if data.kind_of?(Hash) && !data.empty?
        @version = data['version'] || CXML::Protocol.version
        @payload_id = data['payloadID']
        @xml_lang = data['xml:lang'] if data['xml:lang']

        if data['timestamp']
          begin
            # If timestamp is received as standard ISO 8601 format (as most should), we continue normally
            # e.g '2026-01-13T13:02:41'.
            @timestamp = Time.parse(data['timestamp'])

            # We catch this failure to handle a timestamp we want to allow but receive in a slightly different format,
            # and change it to ISO 8601.
            # e.g '1/13/2026 1:02:41 PM' => '2026-01-13T13:02:41'
          rescue ArgumentError => e
            if e.message.include?('mon out of range')
              @timestamp = Time.iso8601(to_iso8601(data['timestamp']))
            else
              raise
            end
          end
        end

        if data['Header']
          @header = CXML::Header.new(data['Header'])
        end

        if data['Request']
          @request = CXML::Request.new(data['Request'])
        end

        if data['Response']
          @response = CXML::Response.new(data['Response'])
        end

        if data['Message'] && data['Message']['PunchOutOrderMessage']
          @punch_out_order_message = CXML::PunchOutOrderMessage.new(data['Message']['PunchOutOrderMessage'])
        end
      end
    end

    # def setup
    #   @version    = CXML::Protocol.version
    #   @timestamp  = Time.now.utc
    #   @payload_id = "#{@timestamp.to_i}.process.#{Process.pid}@domain.com"
    # end

    # Check if document is request
    # @return [Boolean]
    def request?
      !request.nil?
    end

    # Check if document is a response
    # @return [Boolean]
    def response?
      !response.nil?
    end

    # Check if document is a punch out order message
    # @return [Boolean]
    def punch_out_order_message?
      !punch_out_order_message.nil?
    end

    def build_attributes
      attrs = {'version' => version, 'payloadID' => payload_id, 'timestamp' => Time.now.utc.iso8601}
      attrs.merge!({'xml:lang' => xml_lang})
      attrs
    end

    def render
      node = CXML.builder
      node.cXML(build_attributes) do |doc|
        doc.Header { |n| @header.render(n) } if @header
        @request.render(node) if @request
        @response.render(node) if @response
        @punch_out_order_message.render(node) if punch_out_order_message?
      end
      node
    end

    # Converts a string in `MM/DD/YYYY hh:mm:ss AM/PM` format
    # to an ISO 8601 formatted string.
    #
    # @param str [String] the datetime string to convert, e.g., '01/28/2026 09:15:30 AM'
    # @return [String] the ISO 8601 representation of the datetime, e.g., '2026-01-28T09:15:30+00:00'
    #
    # @example Convert a US morning datetime
    #   to_iso8601('01/28/2026 09:15:30 AM')
    # => '2026-01-28T09:15:30+00:00'
    def to_iso8601(str)
      DateTime.strptime(str, '%m/%d/%Y %I:%M:%S %p').iso8601
    end
  end
end
