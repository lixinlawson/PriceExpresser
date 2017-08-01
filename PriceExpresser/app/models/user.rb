class User < ActiveRecord::Base
	before_create :confirmation_token
	before_save { self.email = email.downcase }
	validates :name, presence: true, length: {maximum: 50}
	validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, 
				message: "Invalid Email Format" },
				allow_blank: true, length: {maximum: 225},
				uniqueness: {case_sensitive: false}

	has_secure_password
	validates :password, presence: true, length: {minimum: 6}
	def email_activate
    	self.email_confirmed = true
    	self.confirm_token = nil
    	save!(:validate => false)
  	end
  	
  	def to_param
  		name
	end
  	
private
	def confirmation_token
      if self.confirm_token.blank?
          self.confirm_token = SecureRandom.urlsafe_base64.to_s
      end
    end
end
