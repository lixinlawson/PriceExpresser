class UsersController < ApplicationController
	

	def new
		@user = User.new
	end

	def show
		@user = User.find_by_name(params[:id])
	end 

	def edit
		@user = User.find_by_name(params[:id])
	end

	def update
		@user = User.find_by_name(params[:id])
		if (@user.update(user_params))
			flash[:success] = "All settings has been saved."
			redirect_to @user
		else
			render 'edit'
		end
	end

	def create		
    	@user = User.new(user_params)
    	if @user.save
    		UserMailer.registration_confirmation(@user).deliver
    		flash[:success] = "Please confirm your email address to continue"
    		redirect_to login_path
      		# Handle a successful save.
    	else
    		flash[:error] = "Ooooppss, something went wrong!"
      		render 'new'
    	end
	end

	def confirm_email
    	@user = User.find_by_confirm_token(params[:id])
    	if @user
	      	@user.email_activate
	      	flash[:success] = "Welcome to the Price Expresser! Your email has been confirmed.
	      	Please log-in to continue."
	      	redirect_to login_path
    	else
      		flash[:error] = "Sorry. User does not exist"
      		render root_path
    	end
	end
	# this the section for help function
private
	def user_params
		params.require(:user).permit(:name, 
			:email, :password, :password_confirmation)
	end
	def deny_access
    	redirect_to root_path
    end
    def current_user_home
    	redirect_to current_user
    end
end
