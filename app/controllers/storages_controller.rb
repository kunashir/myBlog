#coding: utf-8
class StoragesController < ApplicationController
  def new 
    @storage  = Storage.new
    @title    = "Новый склад"
  end

   def create
    @storage = Storage.new(params[:storage])
    @storage.client = get_cur_client
    city  = City.find(params[:storage][:city_id])
    @storage.name = city.name
    if @storage.save!
      flash[:success] = "Новый склад добавлен!"
      redirect_to get_cur_client 
    else
      @title = "Добавление склада клиента"
      render 'new'
    end
  end
  
private

  def storage_params
    params.require(:storage).permit(:city, :address)
  end
  
end
