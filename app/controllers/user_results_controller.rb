class UserResultsController < ApplicationController
  # before_action :is_admin?

  def create
    round_ids = []

    params[:users_results].each do |user_result|
      UserResult.where(user_id: user_result['user_id'], match_id: user_result['match_id'], team_id: user_result['team_id'],
                       match_round_id: user_result['match_round_id']).destroy_all
      UserResult.create(user_id: user_result['user_id'], match_id: user_result['match_id'], team_id: user_result['team_id'],
                        match_round_id: user_result['match_round_id'], scored_goals: user_result['scored_goals'])
      round_ids << user_result['match_round_id']
    end

    first_tour = update_match_round(round_ids.uniq)
    render json: {
        rounds: MatchRound.where(id: round_ids.uniq),
        match: Match.find_by_id(params[:users_results][0]['match_id']),
        first_tour: first_tour
    }, status: :ok
  end

  private

    def update_match_round(rounds_ids)
      teams_scored_goals = []
      first_tour = 0;
      tourn_id = 0
      rounds_ids.each do |round_id|
        teams_scored_goals << UserResult.where(match_round_id: round_id).sum(:scored_goals)
      end

      teams_missed_goals = teams_scored_goals.reverse
      rounds_ids.each_with_index do |round_id, i|
        round = MatchRound.find_by_id!(round_id)

        if round.present?
          round.update_attributes(scored_goals: teams_scored_goals[i], missing_goals: teams_missed_goals[i], status: :finished)
          @match = Match.find_by_id(round.match_id)
          if round.id == @match.match_rounds.last.id
            @match.update_attributes(status: :finished, winner_team_id:
                @match.match_rounds.select(:team_id, :scored_goals).group(:team_id).sum(:scored_goals).max_by{|k,v| v}[0])
          end
          tourn_id = @match.tournament_id
        end
      end

      tournament = Tournament.find_by_id!(tourn_id)

      # last_match = tournament.matches.where(match_type: 1).last
      if tournament.matches.where(match_type: 1).last.status == 'finished'
        first_tour = tournament.matches.where(match_type: 2).first.tour

        teams = tournament.results_table.collect { |team| team[:team] }
        tournament.matches.where(match_type: 2).order(:id).each do |match|
          playoff_teams = []
          # if !match.teams.present?
            if match.tour == first_tour
              case (Match.tours[match.tour])
                when 1 #1/8
                  playoff_teams = teams[0...8]
                  teams.shift(8)
                when 2 #1/4
                  playoff_teams = teams[0...4]
                  teams.shift(4)
                when 3 #1/2
                  playoff_teams = teams[0...2]
                  teams.shift(2)
                when 4 #final
                  playoff_teams = teams[0...2]
              end
              set_playoff_teams(playoff_teams,match)
            elsif match.tour != first_tour && match.tour != '3rd place'
              tournament.matches.where(tour: Match.tours[match.tour] - 1).order(:id).each do |prev_match|
                playoff_teams << Team.find_by_id(prev_match.winner_team_id) if prev_match.status == 'finished'
              end
              set_playoff_teams(playoff_teams,match) #if playoff_teams.present?
            else
              tournament.matches.where(tour: 3).each do |prev_match|
                playoff_teams << prev_match.teams.where.not(id: prev_match.winner_team_id).uniq[0] if prev_match.status == 'finished'
              end
              set_playoff_teams(playoff_teams,match) #if playoff_teams.present?
            end
          # end
        end
      end

      if tournament.matches.last.status == 'finished'
        UserResult.change_users_rank(tournament)
      end
      first_tour
    end

  private
    def set_playoff_teams(teams,match)
      rounds = match.match_rounds.group_by(&:round_number)
      (0..teams.length).step(2).each do |i|
        1.upto(rounds.length) do |number|
          rounds[number][0].update_attributes(team: teams[i]) if teams[i]
          rounds[number][1].update_attributes(team: teams[i+1]) if teams[i+1]
        end
      end
    end
end
