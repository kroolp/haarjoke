require 'spec_helper'

describe Haarjoke do
  it 'has a version number' do
    expect(Haarjoke::VERSION).not_to be nil
  end

  it "creates Joke objects" do
    joke = Haarjoke::Joke.new
    expect(joke).to be_a(Haarjoke::Joke)
  end

  describe "Joke" do
    describe "#text" do
      it "returns a joke containing the word Haar" do
        joke = Haarjoke::Joke.new
        puts joke.text
        expect(joke.text).to match /Haar/
      end
    end
  end
end
