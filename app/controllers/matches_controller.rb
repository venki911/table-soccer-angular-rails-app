class MatchesController < ApplicationController
  #before_action :is_admin?

  COLUMNS = [:id, :tournament_id, :match_type, :tour, :datetime, :status, :winner_team_id]

  def create
    times = params[:count]
    times = 1 if times == 0

    @tournament = Tournament.find_by_id!(params[:match][:tournament_id])
    if @tournament.present?
        @tournament.create_matches(times, match_params)
      render json: {success: 'Matches was created'}, status: :created
    else
      render json: {error: 'Matches was not created'}, status: :unprocessable_entity
    end
  end

  private

    def match_params
      params.require(:match).permit(:tournament_id, :match_type, :tour, :datetime, :status, :winner_team_id)
    end
end
