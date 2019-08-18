class Extractor
  attr_reader :client

  def self.run
    new.extract
  end

  def initialize
    @client = TinyTds::Client.new(
      username: ENV.fetch("SOURCE_DB_USERNAME"),
      password: ENV.fetch("SOURCE_DB_PASSWORD"),
      host: ENV.fetch("SOURCE_DB_USERNAME"),
      port: ENV.fetch("SOURCE_DB_PORT")
    )

    @output_path = File.join ENV.fetch("RAILS_ROOT"), "tmp"
  end

  def extract
    extract_providers
    # extract provider taxonomy
    # extract provider target population
      # this needs to be merged into provider taxonomy output by joining on provider_id and provider_service_code_id, and then autogenerate "id" column and set the value to be provider_service_code_id hyphen index
  end

  private

  def extract_providers
    result = @client.execute("SELECT * FROM community_resource.dbo.provider")
    path = File.join @output_path, "providers.csv"

    CSV.open(path, 'wb') do |csv|
      result.each_with_index do |row, i|
        if i == 1
          csv << row.keys
        end

        csv << CSV::Row.new(row.keys, row.values).values_at(*headers) unless row.values.all?(nil)
      end
    end
  end

end