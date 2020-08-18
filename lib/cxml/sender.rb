module CXML
  class Sender
    attr_accessor :credential
    attr_accessor :user_agent

    def initialize(data={})
      if data.kind_of?(Hash) && !data.empty?
        @credential = generate_credentials([data['Credential']].flatten)
        @user_agent = data['UserAgent']
      end
    end

    def render(node)
      node.Sender do |n|
        n.UserAgent(@user_agent)
        @credential.render(n)
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
