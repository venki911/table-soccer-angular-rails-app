class AddRoundNumberToMatchRounds < ActiveRecord::Migration
  def change
    add_column :match_rounds, :round_number, :integer
  end
end
