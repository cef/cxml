# Clients send requests for operations. Only one Request element is allowed for each
# cXML envelope element, which simplifies the server implementations, because no
# demultiplexing needs to occur when reading cXML documents. The Request element
# can contain virtually any type of XML data.

module CXML
  class Request
    attr_accessor :deployment_mode
    attr_accessor :punch_out_setup_request
    attr_accessor :order_request

    def initialize(data={})
      if data.kind_of?(Hash) && !data.empty?
        @id = data['id']
        @deployment_mode = data['deploymentMode']
        @punch_out_setup_request = CXML::PunchOutSetupRequest.new(data['PunchOutSetupRequest'])
        order_request_data = data['OrderRequest']
        @order_request = CXML::OrderRequest.new(order_request_data) if order_request_data && !order_request_data.empty?
      end
    end

    # NOTE - No need to implement this yet as we don't render requests
    def render(node)
    end

  end
end
