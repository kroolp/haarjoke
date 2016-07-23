require 'spec_helper'

RSpec.describe HaarJoke do
  before do
    stub_request(:get, /api.icndb.com/)
      .to_return(status: 200,
                 body: '{ "type": "success",
                          "value": {
                          "joke": "Chuck Norris wears Haar pajamas."
                          }
                        }',
                 headers: {})
  end

  it 'has a version number' do
    expect(HaarJoke::VERSION).not_to be nil
  end

  it 'blah' do
    p allow(HaarJoke).to receive(:blahstuff).and_return("Sam")
    p HaarJoke.blahstuff
  end

  describe '.create_joke' do
    it 'provides a shortcut that creates a Joke object and returns the text' do
      expect(HaarJoke.create_joke).to match(/Haar/)
    end
  end

  describe '.create_custom_joke' do
    let(:custom_joke) { HaarJoke.create_custom_joke }

    # context 'when "config/haar_joke.yml" exists in a rails project' do
    #   it 'replaces @config with values from file' do
    #   end
    # end

    context 'when alternative file does not exist' do
      it 'raises an error' do
        expect { custom_joke }.to raise_error(/YAML file missing/)
      end
    end
  end
end
