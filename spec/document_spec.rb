# frozen_string_literal: true

require 'spec_helper'

describe CXML::Document do

  shared_examples_for :document_has_mandatory_values do
    it 'sets the mandatory attributes' do
      doc.version.should eq(CXML::Protocol::VERSION)
      doc.payload_id.should_not be_nil
    end
  end

  shared_examples_for :document_has_a_header do
    it 'sets the header attributes' do
      doc.header.should be_a CXML::Header
    end
  end

  shared_examples_for :document_has_a_timestamp do
    it 'sets the timestamp attributes' do
      doc.timestamp.should be_a Time
      doc.timestamp.should eq(Time.parse('2012-09-04T02:37:49-05:00'))
    end
  end

  shared_examples_for :document_render_defaults do
    it 'returns xml content' do
      output_xml.should_not be_nil
    end

    it 'returns xml content with a header xml node' do
      output_data['Header'].should_not be_empty
    end
  end

  let(:parser) { CXML::Parser.new }

  it { should respond_to :version }
  it { should respond_to :payload_id }
  it { should respond_to :timestamp }
  it { should respond_to :header }
  it { should respond_to :request }
  it { should respond_to :response }
  it { should respond_to :punch_out_order_message}
  it { should respond_to :xml_lang}
  it { should respond_to :request?}
  it { should respond_to :response?}
  it { should respond_to :punch_out_order_message?}
  it { should respond_to :build_attributes}

  describe '#initialize' do

    let(:doc) { CXML::Document.new(data) }
    let(:data) { parser.parse(fixture('request_doc.xml')) }

    context 'when a request document is passed' do

      include_examples :document_has_mandatory_values
      include_examples :document_has_a_header
      include_examples :document_has_a_timestamp

      it 'sets the correct document node attributes' do
        doc.header.should be_a CXML::Header
        doc.request.should be_a CXML::Request

        doc.response.should be_nil
        doc.punch_out_order_message.should be_nil
      end
    end

    context 'when a response document is passed' do

      let(:data) { parser.parse(fixture('response_status_200.xml')) }
      include_examples :document_has_mandatory_values
      include_examples :document_has_a_timestamp

      it 'sets the correct document node attributes' do
        doc.response.should be_a CXML::Response

        doc.header.should be_nil
        doc.request.should be_nil
        doc.punch_out_order_message.should be_nil
      end
    end


    context 'when a punch out order message is passed' do

      let(:data) { parser.parse(fixture('punch_out_order_message_doc.xml')) }
      include_examples :document_has_mandatory_values
      include_examples :document_has_a_header
      include_examples :document_has_a_timestamp

      it 'sets the correct document node attributes' do
        doc.header.should be_a CXML::Header
        doc.punch_out_order_message.should be_a CXML::PunchOutOrderMessage

        doc.request.should be_nil
        doc.response.should be_nil
      end
    end

    context 'when the timestamp is received as ISO 8601 format' do
      it 'accepts an ISO 8601 datetime' do
        expect(doc.timestamp).to be_a(Time)
      end
    end

    context 'when the timestamp is received as RFC 1123 format' do
      it 'accepts a RFC 1123 format datetime' do
        data['timestamp'] = 'Tue, 13 Jan 2026 13:02:41 GMT'
        expect(doc.timestamp).to be_a(Time)
      end
    end

      context 'when the timestamp is received as RFC 2822 format' do
        it 'accepts a RFC 2822 format datetime' do
          data['timestamp'] = 'Tue, 13 Jan 2026 13:02:41 +0000'
          expect(doc.timestamp).to be_a(Time)
        end
      end

    context 'when the timestamp is received as SQL standard format' do
      it 'accepts an SQL standard format datetime' do
        data['timestamp'] = '2026-01-13 13:02:41'
        expect(doc.timestamp).to be_a(Time)
      end
    end

    context 'when the timestamp is received as custom US format' do
      it 'accepts a custom US format datetime' do
        data['timestamp'] = '1/13/2026 1:02:41 PM'
        expect(doc.timestamp).to be_a(Time)
      end
    end
  end

  describe '#render' do

    let(:doc) { CXML::Document.new(data) }
    let(:builder) {doc.render}
    let(:output_xml) {builder.to_xml}
    let(:output_data) {parser.parse(output_xml)}

    it { should respond_to :render}

    context 'when a request document is rendered' do
      let(:data) { parser.parse(fixture('request_doc.xml')) }
      include_examples :document_render_defaults
    end

    context 'when a valid response is rendered' do
      let(:data) { parser.parse(fixture('response_status_200.xml')) }
      it 'returns xml content' do
        output_xml.should_not be_nil
      end

      it 'outputs the response with a valid status code' do
        output_data['Response'].should_not be_empty
        output_data['Response']['Status']['code'].should == '200'
      end

      it 'outputs the punch out setup response' do
        output_data['PunchOutSetupResponse'].should_not be_empty
      end
    end

    context 'when a invalid response is rendered' do
      let(:data) { parser.parse(fixture('response_status_400.xml')) }
      it 'returns xml content' do
        output_xml.should_not be_nil
      end

      it 'outputs the response with a valid status code' do
        output_data['Response'].should_not be_empty
        output_data['Response']['Status']['code'].should == '400'
      end
    end

    context 'when a punch out order message document is rendered' do
      let(:data) { parser.parse(fixture('punch_out_order_message_doc.xml')) }
      include_examples :document_render_defaults

      it 'outputs the punch out order message xml' do
        output_data['Message'].should_not be_empty
        output_data['Message']['PunchOutOrderMessage'].should_not be_empty
      end
    end
  end

  describe '#build_attributes' do
    let(:data) { parser.parse(fixture('punch_out_order_message_doc.xml')) }
    let(:doc) { CXML::Document.new(data) }

    it 'returns a hash' do
      doc.build_attributes.should include('version')
    end
  end

  describe '#to_iso8601' do
    let(:doc) { described_class.new }
    it 'converts a custom us datetime string to ISO 8601' do
      expect(doc.to_iso8601('01/28/2026 09:15:30 AM')).to eq('2026-01-28T09:15:30+00:00')
    end

    it 'raises an ArgumentError for incorrect format' do
      expect { doc.to_iso8601('2026-01-28 09:15:30') }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError for impossible dates' do
      expect { doc.to_iso8601('02/30/2026 10:00:00 AM') }.to raise_error(ArgumentError)
    end

    it 'handles edge case dates/times like midnight on new year correctly' do
      expect(doc.to_iso8601('01/01/2026 12:00:00 AM')).to eq('2026-01-01T00:00:00+00:00')
    end
  end
end
