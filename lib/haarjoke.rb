require 'haarjoke/version'
require 'json'
require 'open-uri'

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

    FILTERS = %w(race woman women gay black natives
                 porn handicap god bible staring rape condom)
              .join('|')
    SUBSTITUTIONS = {
      'chuck norrises' => 'Haars',
      'chuck norris\'s' => 'Haar\'s',
      'chuck norris\'' => 'Haar\'s',
      'chuck norris' => 'Haar',
      'penis' => 'axe',
      'dick' => 'axe',
      'american' => 'Daein',
      'america' => 'Daein',
      'beat' => 'sleep',
      'superman' => 'Chuck Norris',
      'beard' => 'eyepatch',
      'pick-up truck' => 'wyvern',
      'pick-up' => 'wyvern'
    }.freeze

    def text
      @text = generate_joke
    end

    private

    def generate_joke
      joke = joke_from_api
      return 'Zzzzzzzzzzzzzzz. Haar is sleeping.' if joke.nil?

      substitute_terms(joke)
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
