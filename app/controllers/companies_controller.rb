#coding: utf-8
class CompaniesController < ApplicationController
  before_filter :authenticate,  :only => [:edit, :update, :index, :destroy]
  def new
    @title = "Добавление компании"
    @company   = Company.new
  end
  
  def index
    @title = "Список компаний:"
    @companies  = Company.paginate(:page =>  params[:page])
  end
  
  def create
    @company = Company.new(params[:company])
    if @company.save
      # Обработка успешного сохранения.
     
      flash[:success] = "Компания успешно добавлена"
      redirect_to companies_path
    else
      @title = "Список компаний:"
      render 'new'
    end
  end



private
  def authenticate
    deny_access unless signed_in?
  end
end
