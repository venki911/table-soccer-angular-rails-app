class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken

  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?


  respond_to :json

  def angular
    render "#{Rails.root}/public/index.html"
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name]#, :nickname, :name, :image]
    devise_parameter_sanitizer.for(:account_update) << [:first_name, :last_name]
  end

  def is_admin?
    head(403) unless current_user.is_admin
  end

end
