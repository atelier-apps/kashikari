class ApplicationController < ActionController::Base
  before_action  :store_location

  def store_location

    if (request.fullpath != top_path &&
        request.fullpath != maintenance_path &&
        request.fullpath != new_user_session_path &&
        # request.fullpath != "/users/password" &&
        request.fullpath !~ Regexp.new("\\A/users/auth/.*\\z") &&
        request.fullpath !~ Regexp.new("\\A/users/password.*\\z") &&
        !request.xhr?)
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    if (session[:previous_url] == root_path)
      super
    else
      session[:previous_url] || root_path
    end
  end
end
