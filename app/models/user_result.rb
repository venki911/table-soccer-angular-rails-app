# create_table "user_results", force: :cascade do |t|
#   t.integer "user_id"
#   t.integer "match_id"
#   t.integer "team_id"
#   t.integer "match_round_id"
#   t.integer "scored_goals"
# end

class UserResult < ActiveRecord::Base
  belongs_to :user


  def self.change_users_rank(tournament)
    tournament.matches.each do |match|
      match.teams.uniq.each do |team|
        users = team.users#.select(:id,:rank)
        if team.id == match.winner_team_id
          users.each do |user|
            current_rank = user.rank
            user.update_attributes(rank: current_rank + 25 + (0.3 * UserResult.where(match_id: match.id, user_id: user.id).sum(:scored_goals)).round)
          end
        else
          users.each do |user|
            current_rank = user.rank
            user.update_attributes(rank: current_rank - 25 + (0.3 * UserResult.where(match_id: match.id, user_id: user.id).sum(:scored_goals)).round)
          end
        end
      end
    end
    tournament.update_attributes(tourn_type: :finished)
  end
end
