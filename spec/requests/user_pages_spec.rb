require 'spec_helper'

describe "UserPages" do

	subject { page }

	shared_examples_for "all user pages" do
		it { should have_title(full_title(page_title)) }
	end

	describe "signup page" do
		before { visit signup_path }

		let(:submit) { "Create my account" }
		let(:page_title) { 'Sign Up' }
		it_should_behave_like "all user pages"
		it { should have_content 'Sign Up'}

		describe "with correct information" do
			before do
				fill_in "Email", 			with: "example@example.com"
				fill_in "Password", 		with: "foobar"
				fill_in "Confirm Password", with: "foobar"
			end
			it "should create a user" do
				expect { click_button submit }.to change(User,:count).by(1)
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
end
