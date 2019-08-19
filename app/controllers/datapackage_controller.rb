class DatapackageController < ApplicationController


  def show
    render json: DatapackageSerializer.new(Datapackage.last)
  end
end