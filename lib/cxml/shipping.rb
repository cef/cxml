# <Shipping>
#   <Money currency="USD">10.00</Money>
#   <Description xml:lang="en-US">FedEx 2-day</Description>
# </Shipping>

module CXML
  class Shipping
    attr_accessor :money, :description

    def initialize(data={})
      if data.kind_of?(Hash) && !data.empty?
        @money = CXML::Money.new(data['Money']) if data['Money']
        @description = data['Description'] if data['Description']
      end
    end

    def render(node)
      node.Shipping do |n|
        money.render(n)
        n.Description(description, { 'xml:lang' => 'en' }) unless description.nil? || description == ''
      end
    end
  end
end
