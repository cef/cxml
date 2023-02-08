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
    attr_accessor :manufacturer_name
    attr_accessor :manufacturer_part_id

    def initialize(data={})
      if data.kind_of?(Hash) && !data.empty?
        @unit_price = CXML::Money.new(data['UnitPrice']['Money'])
        @description = data['Description']
        @unit_of_measure = data['UnitOfMeasure']
        @unspsc = data['ClassificationUnspsc']
        @lead_time = data['LeadTime']
        @manufacturer_name = data['ManufacturerName']
        @manufacturer_part_id = data['ManufacturerPartID']
      end
    end

    def render(node)
      node.ItemDetail do
        node.UnitPrice{unit_price.render(node)}
        node.Description(description, {'xml:lang' => 'en'})
        node.UnitOfMeasure(unit_of_measure)
        node.ManufacturerName(manufacturer_name) if manufacturer_name.present?
        node.ManufacturerPartID(manufacturer_part_id) if manufacturer_part_id.present?
        node.Classification(unspsc, {'domain' => 'UNSPSC'}) unless unspsc.blank?
        node.LeadTime(lead_time) if lead_time.present?
      end
    end

  end
end
