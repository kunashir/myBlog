#coding: utf-8
#ecoding: utf-8
require 'transportations_helper'
#require 'encode.rb'

class TransportationsController < ApplicationController
  skip_before_filter :authenticate ,  :only => [:server_time] #:edit, :update, :index, :destroy, :get_form, :show_history]
  before_filter :log_do_rate, :only => [:update]
  before_filter :manager_access, :only => [:show_history, :load, :destroy, :create, :new, :show]
  before_filter :check_block, :only => [:update, :index, :do_rate, :do_spec_rate]


  def get_form
    @transportation = Transportation.find(params[:id])
    render "_do_rate_form", layout: false
  end

  def show_history
    @transportation = Transportation.find(params[:id])
    @logs = Log.transp_history(@transportation)
    render "_history_form", layout: false
  end

  def destroy
    Transportation.find(params[:id]).destroy
    flash[:success] = "Заявка удалена"
    redirect_to transportations_path
  end

#=====================================================================
  def new
    @title = "Добавление заявки на перевозку"
    @transportation   = Transportation.new
    if !params[:id].nil? #ввод копированием
      transportation_source = Transportation.find(params[:id])
      @transportation = transportation_source.dup
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
    #hide_today = false
    hide_today = is_trade?

    @title = "Список заявок:"  + @day.to_s
    show_all = parameters[:show_all].nil? ? false : true
    area_name = ""
    if parameters[:use_area].nil?
      storage_source = ""
    else
      storage_source = parameters[:area]
      area_name = storage_source.nil? ? "": Area.find(storage_source).name
    end
    @filter_text = @day.to_s + " " + area_name
    @transportations  = Transportation.set_filter(@day, show_all, storage_source, hide_today, parameters[:page], 50) #.paginate(:page =>  parameters[:page], :per_page => 50)
  end
  #====================================================================
  def export
    headers['Content-Type'] = "application/vnd.ms-excel"
    headers['Content-Disposition'] = 'attachment; filename="report.xls"'
    headers['Cache-Control'] = ''
    #@transportations = Transportation.only_active.paginate(:page => params[:page], :per_page => 50)
    #puts ("EXPORT=>" + params.to_s)
    get_list_transp(params)
    render :index , :layout => false
  end

  #=====================================================================
  def index

    if current_user.show_reg?
      flash[:error] = "Для продолжения Вам слеудет прочитать регламент"
      redirect_to  help_path #root_path + "/help"
    end

    get_list_transp(params)
    # company = current_user.manager? ? nil : current_user.company
    @confirmed_orders = Transportation.confirmed(current_user.company)
    @not_confirmed_orders = Transportation.not_confirmed(current_user.company)
    @cur = 1
  end
  #=====================================================================
  def create

    @transportation = Transportation.new(tender_params)
    @transportation.extra_pay = 0 if !@transportation.complex_direction
    @transportation.user = current_user
    if !@transportation.set_rate
      flash[:error] = "Не найден тариф!"
      # @title = "Добавление заявки на перевозку"
      render 'new'
      return
    end
    # @transportation.num = ls + 1
    if @transportation.save
      # Обработка успешного сохранения.

      flash[:success] = "Заявка успешно добавлена"
      redirect_to :index
    else
      flash[:error] = "Проверьте данные!"
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
    end
  end

  #=====================================================================
  def edit
    @transportation = Transportation.find(params[:id])
    if (!manager?) && (!is_admin?)
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
      flash[:error] = "Вы ввели не правильную капчу"
      render "do_rate"
      return false
    end
    return true
  end

