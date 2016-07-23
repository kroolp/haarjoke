require 'haar_joke/version'
require 'haar_joke/joke'
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
    @config = use_custom_file
    create_joke
  end

  private

  def self.use_custom_file
    file_path = Rails.root.join('config/haar_joke.yml')
    YAML.load_file(file_path)
  rescue
    raise 'YAML file missing. Custom method requires a config/haar_joke.yml
    file. For non custom jokes, use HaarJoke.create_joke'
  end

  def self.config
    @config
  end
end
