class RemoveFileFromDatapackages < ActiveRecord::Migration[5.2]
  def change
    remove_column :datapackages, :file_file_name
    remove_column :datapackages, :file_content_type
    remove_column :datapackages, :file_file_size
    remove_column :datapackages, :file_updated_at
  end
end