#=====================================================================
  def spec_price
  #@transportation = Transportation.find(params[:id])
    Transportation.transaction do

        @transportation = Transportation.lock.find(params[:id])
        @transportation.set_user(current_user)

        return if  !check_captcha

        if percent_spec_price == 0 or @transportation.abort_company
          flash[:error] = "Спец. цена не активна!"
          redirect_to transportations_path
          return
        end

        #if !@transportation.valid_with_captcha?
        #@transportation.set_user(current_user)
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


        if (@transportation.specprice) or (!@transportation.company.nil?) #на случай, если два запроса подряд
          flash[:error] = "К сожалению, заявку уже забрали!!!"
          redirect_to transportations_path
          return
        end

        #@transportation.cur_sum = (@transportation.start_sum)*(1 - percent_spec_price/100.00)
        @transportation.bet(percent_spec_price)
        #@transportation.specprice = true
        @transportation.company = current_user.company
        @transportation.last_bid_at = Time.now
        if @transportation.save
          flash[:success] = "Поздравляем данная перевозка уже ваша."
        else
          @title = "Ошибка сохранения!"
        end
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

      Transportation.transaction do

        @transportation = Transportation.lock.find(params[:id])
        @transportation.set_user(current_user)

        return if !check_captcha

        trade_status = check_time(@transportation.get_time) #check it's only one time

        if (!@transportation.is_today?) and (trade_status == -1)
          flash[:error] = "Торги еще не открыты!"
          redirect_to transportations_path
          return
        end
        if (trade_status != 0) and (@transportation.is_busy?)#Если вермя больше 15
            flash[:error] = "В данный момент торги не проводятся и заявка уже закрыта!"
            redirect_to transportations_path
            return
          #end
        end

        if @transportation.specprice #на случай, если два запроса подряд
          flash[:error] = "К сожалению, заявку уже забрали со скидкой "+ percent_spec_price.to_s + "%!!!"
          redirect_to transportations_path
          return
        end

        @transportation.company = current_user.company

        begin
          params_summa = params[:summa].to_i.abs
        rescue
          params_summa = 0
        end

        if (params_summa == 0) and (trade_status == 1)
          flash[:error] = "Ошибка в указанной сумме"
          redirect_to transportations_path
          return
        end

        #if (@transportation.abort_company == current_user.company_id)
        if Log.company_refused?(@transportation, current_user.company)
          flash[:error] = "Вы не можете играть на повышение, т.к. до этого отказались от заявки"
          redirect_to transportations_path
          return
        end


        if trade_status == 0
          @transportation.bet
        else #Случай, когда сумма задана в параметре (обычно это после торгов идет)

            if ((@transportation.rate_summa)*upper_limit < params_summa)
              flash[:error] = "Не стоит наглеть! Предел повышения 15% от базовых тарифов"
              redirect_to transportations_path
              return
            end
            @transportation.cur_sum = params_summa
        end
        @transportation.last_bid_at = Time.now
        if @transportation.save
          flash[:success] = "Ваша ставка принята."
        else
          @title = "Ошибка"
          flash[:error] = "Ошибка сохранения. Сообщите об этом разработчикам."
        end
        redirect_to transportations_path
      end
    else
      @transportation = Transportation.find(params[:id])
      @transportation.set_user(current_user)
      if @transportation.update_attributes!(tender_params)
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
    
    avto_params = confirmation_params[:avto_attributes]
    driver_params = confirmation_params[:driver_attributes]

    @transportation.set_user(current_user)
    if !confirmation_params[:avto_id].blank?
      @transportation.avto    = Avto.find_by(id: params[:transportation][:avto_id])
    else
      avto = Avto.new(avto_params.merge({company: current_user.company}))
      if avto.save
        @transportation.avto = avto
      else
        flash[:error] = "Ошибка в данных автомобиля!"
        render :edit_conf
        return
      end
    end

    if !confirmation_params[:driver_id].blank?
      @transportation.driver    = Driver.find_by(id: params[:transportation][:driver_id])
    else
      driver = Driver.new(driver_params.merge({company: current_user.company}))
      if driver.save
        @transportation.driver = driver
      else
        flash[:error] = "Ошибка в данных водителя!"
        render :edit_conf
        return
      end
    end
    
    if @transportation.save
      flash[:success] = "Подтверждение сохранено"
      redirect_to transportations_path
    else
      flash[:error] = "Ошибка сохранения"
      render :edit_conf
    end
  end

