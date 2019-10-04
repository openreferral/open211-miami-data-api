class DatapackageController < ApplicationController

  #TODO: Add API auth
  def show
    render json: DatapackageSerializer.new(Datapackage.last)
  end
end