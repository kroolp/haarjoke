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

  describe 'Haarjoke.create_joke' do
    it 'provides a shortcut that creates a Joke object and returns the text' do
      expect(HaarJoke.create_joke).to match(/Haar/)
    end
  end

  describe HaarJoke::Joke do
    it 'can be used to create HaarJoke::Joke objects' do
      expect(HaarJoke::Joke.new).to be_a(HaarJoke::Joke)
    end

    let(:joke) { HaarJoke::Joke.new }

    describe '.text' do
      it 'returns a joke about Haar when called' do
        expect(joke.text).to match(/Haar/)
      end
    end

    describe 'Substitutions' do
      it 'replaces Chuck Norris with Haar' do
        expect(joke.instance_eval { generate_joke })
          .to eql('Haar wears Haar pajamas.')
      end

      it 'replaces various real world terms with Fire Emblem terms' do
        stub_request(:get, /api.icndb.com/)
          .to_return(status: 200,
                     body: '{ "type": "success",
                              "value": {
                              "joke": "Chuck Norris america pick-up"
                              }
                            }',
                     headers: {})
        expect(joke.text).to eql('Haar Daein wyvern')
      end
    end

    describe 'private methods' do
      describe 'joke_from_api' do
        context 'when api is available' do
          it 'returns a joke containing the word Haar' do
            expect(joke.instance_eval { joke_from_api })
              .to eq('Chuck Norris wears Haar pajamas.')
          end
        end

        context 'when api is not available' do
          it 'returns the default string' do
            stub_request(:get, /api.icndb.com/)
              .to_return(status: 404,
                         body: '{}',
                         headers: {})
            expect(joke.instance_eval { joke_from_api }).to eq(nil)
          end
        end
      end

      describe 'accept_joke?' do
        it 'does not accept jokes from the filters list' do
          expect(joke.instance_eval { accept_joke?('woman') }).to eql(false)
        end
      end
    end
  end
end
