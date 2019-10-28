require 'rails_helper'

describe DatapackagesController do
  describe 'show' do
    it "returns the requested datapackage and file" do
      dp = Datapackage.new

      original_zip = File.join(ENV.fetch('ROOT_PATH'), 'lib', 'datapackage', 'datapackage-1566177582.zip')
      cloned_zip = FakeFS::FileSystem.clone(original_zip)

      dp.file.attach(io: File.open(cloned_zip.first), filename: 'datapackage-1566177582.zip', content_type: 'application/zip')
      dp.save

      get :show, params: { id: dp.id }

      data = JSON.parse response.body

      expect(data["data"]["attributes"]["name"]).to eq("datapackage-1566177582.zip")
      expect(data["data"]["attributes"]["url"]).to be_present
    end
  end

  describe 'create' do
    it 'kicks off extractor' do
      allow(Extractor).to receive(:run)

      post :create

      expect(Extractor).to have_received(:run)
    end
  end
end