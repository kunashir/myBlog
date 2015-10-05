#coding: utf-8
class CompaniesController < ApplicationController
  #before_filter :authenticate,  :only => [:edit, :update, :index, :destroy]
  def new
    @title = "Добавление компании"
    @company   = Company.new
  end

  def index
    @title = "Список компаний:"
    @companies  = Company.page(params[:page])
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      # Обработка успешного сохранения.

      flash[:success] = "Компания успешно добавлена"
      #redirect_to companies_path

      redirect_back_or companies_path
    else
      @title = "Список компаний:"
      render 'new'
    end
  end



private
  def company_params
    params.require(:company).permit(:name, :inn, :is_freighter)
  end
end
