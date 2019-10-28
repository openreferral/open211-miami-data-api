require "rails_helper"

describe Extractor do
  describe ".run" do
    context "without a datapackage record given" do
      it "transforms extracted files into HSDS zip and creates datapackage record" do
        # stub extract methods
        expect { Extractor.run }.to change(Datapackage, :count).by(1)
        expect(Datapackage.last.file).to be_present
      end
    end

    context "with a datapackage record given" do
      it "transforms extracted files into HSDS zip and update datapackage record" do
        datapackage = Datapackage.create
        # stub extract methods
        expect { Extractor.run(datapackage_id: datapackage.id) }.to change(Datapackage, :count).by(0)
        expect(datapackage.file).to be_present
      end
    end
  end

  describe "#extract" do
    it "raises an error if datapackage does not persist" do
      extractor = Extractor.new
      datapackage = Datapackage.new

      allow(extractor).to receive(:datapackage).and_return(datapackage)

      expect { extractor.extract }.to raise_error(ExtractorError)
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