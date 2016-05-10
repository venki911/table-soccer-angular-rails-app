class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name, null: false
      t.integer :tourn_type, null: false
      t.string :place, null: false
      t.datetime :datetime, null: false

      t.timestamps null: false
    end
  end
end
