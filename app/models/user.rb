class User < ActiveRecord::Base
	#Save email addresses as lower case so that case does not matter
	before_save { self.email = email.downcase }
	before_create :create_remember_token

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, uniqueness: { case_sensitive: false }, 
		format: { with: VALID_EMAIL_REGEX }
	validates :password, length: { minimum: 6 }

	#Password setup (requires password_digest)
	has_secure_password

	#***************************************
	#Functions for creating remember tokens
	#***************************************
	#Create a base64 token
	#Note private because it will also be called when signing a user in
	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end
	#Convert token to a hash
	def User.hash(token)
		#SHA1 is less secure than bcrypt but it has a minimum of 16 characters
		#so it is more than secure for its purpose
		Digest::SHA1.hexdigest(token.to_s)
	end

	private
		#Store the token created and hashed in the two sub-functions
		def create_remember_token
			self.remember_token = User.hash(User.new_remember_token)
		end
	#******************
	#End Private Block
	#******************	
end