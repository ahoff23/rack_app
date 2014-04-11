require 'spec_helper'

describe User do
  #Create a user to run tests on
  before { @user = User.new(email: "example@foobar.com",
  	password: "foobar", password_confirmation: "foobar") }
  subject { @user }

  #*****************************
  #Attribute Tests
  #*****************************
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should_not be_admin }

  #*****************************
  #Admin Tests
  #*****************************
  describe "admin attribute" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end
    it { should be_admin }
  end

  #*****************************
  #Remember Toekn Tests
  #*****************************
  describe "remember token" do
    before { @user.save }
    #Make sure each user has a remember_token
    its(:remember_token) { should_not be_blank }
  end

  #*****************************
  #Validation Tests
  #*****************************
  describe "validation tests" do
  	#Before nullifying any attributes, @user should be valid
  	it { should be_valid }

  	describe "for email" do
  		before { @user.email = "" }
  		it { should_not be_valid }
  	end
  end

  #*****************************
  #Uniqueness Tests
  #*****************************
  describe "uniqueness tests" do
  	before { @user.save! }
  	 describe "for email" do
  		before { @other_user = User.new(email: @user.email.upcase,
  			password: "foobar", password_confirmation: "foobar") }
  		specify { expect(@other_user).not_to be_valid }
  	end
  end

  #*****************************
  #Format Tests
  #*****************************
  describe "format tests" do
  	describe "when email format is invalid" do
  		addresses = %w[user@foo,com user_at_foo.org example.user@foo.
  			foo@bar_baz.com foo@bar+baz.com]
  		addresses.each do |invalid_address|
  			before { @user.email = invalid_address }
  			it { should_not be_valid }
  		end
  	end

  	describe "when email format is valid" do
  		addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
  		addresses.each do |valid_address|
  			before { @user.email = valid_address }
  			it { should be_valid }
  		end
  	end
  end

  #*****************************
  #Password Tests
  #*****************************
  describe "wehn password is not present" do
  	before do
  		@user.password = ""
  		@user.password_confirmation = ""
  	end
  	it { should_not be_valid }
  end

  describe "when password does not match password confirmation" do
  	before { @user.password_confirmation = "FOOBAR" }
  	it { should_not be_valid }
  end

  #*****************************
  #Password Authentication Tests
  #*****************************
  describe "with a password that's too short" do
  	before { @user.password = @user.password_confirmation = "a" * 5 }
  	it { should be_invalid }
  end

  describe "return value of authenticate method" do
  	before { @user.save }
  	let(:found_user) { User.find_by(email: @user.email) }

  	describe "with valid password" do
  		it { should eq found_user.authenticate(@user.password) }
  	end

  	describe "with invalid password" do
  		let(:user_for_invalid_password) { found_user.authenticate("invalid") }
  		it { should_not eq user_for_invalid_password }
  		specify { expect(user_for_invalid_password).to be_false }
  	end
  end
end