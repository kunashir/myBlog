# coding: utf-8
require 'spec_helper'

describe PagesController do
	render_views
	
	before(:each) do
		@base_title = "Реестр перевозок"
	end
	
  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end
    
    it "should have the right title" do
			get 'home'
			response.should have_selector("title", 
						:content => @base_title + " | Главная")
		end
  end
  
  
  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
  end

end
