class ChangeUsersRankColumn < ActiveRecord::Migration
  def self.up
    change_column :users, :rank, :integer, default: 1000
  end

  def self.down
    change_column :users, :rank, :integer
  end
end
