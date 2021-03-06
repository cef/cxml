require 'spec_helper'

describe CXML::Header do

  shared_examples_for :render_defaults do
    it "returns xml content" do
      output_xml.should_not be_nil
    end

    it 'returns xml content with with required xml nodes' do
      header_output_data["To"].should_not be_empty
      header_output_data["From"].should_not be_empty
      header_output_data["Sender"].should_not be_empty
    end

  end

  it { should respond_to :from? }
  it { should respond_to :to? }
  it { should respond_to :sender? }
  it { should respond_to :render}

  let(:parser) { CXML::Parser.new }
  let(:doc) { CXML::Document.new(data) }
  let(:builder) {doc.render}
  let(:header) { doc.header }
  let(:data) { parser.parse(fixture('request_doc.xml')) }

  describe '#initialize' do
    it "sets the mandatory attributes" do
      header.to.should be_instance_of(CXML::Credential)
      header.from.should be_instance_of(CXML::Credential)
      header.sender.should be_instance_of(CXML::Sender)
    end
  end

  describe '#render' do

    let(:output_xml) {builder.to_xml}
    let(:output_data) {parser.parse(output_xml)}
    let(:header_output_data) { output_data['Header'] }
    let(:from_identity) {header_output_data["From"]["Credential"]["Identity"] }
    let(:to_identity) {header_output_data["To"]["Credential"]["Identity"] }

    include_examples :render_defaults

    context "when the header is rendered as part of a response, i.e. punchout order message" do
      let(:data) { parser.parse(fixture('punch_out_order_message_doc.xml')) }
      it "will swap the to and from attributes" do
        from_identity.should eq(header.to.identity)
        to_identity.should eq(header.from.identity)
      end
    end

    context "when the header is rendered as not a response" do
      let(:data) { parser.parse(fixture('request_doc.xml')) }
      it "will NOT swap the to and from attributes" do
        from_identity.should eq(header.from.identity)
        to_identity.should eq(header.to.identity)
      end
    end

  end

end

