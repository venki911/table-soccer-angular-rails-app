class CreateMatchRounds < ActiveRecord::Migration
  def change
    create_table :match_rounds do |t|
      t.integer :match_id, :team_id, :scored_goals, :missing_goals, :status
    end
  end
end
