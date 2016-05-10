class TeamsController < ApplicationController
  before_action :is_admin?, only: [:new, :create]

  COLUMNS = [:id, :name, :tournament_id]
  USER_COLUMNS = [:id, :first_name,:last_name, :avatar]

  def index
    respond_with Team.select(COLUMNS).order(:name)
  end

  def show
    respond_with Team.select(COLUMNS).find_by_id!(params[:id])
  end

  def new
    # p params
    # tournament = Tournament.find_by_id!(params[:t_id])
    #
    # if tournament.teams.any?
    #   users_playing = []
    #
    #   tournament.teams.each do |team|
    #     team.users.each do |user|
    #       users_playing << user.id
    #     end
    #   end
    #
    #   response = User.select(USER_COLUMNS).where.not(id: users_playing).order(:first_name,:last_name)
    # else
      response = User.select(USER_COLUMNS).order(:first_name,:last_name)
    # end

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

end
