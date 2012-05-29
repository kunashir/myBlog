#coding: utf-8
class StoragesController < ApplicationController
  def new 
    @storage  = Storage.new
    @title    = "Новый склад"
  end

   def create
    @storage = Storage.new(params[:storage])
    @storage.client_id = get_cur_client
    if @storage.save!
      flash[:success] = "Новый клиент добавлен!"
      redirect_to storages_path 
    else
      @title = "Добавление клиента"
      render 'new'
    end
  end
  
  
end
