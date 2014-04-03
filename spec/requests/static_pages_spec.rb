require 'spec_helper'

describe "Static Pages" do

	subject { page }

	#Test attributes common to all static pages
	shared_examples_for "all static pages" do 
		it { should have_title(full_title(page_title)) }
	end

	describe "home page" do
		before { visit root_path }

		#The page title should be "Home"
		let (:page_title) { 'Home' }
		it_should_behave_like "all static pages"
	end

	describe "contact page" do
		before { visit contact_path }

		#The page title should be "Contact"
		let (:page_title) { 'Contact' }
		it_should_behave_like "all static pages"
	end

	describe "help page" do
		before { visit help_path }
		
		#The page title should be "Help"
		let (:page_title) { 'Help' }
		it_should_behave_like "all static pages"
	end

	describe "about page" do
		before { visit about_path }
		
		#The page title should be "About Us"
		let (:page_title) { 'About Us' }
		it_should_behave_like "all static pages"
	end
end