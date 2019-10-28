class DatapackageController < ApplicationController

  #TODO: Add API auth
  def show
    render json: DatapackageSerializer.new(Datapackage.last)
  end

  def create
    @datapackage = Datapackage.new

    if @datapackage.save
      Extractor.delay.run(datapackage_id: @datapackage.id)

      render json: {
        links: { self: datapackage_path(@datapackage) },
        data: [{
         type: 'datapackages',
         id: @datapackage.id,
         attributes: {
           created_at: @datapackage.created_at
         }
        }]
      }
    else
      head 422
    end
  end
end