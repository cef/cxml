# frozen_string_literal: true

module CXML
  # From CXML User Guide: This element allows the receiving party to identify and
  # authenticate the party that opened the HTTP connection. It contains a stronger
  # authentication Credential than the ones in the From or To elements, because
  # the receiving party must authenticate who is asking it to perform work.
  class Sender
    attr_accessor :credential, :user_agent

    # On initialize, we build the Credentials and the UserAgent.
    # This is called when ingesting a CXML object and when building one.
    # @param data [Hash] The Sender data for the CXML object that's being handled.
    def initialize(data = {})
      return if !data.is_a?(Hash) || data.empty?

      @credential = Credential.generate_multiple([data['Credential']])
      @user_agent = data['UserAgent']
    end

    # This is only called when building a CXML object, not when ingesting one.
    # @param node [Nokogiri::XML::Builder] The XML object being built in Nokogiri.
    # @return [Nokogiri::XML::Builder] The XML object, with added Sender attribute.
    def render(node)
      node.Sender do |n|
        @credential.each{ |c| c.render(n) }
        n.UserAgent(@user_agent)
      end
      node
    end
  end
end
