#coding: utf-8
require 'transportations_helper'

class TransportationsController < ApplicationController
 before_filter :authenticate,  :only => [:edit, :update, :index, :destroy]
#=====================================================================
  def new
    @title = "Добавление заявки на перевозку"
    @transportation   = Transportation.new
    if !params[:id].nil? #ввод копированием 
      transportation_source = Transportation.find(params[:id])
      @transportation.client 			= transportation_source.client
      @transportation.storage_source 	= transportation_source.storage_source
      @transportation.storage 		= transportation_source.storage
      @transportation.weight 			= transportation_source.weight
      @transportation.date 			= transportation_source.date
      @transportation.volume 			= transportation_source.volume
      @transportation.carcase 		= transportation_source.carcase
      @transportation.start_sum 		= transportation_source.start_sum
      @transportation.step 			= transportation_source.step
      @transportation.comment			= transportation_source.comment
    end
  end

#=====================================================================
  def self.trad_start_time
    return 14
  end

#=====================================================================
  def index 
       
    if !is_admin? and !manager?
      return @transportations = Transportation.only_active.paginate(:page => params[:page])
    end
    
    begin
      @day = params[:datepicker]
      
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
#=====================================================================  
  def create
    ls = lastNum
    @transportation = Transportation.new(params[:transportation])
    @transportation.user = current_user
    # @transportation.num = ls + 1
    if @transportation.save
      # Обработка успешного сохранения.
     
      flash[:success] = "Заявка успешно добавлена"
      redirect_to :index
    else
      flash[:success] = "Проверте данные!"
      @title = "Добавление заявки на перевозку"
      render 'new'
    end
  end
  
#=====================================================================
  def show
    @transportation   = Transportation.find(params[:id])
    @title  = "Заявка # " # + @transportation.num.to_str
  end
#=====================================================================
   def edit
    @transportation = Transportation.find(params[:id])
    if (@transportation.user != current_user) or (!is_admin?)
      flash[:error] = "Вы не можете редактировать данную заявку"
      redirect_to transportations_path
    end
    @title = "Изменить заявку "
  end
#=====================================================================
  def update
    @transportation = Transportation.find(params[:id])
    if (!manager? and !is_admin?) #если не менеджер и не админ занчит делали ставку
      
      if !@transportation.is_today? and Time.zone.now.localtime.hour < TransportationsController.trad_start_time() 
        flash[:error] = "Торги еще не открыты!"
        redirect_to transportations_path
        return
      end
      @transportation.company = current_user.company
      begin
        if (params[:summa].empty?)
          @transportation.cur_sum = (@transportation.cur_sum.nil? ? @transportation.start_sum : @transportation.cur_sum) - @transportation.step #params[:cur_sum]
        else
          @transportation.cur_sum = params[:summa]
        end
      rescue
        @transportation.cur_sum = (@transportation.cur_sum.nil? ? @transportation.start_sum : @transportation.cur_sum) - @transportation.step #params[:cur_sum]
      end
      if @transportation.save! 
        flash[:success] = "Ваша ставка принята."
      else
        @title = "Error"
      end
     redirect_to @transportation
    else
      if @transportation.update_attributes!(params[:transportation])
        flash[:success] = "Заявка обновлена."
        redirect_to @transportation
      else
        @title = "Изменить заявку"
        render 'edit'
      end
    end  
  
  end

#=====================================================================  
  def confirmation #save transp. confimation (update)
    @transportation = Transportation.find(params[:id])
    @transportation.avto    = Avto.find(params[:transportation][:avto_id])
    @transportation.driver  = Driver.find(params[:transportation][:driver_id])
    @transportation.time    = params[:transportation][:time]
    if @transportation.save!
      flash[:success] = "Подтверждение сохранено"
    else
      flash[:error] = "Ошибка сохранения"
    end
    redirect_to transportations_path
  end

#=====================================================================  
  def abort #отказ от ставки
    @transportation       = Transportation.find(params[:id])
    @transportation.avto  = nil
    @transportation.driver  = nil
    @transportation.cur_sum = @transportation.cur_sum + @transportation.step
    @transportation.company =  nil
    
    if @transportation.save!
      flash[:success] = "Ваша ставка отменена"
    else
      flash[:error] = "Ошибка отмены"
    end
    redirect_to transportations_path
  end
#=====================================================================  

  def edit_conf #show page for edit conf
    @transportation = Transportation.find(params[:id])
  end

#=====================================================================  
  def get_storage
    if (params[:id] == -1)
      @transportation = Transportation.new()
    end
    client = Client.find(params[:client])
    list_storage = Storage.where("client_id=?", client);
    @html_select_tag = ""
    list_storage.each do |storage|
      @html_select_tag = @html_select_tag +"<option value="+storage.id.to_s+">"+storage.city.name+"</option>"
    end
    render :text =>@html_select_tag, :layout => false
  end

#=====================================================================
  def copy
    @title = "Ввод копированием"
    transportation_source = Transportation.find(params[:id])
    if !manager?
      flash[:error] = "Вы не можете вводить заявки"
      redirect_to transportations_path
    end
    #@title = "Изменить заявку "
    @transportation	= Transportation.new
    @transportation = transportation_source
    #render :new
  end

#=====================================================================
  def packet_loading
    @title = "Пакетная загрузка"
  end

#=====================================================================
  def load
    @title = "Пакетная загрузка"
      if Transportation.load_from_file(params[:file], current_user)
        render :text => "Загрузка закончена", :layout => false
      else
        render :text => "Ошибка", :layout => false
      end
  end
  

  
private

#=====================================================================
  def authenticate
    deny_access unless signed_in?
  end
#=====================================================================
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
