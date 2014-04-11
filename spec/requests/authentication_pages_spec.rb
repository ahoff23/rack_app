require 'spec_helper'

describe "AuthenticationPages" do
	subject { page }

	describe "signin page" do
		before { visit signin_path }

		it { should have_content('Sign in') }
		it { should have_title('Sign in') }
	end

	describe "signin" do
		before { visit signin_path }

		describe "with invalid information" do
			before { click_button "Sign in" }
			#Title should remain the same because the page does not change
			it { should have_title('Sign in') }
			#An error message should be displayed
			it { should have_selector('div.alert.alert-error') }

			#Make sure the error message does not persist for more than one page
			describe "after visiting another page" do
				before { click_link "About" }
				it { should_not have_selector('div.alert.alert-error') }
			end
		end

		describe "with valid information" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				#Use uppercase to make sure case-insensitivity works
				fill_in "Email", with: user.email.upcase
				fill_in "Password", with: user.password
				click_button "Sign in"
			end

			it { should have_title('Home') }
			it { should have_link('Sign out',		href: signout_path) }
			it { should_not have_link('Sign in',	href: signin_path) }
			it { should have_link('Edit Account',	href: edit_user_path(user)) }

			describe "followed by signout" do
				#Sign out and then expect a sign in link
				before { click_link "Sign out" }
				it { should have_link('Sign in') }
			end
		end
	end

	describe "authorization" do
		describe "for non-signed in users" do
			let(:user) { FactoryGirl.create(:user) }

			describe "in the Users controller" do

				#Going to an edit page when not signed in redirects to sign in page
				describe "visiting the edit page" do
					before { visit edit_user_path(user) }
					it { should have_title('Sign in') }
				end

				describe "submitting to the update action" do
					before { patch user_path(user) }
					specify { expect(response).to redirect_to(signin_path) }
				end
			end

			describe "when attempting to visit protected pages" do
				before do
					visit edit_user_path(user)
					fill_in "Email",	with: user.email
					fill_in "Password",	with: user.password
					click_button "Sign in"
				end
				it { should have_title('Edit Account') }
			end

		end

		describe "as wrong user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@wrong.com") }
			before { sign_in user, no_capybara: true }

			describe "submitting a GET request to the Users#edit action" do
        		before { get edit_user_path(wrong_user) }
        		specify { expect(response.body).not_to match(full_title('Edit Account')) }
        		specify { expect(response).to redirect_to(root_url) }
      		end

		    describe "submitting a PATCH request to the Users#update action" do
		    	before { patch user_path(wrong_user) }
		        specify { expect(response).to redirect_to(root_url) }
      		end
		end
	end
end
