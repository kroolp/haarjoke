require 'haar_joke/version'
require 'json'
require 'open-uri'
require 'yaml'

# This module contains a Joke class for creating jokes featuring the fire
# Emblem Haar (using Chuck Norris jokes from http://api.icndb.com).
# It also contains a method for creating a joke and getting returning the joke
module HaarJoke
  # load default filters and substitutions
  file_path = File.join(File.dirname(__FILE__), 'haar_joke/haar_joke.yml')
  @config = YAML.load_file(file_path)

  # user can create joke with custom settings
  def self.create_joke
    joke = Joke.new
    joke.text
  end

  # user can create joke with their own file
  def self.create_custom_joke
    customized
    create_joke
  end

  private

  def self.customized
    @config = YAML.load_file(Rails.root.join('config/haar_joke.yml'))
  rescue
    raise 'YAML file missing. Custom method requires a config/haar_joke.yml
    file.'
  end

  def self.config
    @config
  end

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
