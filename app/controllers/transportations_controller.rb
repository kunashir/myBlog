#coding: utf-8
class TransportationsController < ApplicationController
 before_filter :authenticate,  :only => [:edit, :update, :index, :destroy]
  def new
    @title = "Добавление заявки на перевозку"
    @transportation   = Transportation.new
    
  end
  
  def index 
       
    begin
      @day = params[:date][:cur_date]
      
    rescue
     @day = Date.current
    end
    @title = "Список заявок:"  + @day.to_s
    if is_block_user?
      flash[:error] = "У Вас нет прав для просмотра заявок!"
      redirect_back_or current_user
    end
    @transportations  = Transportation.transportation_for_date(@day).paginate(:page =>  params[:page])
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
      
      if Time.zone.now.localtime.hour < 14 
        flash[:error] = "Торги еще не открыты!"
        redirect_to transportations_path
      end
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
  
  def confirmation #save transp. confimation (update)
  
  end
  
  def edit_conf #show page for edit conf
  
  end
  
  
private
  def authenticate
    deny_access unless signed_in?
  end
  
  def lastNum
    if Transportation.last().nil?
      return 0
    end
    if Transportation.last().num.nil? 
      return 0
    else
      return Transportation.last().num
    end
  end

end
