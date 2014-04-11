module SessionsHelper
	#Sign the user in
	def sign_in(user)
		remember_token = User.new_remember_token
		#Save the remember_token as a cookie for 20 years
		cookies.permanent[:remember_token] = remember_token
		#Update remember_token attribute without the update method
		user.update_attribute(:remember_token, User.hash(remember_token))
		self.current_user = user
	end

	#Must define an assignment. Creates a variable which stores the current user
	def current_user=(user)
		@current_user = user
	end

	def current_user
		#Hash the remember_token stored in cookies
		remember_token = User.hash(cookies[:remember_token])
		#Only calls equals operator if @current_user is undefined
		#Updates the current user whenever current_user is called
		@current_user ||= User.find_by(remember_token: remember_token)
	end

	#Returns true if the current user has any value
	def signed_in?
		!current_user.nil?
	end

	#Sign the user out
	def sign_out
		#Update the user's token in case it was stolen
		current_user.update_attribute(:remember_token, User.hash(User.new_remember_token))
		#Delete the remember_token from cookies (this will cause current_user to return nil)
		cookies.delete(:remember_token)
		#Set current_user to nil
		self.current_user = nil
	end

	def current_user?(user)
		user == current_user
	end

	#If there is a redirect in the queue upon signing in, redirect to that page
	#Otherwise redirect to the default page
	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end

	def store_location
		session[:return_to] = request.url if request.get?
	end
end
