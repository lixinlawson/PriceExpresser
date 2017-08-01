class UserMailer < ApplicationMailer

	default from: "priceexpress9@gmail.com"
 def registration_confirmation(user)
    @user = user
    #email_with_name = %("#{@user.name}" <#{@user.email}>)
    mail(to: @user.email, subject: "PriceExpresser: Registration Confirmation")
 	end


  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.PriceNotification.subject
  #
  # def PriceNotification(user)
  #   @user = user

  #   mail(to: @user.email, subject: => "Price Notification!")
  # end

  # the below is fake data for testing
  def PriceNotification(user)
    @user = user
  	mail to: @user.email, subject: "Price Notification!"
  end
end
