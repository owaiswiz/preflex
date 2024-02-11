class CreatePreflexPreferences < ActiveRecord::Migration[7.1]
  def change
    create_table :preflex_preferences do |t|
      t.string :type
      t.string :owner_type
      t.bigint :owner_id
      t.text :data, limit: 16.megabytes + 1
      t.index ['type', 'owner_type', 'owner_id']
      t.timestamps
    end
  end
end
