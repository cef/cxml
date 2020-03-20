#       <ItemDetail>
#         <Description xml:lang="en">AGENDA MAGAZINE RACK A4 CHARCOAL 25990</Description>
#         <UnitOfMeasure>EA</UnitOfMeasure>
#         <UnitPrice> <Money currency="GBP">5.35</Money> </UnitPrice>
#       </ItemDetail>

module CXML
  class ItemDetail
    attr_accessor :description
    attr_accessor :unit_of_measure
    attr_accessor :unit_price
    attr_accessor :unspsc
    attr_accessor :lead_time

    def initialize(data={})
      if data.kind_of?(Hash) && !data.empty?
        @description = data['Description']
        @unit_of_measure = data['UnitOfMeasure']
        @unspsc = data['ClassificationUnspsc']
        @unit_price = CXML::Money.new(data['UnitPrice']['Money'])
        @lead_time = data['LeadTime']
      end
    end

    def render(node)
      node.ItemDetail do
        node.Description(description)
        node.UnitOfMeasure(unit_of_measure)
        node.UnitPrice{unit_price.render(node)}
        node.Classification(unspsc, {'domain' => 'UNSPSC'}) unless unspsc.blank?
        node.LeadTime(lead_time)
      end
    end

  end
end
