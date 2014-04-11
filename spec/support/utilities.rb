#Returns the full title of a page
def full_title(page_title)
	base_title="Website Name"
	if page_title.empty?
		base_title
	else
		"#{base_title} | #{page_title}"
	end
end

def sign_in(user, options={})
	#Sign in when not using Capybara
	if options[:no_capybara]
		#Create a new token
		remember_token = User.new_remember_token
		#Set the remember_token stored in cookies
		cookies[:remember_token]=remember_token
		#Update the user's remember_token to  match the one stored in cookies
		user.update_attribute(:remember_token,User.hash(remember_token))
	else
		visit signin_path
		fill_in "Email",	with: user.email
		fill_in "Password", with: user.password
		click_button "Sign in"
	end
end