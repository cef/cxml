# frozen_string_literal: true

module CXML
  class Extrinsic
    attr_accessor :name, :value

    def initialize(data={})
      if data.kind_of?(Hash) && !data.empty?
        @name = data['name']
        @value = data['value']
      end
    end

    def render(node)
      node.Extrinsic(@value, { name: @name })
    end
  end
end
