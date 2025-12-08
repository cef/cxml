require 'spec_helper'

describe CXML::PunchOutSetupRequest do

  it { is_expected.to respond_to(:browser_form_post_url) }
  it { is_expected.to respond_to(:supplier_setup_url) }

  describe '#initialize' do
    context "when the request data comes with a SupplierSetup block" do
      let(:parser)  { CXML::Parser.new }
      let(:data)    { parser.parse(fixture('punch_out_setup_request_doc.xml')) }
      let(:doc)     { CXML::Document.new(data) }
      let(:request) { doc.request }
      let(:punch_out_setup_request) { request.punch_out_setup_request }

      it "sets the mandatory attributes including the SupplierSetup" do
        expect(punch_out_setup_request.browser_form_post_url).not_to be_nil
        expect(punch_out_setup_request.supplier_setup_url).not_to be_nil
      end
    end

    context "when the request data comes without a SupplierSetup block" do
      let(:parser)  { CXML::Parser.new }
      let(:data)    { parser.parse(fixture('punch_out_setup_request_doc_without_supplier.xml')) }
      let(:doc)     { CXML::Document.new(data) }
      let(:request) { doc.request }
      let(:punch_out_setup_request) { request.punch_out_setup_request }

      it "sets the mandatory attributes without the SupplierSetup" do
        expect(punch_out_setup_request.browser_form_post_url).not_to be_nil
        expect(punch_out_setup_request.supplier_setup_url).to be_nil
      end
    end
  end
end
