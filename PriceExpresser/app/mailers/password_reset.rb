class PasswordReset < ApplicationMailer
	default from: "priceexpress9@gmail.com"
 def user_password(user)
    @user = user
    mail(to: @user.email, subject: "PriceExpresser: Your Password")
 	end
end