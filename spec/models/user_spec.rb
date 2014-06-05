# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  company    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :name => "Example user",
               :email => "someemail@gmail.com",
               :company => "some trans",
               :password => "foobar",
               :password_confirmation => "foobar"}
    @user = FactoryGirl.create :user
  end

  it "should create a new instance given valid attribures" do
    #User.create!(@attr)
    @user.should be_valid
  end


  it "should require a name" do
    #no_name_user = User.new(@attr.merge(:name => ""))
    @user.name = nil
    @user.should_not be_valid
  end

  it "should require a email address" do
    #no_email_user = User.new(@attr.merge(:email => ""))
    @user.email = nil
    @user.should_not be_valid
  end

  it "should require a company name" do
    @user.company = nil
    @user.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = "a" * 51
    @user.name = long_name
    @user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      #valid_email_user = User.new(@attr.merge(:email => address))
      @user.email = address
      @user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      @user.email = address
      @user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses identical up to case" do
    # Put a user with given email address into the database.
    user_with_duplicate_email = User.new(@attr.merge(:email => @user.email))
    user_with_duplicate_email.should_not be_valid
  end

  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "should reject shourt passwords" do
      short = "a"*5;
      hash  = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "should reject long password" do
      long = "a"*41
      hash = @attr.merge(:password => long, :password_confirmation => long )
      User.new(hash).should_not be_valid
    end
  end

  describe "password encryption" do

    # before(:each) do
    #   @user = User.create!(@attr)
    # end

    it "should have an encrypted password attribure" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do

      it "should be true if the passwords match" do
        @user.has_password?(@user.password).should be_true
      end

      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end
    end
  end

  context 'methods for mailer' do
    it "return all email of transportation company" do
      co = FactoryGirl.create :company
      email_arr = Array.new
      User.includes(:company).where("companies.id <> ?", co).select("email").each{|x| email_arr << x.email}
      User.carriers_email(co) == email_arr
    end

  end
end
