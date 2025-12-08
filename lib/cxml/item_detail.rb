#       <ItemDetail>
#         <Description xml:lang="en">AGENDA MAGAZINE RACK A4 CHARCOAL 25990</Description>
#         <UnitOfMeasure>EA</UnitOfMeasure>
#         <UnitPrice> <Money currency="GBP">5.35</Money> </UnitPrice>
#       </ItemDetail>

module CXML
  class ItemDetail
    attr_accessor :description, :unit_of_measure, :unit_price, :unspsc, :manufacturer_part_id,
                  :manufacturer_name, :lead_time, :extrinsics, :custom_classification

    def initialize(data={})
      if data.kind_of?(Hash) && !data.empty?
        @unit_price = CXML::Money.new(data['UnitPrice']['Money'])
        @description = data['Description']
        @unit_of_measure = data['UnitOfMeasure']
        @unspsc = data['ClassificationUnspsc']
        @custom_classification = data['ClassificationCustom']
        @manufacturer_part_id = data['ManufacturerPartID']
        @manufacturer_name = data['ManufacturerName']
        @lead_time = data['LeadTime']
        @extrinsics = data['Extrinsics']
      end
    end

    def render(node)
      node.ItemDetail do
        node.UnitPrice{unit_price.render(node)}
        node.Description(description, { 'xml:lang' => 'en' })
        node.UnitOfMeasure(unit_of_measure)
        node.Classification(unspsc, { 'domain' => 'UNSPSC' }) unless unspsc.blank?
        node.Classification(custom_classification, { 'domain' => 'CUSTOM' }) unless custom_classification.blank?
        node.ManufacturerPartID(manufacturer_part_id) if manufacturer_part_id.present?
        node.ManufacturerName(manufacturer_name) if manufacturer_name.present?
        node.LeadTime(lead_time) if lead_time.present?
        @extrinsics&.each do |extrinsic_name, extrinsic_value|
          node.Extrinsic(extrinsic_value, 'name' => extrinsic_name)
        end
      end
    end
  end
end
