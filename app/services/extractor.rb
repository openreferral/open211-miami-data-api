require 'csv'
require 'hsds_transformer'

class Extractor
  attr_reader :client, :output_dir, :mapping_path, :datapackage_dir

  def self.run(datapackage_id: nil)
    new(datapackage_id: datapackage_id).extract
  end

  def initialize(datapackage_id: nil)
    @client = TinyTds::Client.new(
      username: ENV.fetch("SOURCE_DB_USERNAME"),
      password: ENV.fetch("SOURCE_DB_PASSWORD"),
      host: ENV.fetch("SOURCE_DB_HOST"),
      port: ENV.fetch("SOURCE_DB_PORT")
    )

    @datapackage_id = datapackage_id
    @output_dir = File.join ENV.fetch("ROOT_PATH"), "tmp/source_data/"
    @mapping_path  = File.join ENV.fetch("ROOT_PATH"), "lib/mapping.yaml"
    @datapackage_dir = File.join ENV.fetch("ROOT_PATH"), "tmp/dtpkg/"
  end

  def extract
    raise Exceptions::ExtractorError("Datapackage is not persisted") unless datapackage.persisted?

    extract_providers
    extract_provider_taxonomy
    extract_provider_target_population
    transform_into_datapackage
  end

  def extract_providers
    result = client.execute("SELECT * FROM community_resource.dbo.provider")

    extract_to_csv(result, providers_path)
  end

  def extract_provider_taxonomy
    result = client.execute("SELECT * FROM community_resource.dbo.provider_taxonomy")

    extract_to_csv(result, provider_taxonomy_path)
  end


  # TODO: do we autogenerate ID here? then add new column to beginning of sheet called "id" and set value equal to the function: =CONCATENATE(B2;"-";ROW(A2)) . Drag this function all the way down.
  # Maybe we can get ID column from DB now that we have direct access
  def extract_provider_target_population
    result = client.execute(
      "SELECT community_resource.dbo.provider_taxonomy.provider_service_code_id AS provider_service_code_id,community_resource.dbo.provider_taxonomy.provider_id AS provider_id,community_resource.dbo.provider_target_population.target_population_code AS target_population_code,community_resource.dbo.provider_target_population.target_population_name AS target_population_name FROM community_resource.dbo.provider_taxonomy JOIN community_resource.dbo.provider_target_population ON community_resource.dbo.provider_taxonomy.provider_service_code_id = community_resource.dbo.provider_target_population.provider_service_code_id"
    )

    extract_to_csv(result, provider_target_population_path)
  end

  def datapackage
    @datapackage ||= Datapackage.find_by(id: datapackage_id) || Datapackage.create
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

  def transform_into_datapackage
    transformer = HsdsTransformer::Runner.run(custom_transformer: "Open211MiamiTransformer", input_path: output_dir, mapping: mapping_path, output_path: datapackage_dir, include_custom: true, zip_output: true)

    datapackage.update(file: transformer.zipfile_name) ## Other fields?
    # # TODO Store on Azure storage
  end

  def providers_path
    File.join output_dir, "providers.csv"
  end

  def provider_taxonomy_path
    File.join output_dir, "provider_taxonomy.csv"
  end

  def provider_target_population_path
    File.join output_dir, "provider_target_populations_joined.csv"
  end
end