module CXML
  class OrderRequest
    attr_accessor :order_request_header
    attr_accessor :items_out
    attr_accessor :xml

    def initialize(data={})
      @xml = data
      if data.kind_of?(Hash) && !data.empty?
        @order_request_header = CXML::OrderRequestHeader.new(data['OrderRequestHeader']) if data['OrderRequestHeader']
        @items_out = []
      end
    end

    def valid?
      return false unless Nokogiri::XML(@xml.to_xml).errors.empty?

      @order_request_header.ship_to? && @order_request_header.bill_to? && @order_request_header.contact? && @order_request_header.money?
    end
  end
end