#coding: utf-8
class SessionsController < ApplicationController
  def new
    @title = "Войти"
  end
  
  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Не верный email или пароль."
      @title = "Войти"
      render 'new'
    else
      # Sign the user in and redirect to the user's show page.
      sign_in user
      redirect_back_or user
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
  

end