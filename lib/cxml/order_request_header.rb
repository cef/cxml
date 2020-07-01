module CXML
  class OrderRequestHeader
    attr_accessor :money
    attr_accessor :ship_to
    attr_accessor :bill_to
    attr_accessor :contact

    def initialize(data={})
      if data.kind_of?(Hash) && !data.empty?
        @id = data['orderID']
        @order_date = data['orderDate']
        @money = CXML::Money.new(data['Total']['Money']) if data['Total']['Money']
        @ship_to = CXML::ShipTo.new(data['ShipTo']) if data['ShipTo']
        @bill_to = CXML::BillTo.new(data['BillTo']) if data['BillTo']
        @contact = CXML::Contact.new(data['Contact']) if data['Contact']
        @items_out = []
      end
    end

    def money?
      !@money.nil?
    end

    def ship_to?
      !@ship_to.nil?
    end

    def bill_to?
      !@bill_to.nil?
    end

    def contact?
      !@contact.nil?
    end
  end
end