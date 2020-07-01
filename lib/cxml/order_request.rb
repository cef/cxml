module CXML
  class OrderRequest
    attr_accessor :order_request_header
    attr_accessor :item_out
    attr_accessor :xml

    def initialize(data={})
      @xml = data
      if data.kind_of?(Hash) && !data.empty?
        @order_request_header = CXML::OrderRequestHeader.new(data['OrderRequestHeader']) if data['OrderRequestHeader']
        @item_out = CXML::ItemOut.new(data['ItemOut']) if data['ItemOut']
      end
    end

    def valid?
      return false unless Nokogiri::XML(@xml.to_xml).errors.empty?

      item_out? && @order_request_header.ship_to? && @order_request_header.bill_to? && @order_request_header.contact? && @order_request_header.money?
    end

    def item_out?
      !@item_out.nil?
    end
  end
end