class TournamentsController < ApplicationController
  # before_action :is_admin?, only: [:create, :update, :destroy]
  # skip_before_filter :verify_authenticity_token
  COLUMNS = [:id, :name, :tourn_type, :place, :datetime]

  def index
    respond_with Tournament.select(COLUMNS).order(:datetime)
  end

  def show
    # tournament_info = $redis.get("tournament_info")
    # if tournament_info.nil?
    #
    #   @tournament = Tournament.select(COLUMNS).find_by_id!(params[:id])
    #   @matches = []
    #
    #
    #   @tournament.matches.order(:match_type, :datetime).each do |match|
    #     @matches << {
    #         match: match,
    #         match_rounds: match.match_rounds.group_by(&:round_number),
    #         match_teams: match.teams.select(:id, :name).order(:id).uniq
    #     }
    #   end
    #
    #   tournament_info = {
    #       tournament: @tournament,
    #       teams: @tournament.teams,
    #       matches: @matches,
    #       results_table: @tournament.results_table,
    #       playoff_bracket: @tournament.playoff_bracket
    #   }
    #
    #   $redis.set('tournament_info', tournament_info.to_json)
    #   $redis.expire('tournament_info', 1.hour.to_i)
    # end
    # respond_with tournament_info
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
