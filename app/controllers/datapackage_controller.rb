class DatapackageController < ApplicationController

  #TODO: Add API auth
  def show
    render json: DatapackageSerializer.new(Datapackage.last)
  end

  def create
    Extractor.run
    head 202
    # Or another code. Should this return the URL of the file? We probably want to save the Datapackage record here and return the URL, and then in the extractor save the resulting zip with that url
  end
end