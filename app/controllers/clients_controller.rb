#coding: utf-8

class ClientsController < ApplicationController
  def new
    @client = Client.new
    @title  = "Добавление клиента"
  end

  def create
    @client = Client.new(params[:client])
    if @client.save!
      flash[:success] = "Новый клиент добавлен!"
      redirect_to clients_path 
    else
      @title = "Добавление клиента"
      render 'new'
    end
  end
  
   def index
    @title  = "Список клиентов"
    @clients  = Client.paginate(:page =>  params[:page])
  end
  
    
  def edit
    @client = Client.find(params[:id])
    @title = "Редактирование информации о клиенте"
  end
  
   def show
    @client   = Client.find(params[:id])
    @title  = @client.name
    set_cur_client(@client)
  end
end
