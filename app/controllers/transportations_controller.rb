#coding: utf-8
#ecoding: utf-8
require 'transportations_helper'
require 'encode.rb'

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
def get_list_transp (parameters)
    @filter_text = ""
    begin
      @day = parameters[:datepicker]
      
    rescue
     @day = Date.current
    end
    hide_today = false
    if check_time == 0 
      hide_today = true
    end
    title = "Список заявок:"  + @day.to_s
    show_all = parameters[:show_all].nil? ? false : true
    area_name = ""
    if parameters[:use_area].nil?
      storage_source = ""
    else
      storage_source = parameters[:area]
      area_name = storage_source.nil? ? "": Area.find(storage_source).name 
    end
    @filter_text = @day.to_s + " " + area_name
    @transportations  = Transportation.set_filter(@day, show_all, storage_source, hide_today).paginate(:page =>  parameters[:page], :per_page => 50)
end
#====================================================================
def export
    headers['Content-Type'] = "application/vnd.ms-excel"
    headers['Content-Disposition'] = 'attachment; filename="report.xls"'
    headers['Cache-Control'] = ''
    #@transportations = Transportation.only_active.paginate(:page => params[:page], :per_page => 50)
    puts ("EXPORT=>" + params.to_s)
    get_list_transp(params)
    render :index , :layout => false
end

#=====================================================================
  def index 
    
    if is_block_user?
      flash[:error] = "У Вас нет прав для просмотра заявок!"
      redirect_back_or current_user
      return 
    end

    if current_user.show_reg?
      flash[:error] = "Для продолжения Вам слеудет прочитать регламент"
      redirect_to root_path + "/help"
    end

    get_list_transp(params)
    @cur = 1
  end
#=====================================================================  
  def create
    ls = lastNum
    @transportation = Transportation.new(params[:transportation])
    @transportation.user = current_user
    if !@transportation.set_rate
		  flash[:error] = "Не найден тариф!"
		  @title = "Добавление заявки на перевозку"
		  render 'new'
		  return
	  end
    # @transportation.num = ls + 1
    if @transportation.save
      # Обработка успешного сохранения.
     
      flash[:success] = "Заявка успешно добавлена"
      redirect_to :index
    else
      flash[:error] = "Проверте данные!"
      @title = "Добавление заявки на перевозку"
      render 'new'
    end
  end
  
#=====================================================================
  def show
    @transportation   = Transportation.find(params[:id])
    @title  = "Заявка # " # + @transportation.num.to_str
    if (!manager?) and (!is_admin?)
      flash[:error] = "Вы не можете просматривать детализация по заявке!"
      redirect_to transportations_path
      return
    end
  end

#=====================================================================
   def edit
    @transportation = Transportation.find(params[:id])
    if (!manager?) and (!is_admin?)
      flash[:error] = "Вы не можете редактировать данную заявку"
      redirect_to transportations_path
    end
    @title = "Изменить заявку "
  end
  
#=====================================================================  
  def check_captcha
	#if !simple_captcha_valid?
  if !verify_recaptcha
		Log.save_log_record(@transportation, current_user, params[:recaptcha_response_field],  session[:recaptcha_challenge_field],'Captcha', current_user.company)
	  flash[:error] = "Вы ввели не правильную каптчу"
	  render "do_rate"
	  return -1
	end
	return 0
  end

#=====================================================================
  def spec_price
	@transportation = Transportation.find(params[:id])
	
	if check_captcha == -1 
	  return
	end

  if percent_spec_price == 0 
    return
  end

	#if !@transportation.valid_with_captcha?
	@transportation.set_user(current_user)
	if (manager? or  is_admin?)
		flash[:error] = "Вы не можете делать ставки"
		redirect_to transportations_path
		return
	end
	
	#if !@transportation.is_today? and Time.zone.now.localtime.hour < TransportationsController.trad_start_time()
	if (!@transportation.is_today?) and (check_time(@transportation.get_time) == -1)
	       flash[:error] = "Торги еще не открыты!"
	       redirect_to transportations_path
	       return
    end
    if (check_time(@transportation.get_time) == 1) and (@transportation.is_busy?)#Если вермя больше 15 и ставка занято,
        	 # то торговатся больше нельзя
	         flash[:error] = "Торги уже закончились!"
		   redirect_to transportations_path
	       return
	end

	
	@transportation.cur_sum = (@transportation.start_sum)*(1 - percent_spec_price/100.00)
	
	
	if (@transportation.specprice) or (!@transportation.company.nil?) #на случай, если два запроса подряд
    flash[:error] = "К сожалению, заявку уже забрали!!!"
    redirect_to transportations_path
    return
  end
  @transportation.specprice = true
  @transportation.company = current_user.company
  if @transportation.save!
	        flash[:success] = "Поздравляем данная перевозка уже ваша."
	else
	        @title = "Ошибка сохранения!"
  end
	redirect_to transportations_path
  end

