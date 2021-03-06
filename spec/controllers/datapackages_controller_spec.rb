require 'rails_helper'

describe DatapackagesController do
  describe 'show' do
    context "unauthenticated request" do
      it "returns the requested datapackage and file" do
        dp = Datapackage.create

        get :show, params: { id: dp.id }

        data = JSON.parse response.body

        expect(response.status).to eq(401)
        expect(data["error"]).to eq("Not authorized")
      end
    end

    context "authenticated request" do
      let!(:api_account) { ApiAccount.create }

      it "returns the requested datapackage and file" do
        dp = Datapackage.new

        original_zip = File.join(ENV.fetch('ROOT_PATH'), 'lib', 'datapackage', 'datapackage-1566177582.zip')
        cloned_zip = FakeFS::FileSystem.clone(original_zip)

        dp.file.attach(io: File.open(cloned_zip.first), filename: 'datapackage-1566177582.zip', content_type: 'application/zip')
        dp.save

        request.headers.merge! "Authorization" => "Token token=#{api_account.api_key}"
        get :show, params: { id: dp.id }

        data = JSON.parse response.body

        expect(data["data"]["attributes"]["name"]).to eq("datapackage-1566177582.zip")
        expect(data["data"]["attributes"]["url"]).to be_present
      end
    end
  end

  describe 'create' do
    context "unauthenticated request" do
      it "returns the requested datapackage and file" do

        post :create

        data = JSON.parse response.body

        expect(response.status).to eq(401)
        expect(data["error"]).to eq("Not authorized")
      end
    end

    context "authenticated request" do
      let!(:api_account) { ApiAccount.create }
      it 'creates a datapackage' do
        allow(Extractor).to receive(:run)

        request.headers.merge! "Authorization" => "Token token=#{api_account.api_key}"
        expect{ post :create }.to change(Datapackage, :count).by 1
      end

      it 'kicks off extractor' do
        allow(Extractor).to receive(:run)

        request.headers.merge! "Authorization" => "Token token=#{api_account.api_key}"
        post :create

        expect(Extractor).to have_received(:run)

        data = JSON.parse response.body
        expect(data["links"]["self"]).to eq(datapackage_url(id: Datapackage.last.id))
      end

      it 'renders json with datapackage info' do
        allow(Extractor).to receive(:run)
        datapackage = Datapackage.create

        allow(Datapackage).to receive(:new).and_return(datapackage)

        request.headers.merge! "Authorization" => "Token token=#{api_account.api_key}"
        post :create

        data = JSON.parse response.body
        expect(data["links"]["self"]).to eq(datapackage_url(id: datapackage.id))
        expect(data["data"][0]["id"]).to eq(datapackage.id)
      end
    end
  end
end