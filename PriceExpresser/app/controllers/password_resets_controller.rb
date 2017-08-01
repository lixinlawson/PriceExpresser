class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email].downcase)
    if @user
      @user.tempPw = SecureRandom.urlsafe_base64.to_s
      @user.update(:password => @user.tempPw)
      PasswordReset.user_password(@user).deliver
      flash.now[:success] = "A temporary password has been sent to #{@user.email}."
      render 'sessions/new'
    else
      flash.now[:error] = "Email address not found"
      render 'new'
    end
  end

end
