require 'haarjoke/version'
require 'json'
require 'open-uri'
require 'yaml'

# This module contains a Joke class for creating jokes featuring the fire
# Emblem Haar (using Chuck Norris jokes from http://api.icndb.com).
# It also contains a method for creating a joke and getting returning the joke
module Haarjoke
  def self.create_joke
    joke = Joke.new
    joke.text
  end

  # This class can be used to create joke instances. The .text method
  # returns the joke text.
  class Joke
    attr_reader :text

    file_path = File.join(File.dirname(__FILE__),'haarjoke/haarjoke.yml')
    DATA = YAML.load_file(file_path)

    FILTERS = DATA['filters'].join('|')
    SUBSTITUTIONS = DATA['substitutions']

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
      joke.match(/#{FILTERS}/i).nil?
    end

    def substitute_terms(joke)
      SUBSTITUTIONS.each do |key, value|
        joke.gsub!(/#{key}/i, value)
      end
      joke
    end
  end
end
