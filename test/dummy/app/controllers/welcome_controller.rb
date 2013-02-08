class WelcomeController < ApplicationController

  def index
    render :text => "HELLO WORLD"
  end
end