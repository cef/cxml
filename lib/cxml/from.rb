# frozen_string_literal: true

module CXML
  # From CXML User Guide: This element identifies the originator of the cXML request.
  class From
    attr_accessor :credential, :user_agent

    def initialize(data = {})
      return unless data.is_a?(Hash) || data.empty?

      @credential = Credential.generate_credentials([data['Credential']].flatten)
      @user_agent = data['UserAgent']
    end

    def render(node)
      node.From do |n|
        @credential.render(n)
        n.UserAgent(@user_agent)
      end
      node
    end
  end
end
