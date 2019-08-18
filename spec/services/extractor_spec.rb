require "rails_helper"

describe Extractor do

  describe ".run" do

    it "extracts provider table to CSV" do

      Extractor.run

      file_path = File.join(ENV.fetch("RAILS_ROOT"), "tmp", "providers.csv")
      expect(File.open(file_path)).to eq("")

    end

    it "extracts provider_taxonomy table to CSV"

  end

end