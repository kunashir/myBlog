#coding: utf-8
require 'spec_helper'


describe SessionsController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Войти")
    end
  end

  describe "POST 'create'" do

    describe "invalid signin" do

      before(:each) do
        @attr = { :email => "email@example.com", :password => "invalid" }
      end

      it "should re-render the new page" do
        post :create, :session => @attr
        response.should render_template('new')
      end

      # it "should have the right title" do
      #   post :create, :session => FactoryGirl.attributes_for(:user)
      #   response.should have_selector("title", :content => @user.name)
      # end

      it "should have a flash.now message" do
        post :create, :session => @attr
        flash.now[:error].should =~ /Не верный email или пароль./i
      end
    end

    describe "with valid email and password" do

      before(:each) do
        #@user = Factory(:user)
        @user = FactoryGirl.create :manager
        @attr = { :email => @user.email, :password => @user.password }
      end

      it "should sign the user in" do
        post :create, :session => @attr
        # Fill in with tests for a signed-in user.
      end

      it "should redirect to the user show page" do
        post :create, :session => {:email => 'admin@roshen.ru', :password => 'password'}
        response.should redirect_to(user_path(@user))
      end
    end
  end

end
