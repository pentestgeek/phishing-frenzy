class ApplicationController < ActionController::Base
	protect_from_forgery
  before_filter :authenticate_admin!

	protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username) }
  end


end
