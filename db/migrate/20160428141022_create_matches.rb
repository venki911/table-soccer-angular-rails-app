class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :tournament, index: true, foreign_key: true
      t.integer :match_type
      t.integer :tour
      t.integer :winner_team_id
      t.datetime :datetime
      t.integer :status

      t.timestamps null: false
    end
  end
end
