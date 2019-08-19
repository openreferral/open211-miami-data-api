class DatapackageSerializer
  include FastJsonapi::ObjectSerializer

  attribute :name do |dp|
    dp.file.filename.to_s
  end

  attribute :path do |dp|
    Rails.application.routes.url_helpers.rails_blob_path(dp.file, only_path: true)
  end

  attribute :created_at
end