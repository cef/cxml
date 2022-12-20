# frozen_string_literal: true

module CXML
  # From CXML User Guide: This element identifies the originator of the cXML request.
  class From
    attr_accessor :credential, :user_agent

    def initialize(data = {})
      return unless data.is_a?(Hash) || data.empty?

      @credential = generate_credentials([data['Credential']].flatten)
      @user_agent = data['UserAgent']
    end

    def render(node)
      node.From do |n|
        @credential.render(n)
        n.UserAgent(@user_agent)
      end
      node
    end

    private

    # This can return two data types to provide backwards compatibility.
    # Previous behaviour was always to receive and return one credential, thus
    # this behaviour is unchanged. We can now also accept and return several
    # credentials in an array.
    def generate_credentials(credential_array)
      credentials = credential_array.map do |single_credential_hash|
        CXML::Credential.new(single_credential_hash)
      end
      credentials.compact!
      credentials.count == 1 ? credentials.first : credentials
    end
  end
end