#=====================================================================
  def save_rate
    @transportation = Transportation.find(params[:id])
    if simple_captcha_valid?
      flash[:success] = "Captcha ok"
    else
      flash[:error] = "Wrong captch"
    end
    redirect_to transportations_path
  end
#=====================================================================
  def do_rate
    @transportation = Transportation.find(params[:id])
        #redirect_to transportations_path
  end
	
#=====================================================================
  def do_spec_rate
    if percent_spec_price == 0
       flash[:error] = "Ставки по спец. цене отключены"
       redirect_to transportations_path
       return
    end
    @transportation = Transportation.find(params[:id])
        #redirect_to transportations_path
  end
#=====================================================================
  def update
       
    
    if (!manager? and !is_admin?) #если не менеджер и не админ занчит делали ставку
	  
      if check_captcha == -1 
    		return
      end 
      Transportation.transaction do
        @transportations = Transportation.lock.find(params[:id])
        if (!@transportation.is_today?) and (check_time(@transportation.get_time) == -1) 
          flash[:error] = "Торги еще не открыты!"
          redirect_to transportations_path
          return
        end
        if (check_time(@transportation.get_time) == 1) and (@transportation.is_busy?)#Если вермя больше 15 
          #проверим не продленно ли время по заявке
          #if !is_ext_time?(Time.zone.now.localtime, (@transportation.get_time+14400))
            #проверяем нельзя ли использовать расширенное время
            # и ставка занята, то торговатся больше нельзя
            flash[:error] = "Торги уже закончились!"
            redirect_to transportations_path
            return
          #end
        end
       
        if @transportation.specprice #на случай, если два запроса подряд
             flash[:error] = "К сожeлению, заявку уже забрали со скидкой "+ percent_spec_price.to_s + "%!!!"
             redirect_to transportations_path
             return
        end

        
        #Проверим не послдение ли минуты, если да то проверим делал ли чел ставки до этого
        # if (is_last_moment?) and (@transportation.is_busy?)
        #   if !Log.company_has_stake(@transportation, current_user.company) 
        #       flash[:error] = "У Вас не было ставок до этого, поэтому Вы не можете перебить ставку других компаний в последние минуты"
        #       redirect_to transportations_path
        #       return 
        #   end
        # end



        @transportation.company = current_user.company
        #Если не было ни одной ставки, то нач. сумму увеличим на сумму шага, чтобы первая стака как раз вышла на базовую суммуы
        start_summa = (@transportation.cur_sum.nil? or @transportation.cur_sum == 0)  ? (@transportation.start_sum + @transportation.step ): @transportation.cur_sum 
        #суммы из параметров не должно быть во время основного хода торгов, и она не должна быть отрицательной
        #params_summa = 0
    	  begin
        	params_summa = params[:summa].to_i.abs
        rescue
          params_summa = 0
        end
      		
        if (params_summa == 0) and (check_time(@transportation.get_time) == 0)
          @transportation.cur_sum = start_summa - @transportation.step #params[:cur_sum]
        else #Случай, когда сумма задана в параметре (обычно это после торгов идет)
            if (@transportation.abort_company == current_user.company_id)
                flash[:error] = "Вы не можете играть на повышение, т.к. до этого отказались от заявки"
                redirect_to transportations_path
                return
            end
            if (@transportation.start_sum*upper_limit < params_summa)
              flash[:error] = "Не стоит наглеть! Предел повышения 15% от базовых тарифов"
              redirect_to transportations_path
              return
            end
            @transportation.cur_sum = params_summa
        end
        # rescue
        #   @transportation.cur_sum = start_summa - @transportation.step #params[:cur_sum]
        # end
        @transportation.abort_company = nil
        if @transportation.save!
          flash[:success] = "Ваша ставка принята."
        else
          @title = "Error"
          flash[:error] = "Ошибка сохранения сообщите об этом разработчикам (transp_contr:204)."
        end
        redirect_to transportations_path
      end
    else
      @transportation = Transportation.find(params[:id]) 
      @transportation.set_user(current_user)
      if @transportation.update_attributes!(params[:transportation])
        flash[:success] = "Заявка обновлена."
        redirect_to transportations_path #при сохранение сразу на список
      else
        @title = "Изменить заявку"
        render 'edit'
      end
    end  
  
  end

