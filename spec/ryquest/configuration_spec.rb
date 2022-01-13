# frozen_string_literal: true

RSpec.describe Ryquest::Configuration do
  describe '#content_type' do
    it 'should be form by default' do
      expect(subject.content_type).to eq :form
    end

    it 'should accept valid value' do
      %i[json form].each do |value|
        expect { subject.content_type = value }.not_to raise_error
      end
    end

    it 'should reject invalid value' do
      expect { subject.content_type = :invalid }.to raise_error ArgumentError
    end
  end
end
