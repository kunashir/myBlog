#coding: utf-8
class RatesController < ApplicationController
	
	def check_user
		 if (!manager?) and (!is_admin?)
			flash[:error] = "Нет прав для доступа к справочнику тарифов!"
			redirect_to current_user
			return false
		end
		return true
	end
	
	def new 
		if !check_user
			return
		end
		@rate  		= Rate.new
		@title    	= "Добавление тарифа"
	end

	def create
		if !check_user
			return
		end
		@rate = Rate.new(params[:rate])
		if @rate.save!
			flash[:success] = "Новый тариф добавлен!"
			redirect_to rates_path 
		else
			@title = "Добавление тарифа"
			render 'new'
		end
	end
	
	def index
		@title  = "Все пользователи системы"
		@rates  = Rate.paginate(:page =>  params[:page])
	end
	
	def edit
		if !check_user
			return
		end
		@rate = Rate.find(params[:id])
		@title = "Изменить тариф"
	end
	
	def update
	
		if !check_user
			return
		end
		@rate = Rate.find(params[:id])
		if @rate.update_attributes!(params[:rate])
			flash[:success] = "Тариф обновлен."
			redirect_to rates_path
		else
			@title = "Изменить профиль"
			render 'edit'
		end
	end
end
