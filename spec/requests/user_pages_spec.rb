require 'spec_helper'

describe "UserPages" do

	subject { page }

	shared_examples_for "all user pages" do
		it { should have_title(full_title(page_title)) }
	end

	#**********************************
	#Signup Page Tests
	#**********************************

	describe "signup page" do
		before { visit signup_path }

		let(:submit) { "Create my account" }
		let(:page_title) { 'Sign Up' }
		it_should_behave_like "all user pages"
		it { should have_content 'Sign Up' }

		describe "with correct information" do
			before do
				fill_in "Email", 			with: "example@example.com"
				fill_in "Password", 		with: "foobar"
				fill_in "Confirm Password", with: "foobar"
			end
			it "should create a user" do
				expect { click_button submit }.to change(User,:count).by(1)
			end
			describe "after saving the user" do
				before { click_button submit }
				let(:user) { User.find_by(email: 'user@example.com') }
				it { should have_link('Sign out') }
				it { should have_title('Home') }
				it { should have_selector('div.alert.alert-success', text: 'Welcome') }
			end
		end

		describe "with incorrect information" do
			describe "with incorrect email" do
				before do
					fill_in "Email", 			with: "example@example,com"
					fill_in "Password", 		with: "foobar"
					fill_in "Confirm Password", with: "foobar"
				end
				it "should not create a user" do
					expect { click_button submit }.not_to change(User,:count)
				end
			end
			describe "with incorrect password" do
				before do
					fill_in "Email", 			with: "example@example.com"
					fill_in "Password", 		with: "foobar"
					fill_in "Confirm Password", with: "Foobar"
				end
				it "should not create a user" do
					expect { click_button submit }.not_to change(User,:count)
				end
			end
			describe "with existing email" do
				let!(:existing_user) { FactoryGirl.create(:user, email: "example@example.com") }
				before do
					fill_in "Email", 			with: "example@example.com"
					fill_in "Password", 		with: "foobar"
					fill_in "Confirm Password", with: "foobar"
				end
				it "should not create a user" do
					expect { click_button submit }.not_to change(User,:count)
				end
			end
		end
	end

	#**********************************
	#Edit Account Page Tests
	#**********************************
	describe "edit account page" do
		let(:user) { FactoryGirl.create(:user) }
		before do
			sign_in user
			visit edit_user_path(user)
		end

		it { should have_title('Edit Account') }

		describe "with invalid information" do
			before { click_button "Update Account" }
			it { should have_selector('div.alert.alert-error') }
		end

		describe "with valid information" do
			let(:new_email) { "new@email.com" }
			before do
				fill_in "Email",				with: new_email
				fill_in "Password",				with: user.password
				fill_in "Confirm Password",		with: user.password
				click_button "Update Account"
			end
			it { should have_title('Home') }
      		it { should have_selector('div.alert.alert-success') }
			specify { expect(user.reload.email).to eq new_email }
		end
	end
end