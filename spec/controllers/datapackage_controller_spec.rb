require 'rails_helper'

describe DatapackageController do
  describe 'show' do
    # TODO use FakeFS gem
    it "returns latest datapackage" do
      file_path = File.join(ENV.fetch('ROOT_PATH'), 'lib', 'datapackage', 'datapackage-1566177582.zip')
      dp = Datapackage.new
      dp.file.attach(io: File.open(file_path), filename: 'datapackage-1566177582.zip', content_type: 'application/zip')
      dp.save

      get :show

      data = JSON.parse response.body

      expect(data["data"]["attributes"]["name"]).to eq("datapackage-1566177582.zip")
      expect(data["data"]["attributes"]["url"]).to be_present
    end
  end

  describe 'create' do
    it 'kicks off extractor', perform_enqueued: true do
      allow(Extractor).to receive(:run)

      post :create

      expect(Extractor).to have_received(:run)
    end
  end
end