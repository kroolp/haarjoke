require 'spec_helper'

RSpec.describe HaarJoke::Joke do
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

  let(:joke) { HaarJoke::Joke.new }

  it 'can be used to create HaarJoke::Joke objects' do
    expect(joke).to be_a(HaarJoke::Joke)
  end

   describe '#text' do
    it 'returns a joke about Haar when called' do
      expect(joke.text).to match(/Haar/)
    end
  end

  describe 'Substitution' do
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

    it 'replaces Chuck Norris\'s with Haar\'s' do
      stub_request(:get, /api.icndb.com/)
        .to_return(status: 200,
                   body: '{ "type": "success",
                            "value": {
                            "joke": "Chuck Norris\'s Cake"
                            }
                          }',
                   headers: {})
      expect(joke.text).to eql("Haar's Cake")
    end

    it 'replaces Chuck Norris\' with Haar\'s' do
      stub_request(:get, /api.icndb.com/)
        .to_return(status: 200,
                   body: '{ "type": "success",
                            "value": {
                            "joke": "Chuck Norris\' Cake"
                            }
                          }',
                   headers: {})
      expect(joke.text).to eql("Haar's Cake")
    end

    it 'replaces any leftover Chucks with Haar' do
      stub_request(:get, /api.icndb.com/)
        .to_return(status: 200,
                   body: '{ "type": "success",
                            "value": {
                            "joke": "If Chuck Norris were a calendar, every month would be named Chucktober, and every day he\'d kick your ass."
                            }
                          }',
                   headers: {})
      expect(joke.text).to eql("If Haar were a calendar, every month would be named Haartober, and every day he'd kick your ass.")
    end

    it 'replaces any leftover Norrisses with Haar' do
      stub_request(:get, /api.icndb.com/)
        .to_return(status: 200,
                   body: '{ "type": "success",
                            "value": {
                            "joke": "Chuck Norris something Norris"
                            }
                          }',
                   headers: {})
      expect(joke.text).to eql("Haar something Haar")
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
        expect(joke.instance_eval { accept_joke?('woman Chuck Norris') })
          .to eql(false)
      end

      it 'does not accept jokes that don\'t contain the full term Chuck Norris' do
        expect(joke.instance_eval { accept_joke?('Chuck') }).to eql(false)
      end
    end

    describe 'subsitute terms' do
      it 'replaces &quot; with quote mark' do
        expect(joke.instance_eval { substitute_terms("It defined &quot;victim&quot; as") })
          .to eql("It defined \"victim\" as")
      end
    end
  end
end
