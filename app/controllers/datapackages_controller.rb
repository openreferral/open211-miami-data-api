class DatapackagesController < ApplicationController
  before_action :authenticate_api_key!

  #TODO: Add API auth
  def show
    @datapackage = Datapackage.find(params[:id])
    render json: DatapackageSerializer.new(@datapackage)
  end

  def create
    @datapackage = Datapackage.new

    if @datapackage.save
      Extractor.run(datapackage_id: @datapackage.id)

      render json: {
        links: { self: datapackage_url(@datapackage) },
        data: [{
         type: 'datapackages',
         id: @datapackage.id,
         attributes: {
           created_at: @datapackage.created_at
         }
        }]
      }
    else
      head 500
    end
  end
end