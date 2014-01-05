class SessionsController < ApplicationController
  def new
    return redirect_to root_path if current_user
    @authorize_url = authorize_url
  end

  def index
    if params[:code]
      access_token_body =  Faraday.get "https://foursquare.com/oauth2/access_token?client_id=#{FOURSQUARE_CLIENT_ID}&client_secret=#{FOURSQUARE_CLIENT_SECRET}&grant_type=authorization_code&redirect_uri=http://localhost:3000/&code=#{params[:code]}"

      @access_token = JSON.parse(access_token_body.body)["access_token"]
      @foursquare = Foursquare2::Client.new(oauth_token: @access_token)
    else
      redirect_to new_session_path
    end
  end


  def authorize_url
    "https://foursquare.com/oauth2/authenticate?client_id=#{FOURSQUARE_CLIENT_ID}&response_type=code&redirect_uri=http://localhost:3000/"
  end
end
