class TeamsController < ApplicationController
  before_action :is_admin?, only: [:new, :create]

  COLUMNS = [:id, :name, :tournament_id]
  USER_COLUMNS = [:id, :first_name,:last_name, :avatar]

  def index
    obj = []
    Team.select(COLUMNS).order(:name).each do |team|
      obj << {
          team: team,
          players: team.users
      }
    end

    render json: obj
  end

  def show
    respond_with Team.select(COLUMNS).find_by_id!(params[:id])
  end

  def new
    response = User.select(USER_COLUMNS).order(:first_name,:last_name)
    respond_with response
  end

  def create
    @tournament = Tournament.find_by_id(params[:team][:tournament_id])
    @tournament.teams.destroy_all
    @tournament.matches.destroy_all

    case params[:team][:generate_method]
      when 1
       response = Team.generate_teams_automatically(params[:team][:ids], params[:team][:tournament_id])
      when 2
       response = Team.generate_teams_manually(params[:team][:ids], params[:team][:tournament_id])
    end

    if response.present?
      render json: {success: 'Teams was successfully created'}, status: :created
    else
      render json: {error: 'Teams was not created'}, status: :unprocessable_entity
    end


  end

  def update
    @team = Team.find_by_id!(params[:id])
    if @team.users.find_by_id!(current_user.id).present?
      if @team.update_attributes(name: params[:name])
        head :no_content
      else
        render json: @team.errors, status: :unprocessable_entity
      end
    end
  end

end
