# frozen_string_literal: true

module CXML
  # From CXML User Guide: This element identifies the destination of the cXML request.
  class To
    attr_accessor :credential

    # On initialize, we build the Credentials and the UserAgent.
    # This is called when ingesting a CXML object and when building one.
    # @param data [Hash] The To data for the CXML object that's being handled.
    def initialize(data = {})
      return if !data.is_a?(Hash) || data.empty?

      @credential = Credential.generate_multiple([data['Credential']])
    end

    # This is only called when building a CXML object, not when ingesting one.
    # @param node [Nokogiri::XML::Builder] The XML object being built in Nokogiri.
    # @return [Nokogiri::XML::Builder] The XML object, with added To attribute.
    def render(node)
      node.To do |n|
        @credential.each{ |c| c.render(n) }
      end
      node
    end
  end
end
