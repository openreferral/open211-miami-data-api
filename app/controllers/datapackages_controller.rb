class DatapackagesController < ApplicationController

  #TODO: Add API auth
  def show
    @datapackage = Datapackage.find(params[:id])
    render json: DatapackageSerializer.new(@datapackage)
  end

  def create
    @datapackage = Datapackage.new

    if @datapackage.save
      Extractor.delay.run(datapackage_id: @datapackage.id)

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