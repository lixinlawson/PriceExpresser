class SessionsController < ApplicationController
  def new
  end
  def destroy
    log_out
    redirect_to root_path
  end

  before_filter do
    if !current_user.nil? & !log_out
      redirect_to root_path
    end
  end
  
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      if @user.email_confirmed
          log_in @user
          redirect_to '/orders'
          #redirect_back_or @user
      else
        flash.now[:error] = 'Please activate your account by following the instructions in the account confirmation email you received to proceed'
        render 'welcome/index'
      end
    else
      flash.now[:error] = 'Login FAILED: Invalid email address or wrong password!'
      render 'new'
    end
  end

  
end
