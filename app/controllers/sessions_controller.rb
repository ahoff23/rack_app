class SessionsController < ApplicationController
	def new
	end

	def create
		#First check if the user even exists
		user = User.find_by(email: params[:session][:email].downcase)
		#authenticate is already given by has_secure_password
		if user && user.authenticate(params[:session][:password])
			sign_in user
			#Friendly forwarding redirect
			redirect_back_or root_path
		else
			#Flash but .now makes sure that it only persists for one page
			flash.now[:error] = 'Invalid email/password combination'
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end
end
