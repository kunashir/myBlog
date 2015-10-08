class SessionsController < ApplicationController
  
  skip_before_filter :require_login, only: [:new, :create]
  
  def new
    if current_user
      redirect_to profile_path
    # else
    #   @page = Page.get('login')
    end
  end

  def create
    user = login(params[:session][:email], params[:session][:password], params[:session][:remember_me])
    if user
      redirect_to root_url, notice: t("session.logged_in")
    else
      flash.now.alert = t("session.loggin_failed")
      # @page = Page.get('login')
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_url, notice: t("session.logged_out")
  end
end

#coding: utf-8
# class SessionsController < ApplicationController
#   skip_before_filter :authenticate, :only => [:new, :create]
#   def new
#     @title = "Войти"
#   end

#   def create
#     user = User.authenticate(params[:session][:email],
#                              params[:session][:password])
#     if user.nil?
#       flash.now[:error] = "Не верный email или пароль."
#       @title = "Войти"
#       render 'new'
#     else
#       # Sign the user in and redirect to the user's show page.
#       #if !user.was_login?
#         user.inc_login(request.remote_ip, request.user_agent)
#         sign_in(user, request.remote_ip, request.user_agent)

#         Log.save_log_record(nil, current_user, session[:id],  session[:id],'Session', current_user.company)
#         redirect_back_or user
#       # else
#       #   unless user.admin?
#       #     flash.now[:error] = "У Вас уже есть подключение с другого компьютера, для входа сперва завершите его"
#       #     @title = "Войти"
#       #     render 'new'
#       #   else
#       #     sign_in user
#       #     redirect_to user
#       #   end
#       # end
#       #redirect_to user
#     end
#   end

#   def destroy
#     current_user.dec_login
#     sign_out
#     redirect_to root_path
#   end


# end
