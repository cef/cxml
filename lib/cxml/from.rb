# frozen_string_literal: true

module CXML
  # From CXML User Guide: This element identifies the originator of the cXML request.
  class From
    attr_accessor :credential, :user_agent

    # On initialize, we build the Credentials and the UserAgent.
    # This is called when ingesting a CXML object and when building one.
    # @param data [Hash] The From data for the CXML object that's being handled.
    def initialize(data = {})
      return unless data.is_a?(Hash) || data.empty?

      @credential = Credential.generate_multiple([data['Credential']].flatten)
      @user_agent = data['UserAgent']
    end

    # This is only called when building a CXML object, not when ingesting one.
    # @param node [Nokogiri::XML::Builder] The XML object being built in Nokogiri.
    # @return [Nokogiri::XML::Builder] The XML object, with added From attribute.
    def render(node)
      node.From do |n|
        @credential.render(n)
        n.UserAgent(@user_agent)
      end
      node
    end
  end
end
