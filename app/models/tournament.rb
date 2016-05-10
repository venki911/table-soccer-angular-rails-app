# create_table "tournaments", force: :cascade do |t|
#   t.string   "name",       null: false
#   t.integer  "tourn_type", null: false
#   t.string   "place",      null: false
#   t.datetime "datetime",   null: false
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
# end
class Tournament < ActiveRecord::Base

  has_many :teams, dependent: :destroy
  has_many :matches, dependent: :destroy

  validates :name, :tourn_type, :place, :datetime, presence: true
  validates :name, length: { minimum: 10, maximum: 50 }, uniqueness: true

  enum tourn_type: {
      current: 1,
      finsihed: 2,
      'not started': 3
  }

  validates :tourn_type, inclusion: { in: self.tourn_types }
  validate :datetime_validate

  def create_matches(times,match_params)
    # times = times.to_i

    default_round_status = Match.statuses['not started']
    tour_id = match_params[:tour]#Match.tours[match_params[:tour]]
    # match_type = match_params[:match_type]#Match.match_types[match_params[:match_type]]

    1.upto(2) do |match_type|
      if match_type == 1
        match_params[:match_type] = 1
        match_params[:tour] = nil
        teams = self.teams.to_a.reverse
        round_datetime = self.datetime
        (0..teams.length-1).each do
          team = teams.pop
          new_teams_length = teams.length-1

          new_teams_length.downto(0) do |j|
            Match.new(match_params)
                .create_teams_matches(times,round_datetime,default_round_status,team,teams,j)
            round_datetime += 300 * times + 300
          end
        end

      else
        match_params[:match_type] = 2
        if tour_id == 4
          round_datetime = Match.all.where(tournament_id: match_params[:tournament_id]).last.datetime + 300 * times + 300
          @match = Match.new(match_params)
          @match.datetime = round_datetime
          @match.status = default_round_status
          @match.tour = 4
          @match.save

          1.upto(times) do |round_number|
            @match.match_rounds.create(status: 3, round_number: round_number)
            @match.match_rounds.create(status: 3, round_number: round_number)
          end
        elsif tour_id != 0
          tour_id.upto(5) do |tour|
            case (tour)
              when 1 #1/8
                match_count = 8
              when 2 #1/4
                match_count = 4
              when 3 #1/2
                match_count = 2
              when 4 #final
                match_count = 1
              when 5 # 3rd place
                match_count = 1
            end

            1.upto(match_count).each do
              round_datetime = Match.all.where(tournament_id: match_params[:tournament_id]).last.datetime + 300 * times + 300
              @match = Match.new(match_params)
              @match.datetime = round_datetime
              @match.status = default_round_status
              @match.tour = tour
              @match.save

              1.upto(times) do |round_number|
                @match.match_rounds.create(status: 3, round_number: round_number)
                @match.match_rounds.create(status: 3, round_number: round_number)
              end
            end
          end
        end
      end
    end

    # if match_type == 1
    #
    #   teams = self.teams.to_a.reverse
    #   round_datetime = self.datetime
    #   (0..teams.length-1).each do
    #     team = teams.pop
    #     new_teams_length = teams.length-1
    #
    #     new_teams_length.downto(0) do |j|
    #       Match.new(match_params)
    #           .create_teams_matches(times,round_datetime,default_round_status,team,teams,j)
    #       round_datetime += 300 * times + 300
    #     end
    #   end
    # elsif match_type == 2
    #
    #   if tour_id != 0
    #     teams = []
    #     if self.matches.where.not(tour: nil).any?
    #       last_tour = Match.tours[self.matches.where(match_type: match_type).last.tour]
    #       if last_tour != 4
    #         self.matches.where(tour: last_tour).each do |match|
    #           teams << Team.find_by_id(match.winner_team_id)
    #         end
    #       else
    #         self.matches.where(tour: 3).each do |match|
    #           match.teams.uniq.each do |team|
    #             teams << team if team.id != match.winner_team_id
    #           end
    #
    #         end
    #       end
    #
    #       teams.flatten!
    #     else
    #       teams = self.results_table.collect { |team| team[:team] }
    #     end
    #
    #     case (tour_id)
    #       when 1 #1/8
    #         teams = teams[0...16]
    #       when 2 #1/4
    #         teams = teams[0...8]
    #       when 3 #1/2
    #         teams = teams[0...4]
    #       when 4 #final
    #         teams = teams[0...2]
    #       when 5 # 3rd place
    #         teams = teams
    #     end
    #     round_datetime = Match.all.where(tournament_id: match_params[:tournament_id]).last.datetime + 300
    #     (0..teams.length-2).step(2).each do |i|
    #       Match.new(match_params)
    #           .create_teams_matches(times,round_datetime,default_round_status,teams[i],teams,i+1)
    #       round_datetime += 300 * times + 300
    #     end
    #   end
    # end
  end

  def results_table
    results = []
    place = self.place
    played_games = 0
    wins = 0
    loses = 0
    self.teams.each do |tournament_team|
      team = tournament_team

      scored_goals = 0
      missed_goals = 0

      matches = tournament_team.matches.where(status: 2, match_type: 1).uniq.to_a
      matches.each do |match|
        played_games = matches.length
        wins = Match.all.where(status: 2, match_type: 1, winner_team_id: tournament_team.id).count
        loses =  (played_games - wins)
        #/round.teams_tournaments_rounds.maximum(:round_number)
        scored_goals += match.match_rounds.where(team_id: tournament_team.id).sum(:scored_goals)
        missed_goals += match.match_rounds.where(team_id: tournament_team.id).sum(:missing_goals)
      end

      goals_difference = (scored_goals - missed_goals).abs
      points = wins * 3
      hash = {
          place: place,
          team: team,
          played_games: played_games,
          wins: wins,
          loses: loses,
          scored_goals: scored_goals,
          missed_goals: missed_goals,
          goals_difference: goals_difference,
          points: points
      }
      results << hash
    end
    results.sort_by! { |hash| hash[:points] }.reverse!
  end

  def playoff_bracket
    if self.matches.where.not(tour: nil).any?
      results = []
      hash = {
          teams: [],
          goals: []
      }
      start_tour = Match.tours[self.matches.where(match_type: 2).first.tour]

      self.matches.where(tour: start_tour).each do |match|
        teams = []
        match.teams.uniq.each do |team|
          teams << team.name
        end
        hash[:teams] << teams
      end

      goals_1_8 = []
      goals_1_4 = []
      goals_1_2 = []
      goals_final = []
      goals_3rd = []
      self.matches.where(match_type: 2, status: 2).each do |match|

        case (Match.tours[match.tour])
          when 1 #1/8
            goals_1_8 << calc_goals(match)
          when 2 #1/4
            goals_1_4 << calc_goals(match)
          when 3 #1/2
            goals_1_2 << calc_goals(match)
          when 4 #final
            goals_final << calc_goals(match)
          when 5 # 3rd place
            goals_3rd << calc_goals(match)
        end

      end
      hash[:goals] << goals_1_8 if goals_1_8.present?
      hash[:goals] << goals_1_4 if goals_1_4.present?
      hash[:goals] << goals_1_2 if goals_1_2.present?
      if goals_3rd.present?
        goals_final << goals_3rd.flatten
      end
      hash[:goals] << goals_final if goals_final.present?
      results << hash
      results
    end
  end

  def calc_goals(match)
    goals = []
    match.teams.uniq.each do |team|
      goals << team.match_rounds.where(match_id: match.id).sum(:scored_goals)
    end
    goals
  end

  private

    def datetime_validate
      errors.add(:datetime, "can't be less than current date/time") if datetime < Time.now - 1
    end

end
