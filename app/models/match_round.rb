# create_table "match_rounds", force: :cascade do |t|
#   t.integer "match_id"
#   t.integer "team_id"
#   t.integer "scored_goals"
#   t.integer "missing_goals"
#   t.integer "status"
#   t.integer "round_number"
# end

class MatchRound < ActiveRecord::Base
  belongs_to :team
  belongs_to :match

  validates :match_id, :status, presence: true

  enum status: {
      current: 1,
      finished: 2,
      'not started': 3
  }

  validates :status, inclusion: { in: self.statuses}
end
