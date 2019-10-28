class CreateDatapackages < ActiveRecord::Migration[5.1]
  def change
    create_table :datapackages do |t|
      t.string :name

      t.timestamps
    end
  end
end
