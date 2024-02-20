class HomeController < ApplicationController
  def index
    puts 'a'
    UserPreference.set(:playback_rate, UserPreference.get(:playback_rate) + 1)
  end
end