#=====================================================================  
  def confirmation #save transp. confimation (update)
  	@transportation = Transportation.find(params[:id])
  	if (params[:transportation][:avto_id].nil?) or (params[:transportation][:driver_id].nil?)
  		flash[:error] = "Поле машина или водитель не могут быть пустыми"
  		render :edit_conf
  		return
  	end
  	
  	@transportation.set_user(current_user)
  	@transportation.avto    = Avto.find(params[:transportation][:avto_id])
  	@transportation.driver  = Driver.find(params[:transportation][:driver_id])
  	@transportation.time    = params[:transportation]['time(4i)'] + ":" + params[:transportation]['time(5i)']
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
    @transportation.set_user(current_user)
    @transportation.avto  = nil
    @transportation.driver  = nil
    #Запомним последнего отказника, чтобы после окончания не смог сыграть на 
    #повышение
    @transportation.abort_company = @transportation.company_id

    old_cur_sum = @transportation.cur_sum
    if (@transportation.have_spec_price?) or (check_time(@transportation.get_time) == 1)
      @transportation.cur_sum = 0
      @transportation.specprice = false
    else
      @transportation.cur_sum = @transportation.cur_sum + @transportation.step
      if @transportation.cur_sum > @transportation.start_sum
          @transportation.cur_sum = @transportation.start_sum
      end
    end
    company_aborting = @transportation.company
    @transportation.company =  nil
    
    if @transportation.save!
      flash[:success] = "Ваша ставка отменена"
      Log.save_log_record(@transportation, current_user, "cur_sum", old_cur_sum,'abort record', current_user.company)
      if (check_time(@transportation.get_time) == 1) # Если отмена после окончания отправим другим уведомление
        UserMailer.notification_to_companies(@transportation, company_aborting)
      end
    else
      flash[:error] = "Ошибка отмены"
    end
    redirect_to transportations_path
  end

#===================================================================== 
  def request_abort #запрос отмены для заявок на сегодня
    @transportation       = Transportation.find(params[:id])
    @transportation.set_user(current_user)
    @transportation.request_abort = true
    if @transportation.save!
      flash[:success] =  "Запрос на отмену сохранен, свяжитесь с представителем ООО Рошен для подтверждения отказа"
      UserMailer.request_abort(@transportation)
      
    else
      flash[:error] = "Ошибка отмены"
    end
    redirect_to transportations_path

  end
#=====================================================================  
  def confirm_abort
	 @transportation       = Transportation.find(params[:id])
	 @transportation.set_user(current_user)
	 @transportation.abort_company = @transportation.company
	 @transportation.avto  = nil
	 @transportation.driver  = nil
	 @transportation.request_abort = false
	 if @transportation.have_spec_price?
	      @transportation.cur_sum = 0
	      @transportation.specprice = false
	 elsif (@transportation.cur_sum > @transportation.start_sum)
	        @transportation.cur_sum = 0
	 else
	      @transportation.cur_sum = @transportation.cur_sum + @transportation.step
	 end
	 company_aborting = @transportation.company
	 @transportation.company =  nil
    	 
	 if @transportation.save!
	      flash[:success] = "Отказ подтвержден"
	      UserMailer.notification_to_companies(@transportation, company_aborting)
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
  def server_time
	render :text => Time.zone.now.localtime.to_s[11, 8]
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
    #  if Transportation.load_from_file(params[:file], current_user)
    #    render :text => "Загрузка закончена", :layout => false
    #  else
    #    render :text => "Ошибка", :layout => false
    #  end
    uploaded_io = params[:file]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename),'w') do |file|
       text = uploaded_io.read
 
            file.write(text.force_encoding("WINDOWS-1251").encode("UTF-8"))
      
    end
    #return
    #@text_of_load = "Ошибка загрузки"
    if Transportation.load_from_file(Rails.root.join('public', 'uploads', uploaded_io.original_filename), current_user)
        flash[:success] = "Заявки успешно загружены"
        redirect_to transportations_path
        return
    else
        flash[:error] = "Ошибка загрузки"
    end
    render packet_loading  
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
