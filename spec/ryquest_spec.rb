RSpec.describe Ryquest do
  describe '#configuration' do
    it 'should give access to the configuration object' do
      expect(subject.configuration).to be_a Ryquest::Configuration
    end
  end

  describe '#configure' do
    it 'should permit to change #configuration values in a block' do
      subject.configuration.content_type = :form
      subject.configure { |config| config.content_type = :json }

      expect(subject.configuration.content_type).to eq :json
    end
  end
end
