#coding: utf-8
class UsersController < ApplicationController
  before_filter :authenticate,  :only => [:edit, :update, :index, :destroy]
  before_filter :correсt_user,  :only => [:edit, :update]
  before_filter :admin_user,    :only => :destroy
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Пользователь удален"
    redirect_to users_path
  end
  
  def new
    @user   = User.new
    @title  = "Регистрация"
  end
  
  def show
    @user   = User.find(params[:id])
    @title  = @user.name
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      # Обработка успешного сохранения.
      sign_in @user   #автоматический вход
      flash[:success] = "Добро пожаловать в Реестр перевозок ООО \"Рошен\"!"
      redirect_to @user
    else
      @title = "Регистрация"
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
    @title = "Изменить профиль"
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Профиль обновлен."
      redirect_to @user
    else
      @title = "Изменить профиль"
      render 'edit'
    end
  end
  
  def index
    @title  = "Все пользователи системы"
    @users  = User.paginate(:page =>  params[:page])
  end
private

  def authenticate
    deny_access unless signed_in?
  end
  
  def correсt_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
  
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
