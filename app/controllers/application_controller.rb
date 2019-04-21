class ApplicationController < ActionController::Base

  include SessionsHelper

  skip_before_action :verify_authenticity_token

  private
    def require_logged_in_user
      logger.info "Requesting user rights..."
      unless user_signed_in?
        logger.info "user not found. redirect to login form"
        base_url = Rails.configuration.auth_login_url
        redirect_url = "#{base_url}?callback_url=#{ERB::Util.url_encode(login_callback_url)}"
        redirect_to redirect_url
      end
    end

end
