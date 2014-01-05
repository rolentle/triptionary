class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  private

  def require_user
    unless current_user
      redirect_to root_path
    end
  end

  def current_user
    return nil if session[:access_token].blank?
    begin
      foursquare = Foursquare2::Client.new(:oauth_token => session[:access_token])
      @current_user || foursquare.users.find("self")
    rescue Foursquare2::InvalidAuth
      nil
    end
  end

  def foursquare
    unless current_user
      @foursquare ||= Foursquare2::Client.new(:client_id => FOURSQUARE_CLIENT_ID, :client_secret => FOURSQUARE_CLIENT_SECRET)
    else
      @foursquare ||= Foursquare2::Base.new(:oauth_token => session[:access_token])
    end
  end
end
