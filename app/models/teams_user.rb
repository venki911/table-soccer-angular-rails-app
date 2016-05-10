# create_table "teams_users", force: :cascade do |t|
#   t.integer "team_id"
#   t.integer "user_id"
# end

class TeamsUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :team

  validates :team_id, :user_id, presence: true
end
