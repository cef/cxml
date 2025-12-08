module CXML
  class PunchOutSetupRequest
    attr_accessor :browser_form_post_url
    attr_accessor :supplier_setup_url
    attr_accessor :buyer_cookie

    def initialize(data={})
      return unless data.is_a?(Hash) && data.any?

      @browser_form_post_url = data['BrowserFormPost']['URL']
      @supplier_setup_url    = data['SupplierSetup']['URL'] if data['SupplierSetup']
      @buyer_cookie          = data['BuyerCookie']
    end

    def response_return_url
      browser_form_post_url.blank? ? '' : browser_form_post_url.squish
    end
  end
end
