class CreateUserResults < ActiveRecord::Migration
  def change
    create_table :user_results do |t|
      t.integer :user_id, :match_id, :team_id, :match_round_id, :scored_goals
    end
  end
end
