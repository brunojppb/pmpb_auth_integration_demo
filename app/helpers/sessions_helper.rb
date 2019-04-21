require 'net/http'
require 'uri'
require 'json'

module SessionsHelper

  def exchange_token(temp_token)
    logger.info "exchanging temporary token..."
    url = "#{Rails.configuration.auth_base_url}/api/auth/exchange"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, {'Content-Type': 'application/json'})
    request.body = {'temporaryToken': temp_token}.to_json
    response = http.request(request)
    logger.info "Exchange token response: #{response.body}"
    JSON.parse(response.body)['token']
  end

  def current_user
    return @cached_user if @cached_user
    url = "#{Rails.configuration.auth_base_url}/api/validate"
    logger.info "URL: #{url}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)

    token = cookies[:token]
    return nil if token.nil?
    request = Net::HTTP::Post.new(uri.request_uri, {'Content-Type': 'application/json'})
    request.body = {token: token}.to_json

    response = http.request(request)
    logger.info "Auth response: #{response.body}"
    json = JSON.parse(response.body)
    user = User.where('registration = ?', json['user']['registration']).first
    # Return existing user from DB or create a new one with data from Auth API
    if user
      logger.info "User exists #{user}"
      @cached_user = user
    else
      user = User.new(name: json['user']['fullName'], registration: json['user']['registration'])
      logger.info "Saving new user #{user}"
      user.save
      @cached_user = user
    end
    @cached_user
  end

  def user_signed_in?
    !current_user.nil?
  end

end
