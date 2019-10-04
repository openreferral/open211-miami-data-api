require 'csv'
class Extractor
  attr_reader :client

  def self.run
    new.extract
  end

  def initialize
    @client = TinyTds::Client.new(
      username: ENV.fetch("SOURCE_DB_USERNAME"),
      password: ENV.fetch("SOURCE_DB_PASSWORD"),
      host: ENV.fetch("SOURCE_DB_HOST"),
      port: ENV.fetch("SOURCE_DB_PORT")
    )

    @output_path = File.join ENV.fetch("RAILS_ROOT"), "tmp"
  end

  def extract
    extract_providers
    extract_provider_taxonomy
    extract_provider_target_population
    # TODO Store on Azure storage
  end

  def extract_providers
    result = @client.execute("SELECT * FROM community_resource.dbo.provider")
    path = File.join @output_path, "providers.csv"

    extract_to_csv(result, path)
  end

  def extract_provider_taxonomy
    result = @client.execute("SELECT * FROM community_resource.dbo.provider_taxonomy")
    path = File.join @output_path, "provider_taxonomy.csv"

    extract_to_csv(result, path)
  end


  # TODO: do we autogenerate ID here? then add new column to beginning of sheet called "id" and set value equal to the function: =CONCATENATE(B2;"-";ROW(A2)) . Drag this function all the way down.
  # Maybe we can get ID column from DB now that we have direct access
  def extract_provider_target_population
    result = @client.execute(
        "SELECT community_resource.dbo.provider_taxonomy.provider_service_code_id AS provider_service_code_id,community_resource.dbo.provider_taxonomy.provider_id AS provider_id,community_resource.dbo.provider_target_population.target_population_code AS target_population_code,community_resource.dbo.provider_target_population.target_population_name AS target_population_name FROM community_resource.dbo.provider_taxonomy JOIN community_resource.dbo.provider_target_population ON community_resource.dbo.provider_taxonomy.provider_service_code_id = community_resource.dbo.provider_target_population.provider_service_code_id"
    )
    path = File.join @output_path, "provider_target_populations_joined.csv"

    extract_to_csv(result, path)
  end

  private

  def extract_to_csv(result, path)
    CSV.open(path, 'wb') do |csv|
      result.each_with_index do |row, i|
        if i == 0
          csv << row.keys
        end

        csv << row.values
      end
    end
  end

end