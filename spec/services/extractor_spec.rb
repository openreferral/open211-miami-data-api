require "rails_helper"

describe Extractor do
  describe ".run" do
    it 'transforms extracted files into HSDS zip and creates datapackage record' do
      # stub extract methods
      expect{Extractor.run}.to change(Datapackage, :count).by(1)
      expect(Datapackage.last.file).to be_present
    end
  end

  describe "#extract_providers" do
    it "extracts provider table to CSV" do

      Extractor.new.extract_providers

      file_path = File.join(ENV.fetch("ROOT_PATH"), "tmp", "providers.csv")
      fixture_file_path = File.join(ENV.fetch("ROOT_PATH"), "spec", "fixtures", "extracted_providers.csv")

      rows = []

      File.open(file_path).each_with_index do |line, index|
        rows << line
        break if index > 4
      end

      fixture_rows = []

      File.open(fixture_file_path).each_with_index do |line, index|
        fixture_rows << line
        break if index > 4
      end

      expect(rows).to eq(fixture_rows)

    end
  end

  describe "#extract_provider_taxonomy" do
    it "extracts provider_taxonomy table to CSV" do
      Extractor.new.extract_provider_taxonomy

      file_path = File.join(ENV.fetch("ROOT_PATH"), "tmp", "provider_taxonomy.csv")
      fixture_file_path = File.join(ENV.fetch("ROOT_PATH"), "spec", "fixtures", "extracted_provider_taxonomy.csv")

      rows = []

      File.open(file_path).each_with_index do |line, index|
        rows << line
        break if index > 3
      end

      fixture_rows = []

      File.open(fixture_file_path).each_with_index do |line, index|
        fixture_rows << line
        break if index > 4
      end

      expect(rows).to eq(fixture_rows)
    end
  end

  describe "#extract_provider_target_population" do
    it "extracts joined provider_target_population data to CSV" do
      Extractor.new.extract_provider_target_population

      file_path = File.join(ENV.fetch("ROOT_PATH"), "tmp", "provider_target_populations_joined.csv")
      fixture_file_path = File.join(ENV.fetch("ROOT_PATH"), "spec", "fixtures", "extracted_provider_target_populations_joined.csv")

      rows = []

      File.open(file_path).each_with_index do |line, index|
        rows << line
        break if index > 3
      end

      fixture_rows = []

      File.open(fixture_file_path).each_with_index do |line, index|
        fixture_rows << line
        break if index > 4
      end

      expect(rows).to eq(fixture_rows)
    end
  end
end