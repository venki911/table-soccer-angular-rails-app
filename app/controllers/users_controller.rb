class UsersController < ApplicationController

  # COLUMNS = [:id, :email, :first_name, :last_name, ]
  #
  # def show
  #   respond_with User.find_by_id!(params[:id])
  # end

  def update_avatar
    @user = User.find_by_id!(params[:id])
    if @user
      @user.avatar = params[:file]
      @user.save!
    end
    respond_with @user
  end

  def find_users_by_team
    respond_with Team.find_by_id!(params[:team_id]).users.select(:id, :first_name, :last_name, :avatar)
  end
end
