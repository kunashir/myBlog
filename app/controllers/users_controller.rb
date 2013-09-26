#coding: utf-8
class UsersController < ApplicationController
  #before_filter :authenticate,  :only => [:edit, :update, :index, :destroy]
  skip_before_filter :authenticate, :only => [:new, :create]
  before_filter :correсt_user,  :only => [:edit, :update]
  before_filter :admin_user,    :only => [:destroy ]
  #after_filter  :admin_user,    :only => [:update ]
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Пользователь удален"
    redirect_to users_path
  end
  
  def new
    @user   = User.new
    @title  = "Регистрация"
  #  save_location #сохраним локация из которой вызов на создание 
  end
  
  def show
    if !signed_in?
      deny_access
      #redirect_to root_path
      return
    end
    @user   = User.find(params[:id])
    @title  = @user.name
    if ((!manager?) or (!is_admin? )) and (@user != current_user)
	    flash[:error] = "У Вас прав для просмотра профиля другого пользователя"
	    redirect_to users_path
	    return
    end

  end

  def create
    @user = User.new(params[:user])
    if @user.save
      # Обработка успешного сохранения.
      sign_in @user   #автоматический вход
      flash[:success] = "Добро пожаловать!"
      redirect_to @user
    else
      @title = "Регистрация"
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
    if @user != current_user
      flash[:error] = "Нельзя редактировать профиль другого пользователя"
      redirect_to users_path
    end
    @title = "Изменить профиль"
  end
  
  def update
    logger.debug
    @user = User.find(params[:id])
    if (@user != current_user) and (is_admin? )
      @user.save_without_callbacks true
      if @user.toggle! :is_block
        flash[:success] = "Статус пользователя " + @user.name + " обновлен."
        redirect_to users_path
        
      else
        @title = "Изменить профиль"
        render 'edit'
        
      end


   else
    	if @user != current_user
    		flash[:error] = "У Вас нет прав редактировать данные другого пользователя"
    		redirect_to users_path
    		return
    	end 
	    @user.save_without_callbacks false
      
      # if (!is_admin?) #если не админ, то блокируем, чтобы зря не меняли данные!
      #   @user.toggle! :is_block
      # end

      if @user.update_attributes!(params[:user])
        flash[:success] = "Профиль обновлен."
        redirect_to @user
      else
        @title = "Изменить профиль"
        render 'edit'
      end
    end 

  end
  
  def index
    @title  = "Все пользователи системы"
    @users  = User.paginate(:page =>  params[:page])
  end

  def read_reg
    @user = User.find(params[:id])
    if @user != current_user
        flash[:error] = "Ошибка: Вы пытаетесь изменить данные другого пользователя!"
        redirect_to root_path
        return
    end
    if @user.show_reg?
      @user.save_without_callbacks true
      @user.toggle! :show_reg
    end
    redirect_to transportations_path
  end
private

  # def authenticate
  #   deny_access unless signed_in?
  # end
  
  def correсt_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless (current_user?(@user) or is_admin?)
   
  end
  
  def admin_user
    #redirect_to(root_path) unless current_user.admin?
  end
end
