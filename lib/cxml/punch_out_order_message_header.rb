      # <PunchOutOrderMessageHeader operationAllowed="create">
      # <Total> <Money currency="GBP">5.35</Money> </Total>
      # </PunchOutOrderMessageHeader>
module CXML
  class PunchOutOrderMessageHeader
    attr_accessor :money, :shipping

    def initialize(data={})
      if data.kind_of?(Hash) && !data.empty?
        @money = CXML::Money.new(data['Total']['Money']) if data['Total']['Money']
        @shipping = CXML::Shipping.new(data['Shipping']) if data['Shipping']
      end
    end

    def money?
      !money.nil?
    end

    def shipping?
      !shipping.nil?
    end

    def render(node)
      node.PunchOutOrderMessageHeader('operationAllowed' => :create) do |n|
        n.Total { |t| money.render(node) if money? }
        shipping.render(node) if shipping?
      end
    end

  end
end
