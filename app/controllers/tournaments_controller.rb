class TournamentsController < ApplicationController
  #before_action :is_admin?, only: [:create, :update, :destroy]

  COLUMNS = [:id, :name, :tourn_type, :place, :datetime]

  def index
    respond_with Tournament.select(COLUMNS).order(:datetime)
  end

  def show
    @tournament = Tournament.select(COLUMNS).find_by_id!(params[:id])
    @matches = []


    @tournament.matches.order(:match_type, :datetime).each do |match|
      @matches << {
          match: match,
          match_rounds: match.match_rounds.group_by(&:round_number),
          match_teams: match.teams.select(:id, :name).order(:id).uniq
      }
    end

    respond_with tournament_info = {
        tournament: @tournament,
        teams: @tournament.teams,
        matches: @matches,
        results_table: @tournament.results_table,
        playoff_bracket: @tournament.playoff_bracket
    }
  end

  def create
    respond_with Tournament.create(tournament_params)
  end

  def update
    @tournament = Tournament.find_by_id!(params[:id])
    if @tournament && @tournament.update_attributes(tournament_params)
      head :no_content
    else
      render json: @tournament.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @tournament = Tournament.where(id: params[:ids])
    if @tournament.destroy_all
      head :no_content
    else
      render json: @tournament.errors, status: :unprocessable_entity
    end
  end


  private
   def tournament_params
     params.require(:tournament).permit(:name, :tourn_type, :place, :datetime)
   end

end
