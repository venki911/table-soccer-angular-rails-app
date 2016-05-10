# create_table "user_results", force: :cascade do |t|
#   t.integer "user_id"
#   t.integer "match_id"
#   t.integer "team_id"
#   t.integer "match_round_id"
#   t.integer "scored_goals"
# end

class UserResult < ActiveRecord::Base
  belongs_to :user

end
