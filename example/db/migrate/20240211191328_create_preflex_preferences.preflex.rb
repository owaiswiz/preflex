# This migration comes from preflex (originally 20240211162939)
class CreatePreflexPreferences < ActiveRecord::Migration[7.1]
  def change
    create_table :preflex_preferences do |t|
      t.string :type
      t.string :owner, limit: 500
      t.index ['type', 'owner']
      t.timestamps
    end
  end
end
