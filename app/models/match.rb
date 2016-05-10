# create_table "matches", force: :cascade do |t|
#   t.integer  "tournament_id"
#   t.integer  "match_type"
#   t.integer  "tour"
#   t.integer  "winner_team_id"
#   t.datetime "datetime"
#   t.integer  "status"
#   t.datetime "created_at",     null: false
#   t.datetime "updated_at",     null: false
# end

class Match < ActiveRecord::Base

  has_many :match_rounds, dependent: :destroy
  has_many :teams, through: :match_rounds, dependent: :destroy

  belongs_to :tournament

  validates :tournament_id, :match_type, :status, :datetime, presence: true

  enum tour: {
      '1/8': 1,
      '1/4': 2,
      '1/2': 3,
      final: 4,
      '3rd place': 5
  }

  enum match_type: {
      regular: 1,
      'play-off': 2
  }

  enum status: {
      current: 1,
      finished: 2,
      'not started': 3
  }

  # validates :tour, inclusion: { in: self.tours}
  # validates :match_type, inclusion: { in: self.match_types}
  # validates :status, inclusion: { in: self.statuses}

  # validate :datetime_validate

  def create_teams_matches(times,round_datetime,default_round_status,team,teams,j)
    self.status = default_round_status
    self.datetime = round_datetime
    self.save

    1.upto(times) do |round_number|
      self.match_rounds.create(team: team, round_number: round_number, status: 3)
      self.match_rounds.create(team: teams[j], round_number: round_number, status: 3)
    end
  end

  private

    def datetime_validate
      errors.add(:datetime, "can't be less than current date/time") if datetime < Time.now - 1
    end
end
