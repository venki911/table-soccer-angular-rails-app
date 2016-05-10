# create_table "teams", force: :cascade do |t|
#   t.string   "name"
#   t.integer  "tournament_id"
#   t.datetime "created_at",    null: false
#   t.datetime "updated_at",    null: false
# end

class Team < ActiveRecord::Base
  has_many :teams_users, dependent: :destroy
  has_many :users, through: :teams_users
  belongs_to :tournament

  has_many :match_rounds#, dependent: :destroy
  has_many :matches, through: :match_rounds, dependent: :destroy

  validates :name, :tournament_id, presence: true

  def self.generate_teams_automatically(ids, tournament_id)
    users = User.select(:id, :first_name, :last_name, :rank).where(id: ids).order(:rank).to_a
#select_users(ids).order(:rank).to_a

    users1 = users.slice!(0..users.length/2-1)
    users2 = users.slice!(0..users.length)
    random = Random.new

    response = users1.each do |user1|
      if random.rand(0..30) == 30
        user2 = users2.slice!(random.rand(0..users2.length-1))
      else
        user2 = users2.pop
      end
      team = Team.create(
          name: "#{user1.first_name} #{user1.last_name[0]}. + #{user2.first_name} #{user2.last_name[0]}.",
          tournament_id: tournament_id)
      user1.teams_users.create(team: team)
      user2.teams_users.create(team: team)

      team
    end
    {teams: response }
  end

  def self.generate_teams_manually(ids, tournament_id)
    users = User.select(:id, :first_name, :last_name, :rank).where(id: ids).order_by_ids(ids).to_a#select_users(ids,true).to_a

    response = (0..users.length-1).step(2).each do |i|
      team_players = users[i..i+1]
      team = Team.create(
          name: "#{team_players[0].first_name} #{team_players[0].last_name[0]}. + " +
              "#{team_players[1].first_name} #{team_players[1].last_name[0]}.",
          tournament_id: tournament_id)

      team_players[0].teams_users.create(team: team)
      team_players[1].teams_users.create(team: team)

      team
    end
    response
  end

  private

    def select_users(ids, save_order = false)
      if save_order
        User.select(:id, :first_name, :last_name, :rank).where(id: ids).order_by_ids(ids)
      else
        User.select(:id, :first_name, :last_name, :rank).where(id: ids)
      end
    end

end
