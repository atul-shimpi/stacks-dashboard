class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  
  def regions
    [ {name: 'US East (N. Virginia)', short_name: 'us-east-1'}]
  end
end