#=====================================================================
  def abort #отказ от ставки
    @transportation       = Transportation.find(params[:id])
    if current_user.company != @transportation.company
      flash[:error] = "Вы не можете отказать от чужой ставки!!!"
      redirect_to transportations_path
      return
    end
    @transportation.set_user(current_user)
    @transportation.avto  = nil
    @transportation.driver  = nil
    #Запомним последнего отказника, чтобы после окончания не смог сыграть на
    #повышение
    @transportation.abort_company = @transportation.company_id

    old_cur_sum = @transportation.cur_sum
   # if (@transportation.have_spec_price?) or (check_time(@transportation.get_time) == 1)
    #try to get previous values
    old_company = Log.prev_company(@transportation, @transportation.company)
    old_sum = Log.prev_summa(@transportation, @transportation.company)

    company_aborting = @transportation.company
    @transportation.cur_sum = old_sum
    @transportation.company = old_company
    @transportation.specprice = false
    @transportation.last_bid_at = nil
    if @transportation.save
      flash[:success] = "Ваша ставка отменена"
      Log.save_log_record(@transportation, current_user, "cur_sum", old_cur_sum,'abort record', current_user.company)
      if (check_time(@transportation.get_time) == 1) # Если отмена после окончания отправим другим уведомление
        UserMailer.notification_to_companies(@transportation, company_aborting)
        UserMailer.notificate_manager(@transportation, old_cur_sum)
      end
      if !old_company.nil? #if return to old company - sent him notification
        if (check_time(@transportation.get_time) == 1)
          UserMailer.notification_old_company(@transportation, old_company)
        end
        msg = Message.new(:content => "Заявка #{@transportation.to_s} снова ваша из-за отказа другой компании!!!")
        msg.save
        old_company.users.each do |usr|
          usr.messages<<msg
        end
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
    if @transportation.save
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
    @transportation.last_bid_at = nil
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
    # if (params[:id] == -1)
    #   @transportation = Transportation.new()
    # end
    client = Client.find(params[:client])
    list_storage = City.cities_for(client) #Storage.where("client_id=?", client);
    @html_select_tag = ""
    list_storage.each do |storage|
      @html_select_tag = @html_select_tag +"<option value="+storage.id.to_s+">"+storage.name+"</option>"
    end
    render :text =>@html_select_tag, :layout => false
  end

#=====================================================================
  def get_start_sum
    begin
      storage = City.find(params[:storage])
      area = Area.find(params[:area])
      carcase = params[:carcase].to_s
      weight = params[:weight].to_i
      render :text => Rate.find_rate(area, storage, carcase).get_summa(weight)
    rescue
      render :text => '0'
    end
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
    @transportation  = Transportation.new
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
      file.write(text.force_encoding("WINDOWS-1251").encode("UTF-8", undef: :replace))

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

  # return data for show chart
  def chart_data
    start_sums = Transportation.where("date > ? AND company_id IS NOT NULL", Date.today - 6.days)
      .order(:date).group(:date).sum(:start_sum)
    cur_sums = Transportation.where("date > ? AND company_id IS NOT NULL", Date.today - 6.days)
      .order(:date).group(:date).sum(:cur_sum)
    data = []
    current_date = nil
    start_sums.each do |k, v|
      data << {
        day: k,
        tarif: v,
        real: cur_sums[k]
      }
    end
    render json: data, layout: false
  end

private

  def confirmation_params
    params.require(:transportation).permit(:avto_id, :driver_id,
      avto_attributes: [:model, :carcase, :statenumber, :trailnumber],
      driver_attributes: [:name, :passport]
    )
  end

  
  def tender_params
    params.require(:transportation).permit(:num, :date, :time, :comment,
      :type_transp, :weight, :carcase, :start_sum, :cur_sum, :step, :company_id, :volume,
      :client_id, :storage_id, :abort_company, :area_id, :company, :city_id, :complex_direction, 
      :extra_pay, :unloading
    )
  end

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

  def log_do_rate
    Log.save_log_record(Transportation.find(params[:id]), current_user, "cur_time", Time.zone.now.localtime,'Request time', current_user.company)
  end

  def manager_access
    if !manager?
      flash[:danger] = "Нет прав для данного действия!"
      redirect_back_or current_user#transportations_path
      false
    end
  end

  def check_block
    if is_block_user?
      flash[:danger] = "У Вас нет прав для просмотра заявок!"
      redirect_back_or current_user
      false
    end
  end
end
