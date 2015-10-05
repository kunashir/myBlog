#coding: utf-8
class DriversController < ApplicationController
  def new
    @driver = Driver.new
    @title = "Добвление нового водителя"
   
  end
  
  def create
    @driver = Driver.new(driver_params)
    @driver.company = current_user.company
    if @driver.save!
      # Обработка успешного сохранения.
      flash[:success] = "Новый водитель добавлен!"
      redirect_to drivers_path 
    else
      @title = "Добвление нового водителя"
      render 'new'
    end
  end
  
  def index
    @title  = "Водители"
    @drivers  = Driver.company_driver(current_user.company).paginate(:page =>  params[:page])
  end

private
  def driver_params
    params.require(:driver).permit(:name, :passport)
  end

end
