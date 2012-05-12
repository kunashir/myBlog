#coding: utf-8
class TransportationsController < ApplicationController
 before_filter :authenticate,  :only => [:edit, :update, :index, :destroy]
  def new
    @title = "Добавление заявки на перевозку"
    @transportation   = Transportation.new
    
  end
  
  def index
    @title = "Список заявок:"
    @transportations  = Transportation.paginate(:page =>  params[:page])
  end
  
  def create
    ls = lastNum
    @transportation = Transportation.new(params[:transportation])
    @transportation.user = current_user
    @transportation.num = ls + 1
    if @transportation.save
      # Обработка успешного сохранения.
     
      flash[:success] = "Заявка успешно добавлена"
      redirect_to :index
    else
      @title = "Добавление заявки на перевозку"
      render 'new'
    end
  end
  
  def show
    @transportation   = Transportation.find(params[:id])
    @title  = "Заявка # " # + @transportation.num.to_str
  end
  
   def edit
    @transportation = Transportation.find(params[:id])
    if @transportation.user != current_user or !is_admin?
      flash[:error] = "Вы не можете редактировать данную заявку"
      redirect_to transportations_path
    end
    @title = "Изменить заявку "
  end

  def update
    @transportation = Transportation.find(params[:id])
    if !manager? and !is_admin? #если не менеджер и не админ занчит делали ставку
      #params[:company] = current_user.company
      @transportation.company = current_user.company
      @transportation.cur_sum = (@transportation.cur_sum.nil? ? @transportation.start_sum : @transportation.cur_sum) - @transportation.step #params[:cur_sum]
      if @transportation.update_attributes(params[:user])
        flash[:success] = "Ваша ставка принята."
      else
        @title = "Error"
      end
     redirect_to @transportation
    end  
  
  end
  
private
  def authenticate
    deny_access unless signed_in?
  end
  
  def lastNum
    if Transportation.last().nil?
      return 0
    end
    return  0 unless !Transportation.last().num.nil?
  end

end
