require "rails_helper"

describe Extractor do

  describe ".run" do

    it "extracts provider table to CSV" do

      Extractor.run

      file_path = File.join(ENV.fetch("RAILS_ROOT"), "tmp", "providers.csv")
      fixture_file_path = File.join(ENV.fetch("RAILS_ROOT"), "spec", "fixtures", "extracted_providers.csv")

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

    it "extracts provider_taxonomy table to CSV" do
      Extractor.run

      file_path = File.join(ENV.fetch("RAILS_ROOT"), "tmp", "provider_taxonomy.csv")
      fixture_file_path = File.join(ENV.fetch("RAILS_ROOT"), "spec", "fixtures", "extracted_provider_taxonomy.csv")

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