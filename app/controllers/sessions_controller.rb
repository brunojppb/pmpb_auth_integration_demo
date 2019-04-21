class SessionsController < ApplicationController

  def index
  end

  def login_callback
    temp_token = params[:temporary_token]
    logger.info "Login callback params: #{params}"
    token = exchange_token(temp_token)
    logger.info "exchanged token: #{token}"
    cookies[:token] = token
    redirect_to roles_path
  end

  def logout
    cookies.delete(:token)
    redirect_to roles_path
  end

end
