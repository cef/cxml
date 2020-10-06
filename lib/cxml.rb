# require 'cxml/version'
require 'cxml/errors'
require 'time'
require 'nokogiri'

# Gem module starts by loading all of the classes containing the rest of the gem behaviour.
module CXML
  autoload :BillTo,                       'cxml/bill_to'
  autoload :Contact,                      'cxml/contact'
  autoload :Protocol,                     'cxml/protocol'
  autoload :Document,                     'cxml/document'
  autoload :Header,                       'cxml/header'
  autoload :Credential,                   'cxml/credential'
  autoload :CredentialMac,                'cxml/credential_mac'
  autoload :Sender,                       'cxml/sender'
  autoload :ShipTo,                       'cxml/ship_to'
  autoload :Status,                       'cxml/status'
  autoload :OrderRequest,                 'cxml/order_request'
  autoload :OrderRequestHeader,           'cxml/order_request_header'
  autoload :Request,                      'cxml/request'
  autoload :Response,                     'cxml/response'
  autoload :Parser,                       'cxml/parser'
  autoload :PunchOutSetupRequest,         'cxml/punch_out_setup_request'
  autoload :PunchOutSetupResponse,        'cxml/punch_out_setup_response'
  autoload :PunchOutOrderMessage,         'cxml/punch_out_order_message'
  autoload :PunchOutOrderMessageHeader,   'cxml/punch_out_order_message_header'
  autoload :ItemId,                       'cxml/item_id'
  autoload :ItemIn,                       'cxml/item_in'
  autoload :ItemOut,                      'cxml/item_out'
  autoload :ItemDetail,                   'cxml/item_detail'
  autoload :Money,                        'cxml/money'

  def self.parse(str)
    CXML::Parser.new.parse(str)
  end

  # Build the initial XML object which will be used to add the CXML structure into.
  # @return [Nokogiri::XML::Builder] containing basic CXML specification
  def self.builder
    xml_builder = Nokogiri::XML::Builder.new(:encoding => "UTF-8")
    add_dtd!(xml_builder)
    xml_builder
  end

  # Use Nokogiri's create_internal_subset method to add the DTD at this stage.
  # This method destructively changes the builder it's run on.
  # @return [Nokogiri::XML::DTD]
  def self.add_dtd!(xml_builder)
    xml_builder.doc.create_internal_subset('cXML', nil, "http://xml.cxml.org/schemas/cXML/#{CXML::Protocol.version}/cXML.dtd")
  end
end
