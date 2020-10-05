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

    def initialize(data={})
      if data.kind_of?(Hash) && !data.empty?
        @version = data['version'] || CXML::Protocol.version
        @payload_id = data['payloadID']
        @xml_lang = data['xml:lang'] if data['xml:lang']

        if data['timestamp']
          @timestamp = Time.parse(data['timestamp'])
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
        doc.Header { |n| @header.render(n, punch_out_order_message?) } if @header
        @request.render(node) if @request
        @response.render(node) if @response
        @punch_out_order_message.render(node) if punch_out_order_message?
      end
      node
    end
  end
end
