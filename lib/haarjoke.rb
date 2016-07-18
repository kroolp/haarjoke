require "haarjoke/version"
require 'json'
require 'open-uri'

module Haarjoke
  class Joke
    attr_reader :text

    def text
      @text = generate_joke
    end


    private
    def generate_joke
      joke = ""
      chuck_norris = false

      until chuck_norris
        joke = get_joke_from_api
        return "Zzzzzzzzzzzzz. Haar is sleeping." if joke.nil?

        if joke =~ /chuck norris/i
          #let's get rid of the racist, sexist and nasty ones...
          chuck_norris = true unless joke =~ /race|woman|women|gay|black|natives|porn|handicap|god|bible|staring|rape|condom/i
        end
        haar_joke = joke.gsub(/chuck norrises/i, "Haars")
        haar_joke = joke.gsub(/chuck norris\'s/i, "Haar's")
        haar_joke = joke.gsub(/chuck norris/i, "Haar")
        haar_joke = haar_joke.gsub(/penis|dick/i, "axe")
        haar_joke = haar_joke.gsub(/american|america/i, "Daein")
        haar_joke = haar_joke.gsub(/beat/i, "sleep")
        haar_joke = haar_joke.gsub(/superman/i, "Chuck Norris")
        haar_joke = haar_joke.gsub(/beard/i, "eyepatch")
        haar_joke = haar_joke.gsub(/pick\-up/i, "wyvern")
      end
      return haar_joke
    end


    def get_joke_from_api
      api_url = "http://api.icndb.com/jokes/random"

      begin
        open(api_url) do |stream|
          joke = JSON.parse(stream.read)
        end
        return joke['value']['joke']
      rescue StandardError
        return nil
      end
    end
  end
end
