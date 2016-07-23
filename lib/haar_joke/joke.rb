module HaarJoke
  # This class can be used to create joke instances. The .text method
  # returns the joke text.
  class Joke
    attr_reader :text

    def text
      @text = generate_joke
    end

    private

    def generate_joke
      joke = joke_from_api
      !joke.nil? ? substitute_terms(joke) : 'Zzzzzzzzzzzzzzz. Haar is sleeping.'
    end

    def joke_from_api
      api_url = 'http://api.icndb.com/jokes/random'
      joke = ''

      open(api_url) do |stream|
        joke = JSON.parse(stream.read)
      end

      joke = joke['value']['joke']
      accept_joke?(joke) ? joke : joke_from_api

    rescue StandardError
      nil
    end

    def accept_joke?(joke)
      filters = HaarJoke.config['filters'].join('|')
      joke.match(/#{filters}/i).nil?
    end

    def substitute_terms(joke)
      substitutions = HaarJoke.config['substitutions']
      substitutions.each do |key, value|
        joke.gsub!(/#{key}/i, value)
      end
      joke
    end
  end
end
