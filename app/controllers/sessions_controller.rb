#coding: utf-8
class SessionsController < ApplicationController
  skip_before_filter :authenticate, :only => [:new, :create]
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
      if !user.was_login?
        user.inc_login
        sign_in user
        Log.save_log_record(nil, current_user, session[:id],  session[:id],'Session', current_user.company)
        redirect_back_or user
      else
        flash.now[:error] = "У Вас уже есть подключение с другого компьютера, для входа сперва завершите его"
        @title = "Войти"
        render 'new'
      end
      #redirect_to user 
    end
  end
  
  def destroy
    current_user.dec_login
    sign_out
    redirect_to root_path
  end
  

end
