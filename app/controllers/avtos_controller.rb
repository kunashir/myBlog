#coding: utf-8
class AvtosController < ApplicationController
  def new
    @avto = Avto.new
    @title = "Добвление нового авто"
   
  end
  
  def create
    @avto = Avto.new(avots_params)
    @avto.company = current_user.company
    if @avto.save!
      # Обработка успешного сохранения.
      flash[:success] = "Новая машина добавлена!"
      redirect_to avtos_path 
    else
      @title = "Добвление нового авто"
      render 'new'
    end
  end
  
  def index
    @title  = "Подвижной парк"
    @avtos  = Avto.company_avto(current_user.company).paginate(:page =>  params[:page])
  end

private

  def avots_params
    params.require(:avto).permit(:model, :carcase, :statenumber, :trailnumber)
  end

end
