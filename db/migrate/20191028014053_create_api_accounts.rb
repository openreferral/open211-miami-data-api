class CreateApiAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :api_accounts do |t|
      t.string :name
      t.string :api_key, null: false, unique: true

      t.timestamps
    end
  end
end
