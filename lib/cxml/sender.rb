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

      @credential = generate_credentials([data['Credential']].flatten)
      @user_agent = data['UserAgent']
    end

    def render(node)
      node.Sender do |n|
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
