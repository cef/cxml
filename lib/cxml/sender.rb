# frozen_string_literal: true

module CXML
  # From CXML User Guide: This element allows the receiving party to identify and
  # authenticate the party that opened the HTTP connection. It contains a stronger
  # authentication Credential than the ones in the From or To elements, because
  # the receiving party must authenticate who is asking it to perform work.
  class Sender
    attr_accessor :credential, :user_agent

    def initialize(data = {})
      return unless data.is_a?(Hash) || data.empty?

      @credential = Credential.generate_multiple([data['Credential']].flatten)
      @user_agent = data['UserAgent']
    end

    def render(node)
      node.Sender do |n|
        @credential.render(n)
        n.UserAgent(@user_agent)
      end
      node
    end
  end
end
