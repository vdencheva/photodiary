class HomeController < ApplicationController
  def index
    @photos = Photo.latest(15)
  end
end
