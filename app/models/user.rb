class User < ActiveRecord::Base
	#Save email addresses as lower case so that case does not matter
	before_save { self.email = email.downcase }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, uniqueness: { case_sensitive: false }, 
		format: { with: VALID_EMAIL_REGEX }
	validates :password, length: { minimum: 6 }

	#Password setup (requires password_digest)
	has_secure_password
end