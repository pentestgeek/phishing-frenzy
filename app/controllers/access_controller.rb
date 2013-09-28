class AccessController < ApplicationController
  before_filter :confirm_logged_in, :except => [:login, :logout, :attempt_login]

  def index
  	menu
  	render('menu')
  end

  def menu
  	# display text & links
  end

  def login
  	# login form
  end

  def attempt_login
  	authorized_user = Admin.authenticate(params[:username], params[:password])
  	if authorized_user	
      # mark user as logged in
      session[:user_id] = authorized_user.id
      session[:username] = authorized_user.username
  		flash[:notice] = "You are now logged in."
  		redirect_to(:controller => 'campaigns', :action => 'home')
  	else
      flash[:notice] = "Invalid username/password combination."
      redirect_to(:action => 'login')
  	end
  end

  def logout
    # display logout message
  	flash[:notice] = "You have been logged out."
  	redirect_to(:action => 'login')

    # clear cookies
    session[:user_id] = nil
    session[:username] = nil
  end

end
