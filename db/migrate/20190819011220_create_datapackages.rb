class CreateDatapackages < ActiveRecord::Migration[5.1]
  def change
    create_table :datapackages do |t|
      t.attachment :file

      t.timestamps
    end
  end
end
