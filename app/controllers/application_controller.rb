#coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include TransportationsHelper
  #include SimpleCaptcha::ControllerHelpers
  before_filter :authenticate
  
  private
  def authenticate
    unless signed_in?
      flash[:error] = "Для доступа к этому разделу спрева авторизируйтесь!!!"
      redirect_to signin_path
    end
  end
end
