# require 'cxml/version'
require 'cxml/errors'
require 'time'
require 'nokogiri'

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

  class << self
    mattr_accessor :cxml_version

    def configure(&block)
      yield self
    end

    def parse(str)
      CXML::Parser.new.parse(str)
    end

    def builder
      xml_builder = Nokogiri::XML::Builder.new(:encoding => "UTF-8")
      return xml_builder unless cxml_version.present?
      add_dtd!(xml_builder)
      xml_builder
    end

    def add_dtd!(xml_builder)
      xml_builder.doc.create_internal_subset('cXML', nil, "http://xml.cxml.org/schemas/cXML/#{cxml_version}/cXML.dtd")
    end
  end
end
